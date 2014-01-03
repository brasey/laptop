#!/usr/bin/perl

#######################################################################
#
# jnc: a wrapper for the Juniper network connect client (ncsvc)
# Copyright (C) 2009-2010  Klara Mall, iwr91@rz.uni-karlsruhe.de
# Version: 0.16
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################
#
# Requires: openssl 
#	    (java, if you want to use the GUI, which is the default)
#
# Usage: see 'jnc --help' 
#######################################################################

# this configuration is for execution as the user who
# has downloaded network connect via web browser
my $ncdir = "$ENV{'HOME'}/.juniper_networks/network_connect";
my $configdir = "$ncdir/config";

#######################################################################

use strict;
use POSIX qw(setsid);

my $im = "jnc";

# need sbin for ifconfig command
$ENV{'PATH'} = "$ncdir:/sbin:/usr/sbin:$ENV{'PATH'}";
$ENV{'LANG'} = "C";

my ($configfile, $config);
my $gui = 1;
my $loglevel = 3;

&readargs;

if ($gui and not $ENV{'DISPLAY'}) {
   print "DISPLAY environment variable is not set. Use option --nox.\n\n";
   &help;
   exit(1);
}

# check if ncsvc is already running
if(`ps -A | awk '{ print \$4 }' | grep '^ncsvc\$'`) {
  print "Not starting, because ncsvc is already running. Try '$im stop'.\n";
  exit(1);
}

# read config file including certificate handling
my %config = &config($config);
my $password = $config{'password'};
my $ncsvc_args = "-h $config{'host'} -u \"$config{'user'}\" -f \"$config{'certfile'}\" -L $loglevel";
if ($config{'realm'}) {
  $ncsvc_args .= " -r \"$config{'realm'}\"";
}

if (!$password) {
  system "stty -echo";
  print "Password: ";
  $password = <STDIN>;
  chop $password;
  system "stty echo";
  print "\n";
}

print "Connecting to $config{'host'} : 443.\n";

# save network interfaces' status before starting ncsvc
my %inet_addr = &inet_addr;
my @ifs_orig = keys %inet_addr;

pipe (FROM_PARENT, TO_NCSVC);
pipe (FROM_NCSVC, TO_PARENT);

# ncsvc bug: /etc/resolv.conf will have permissions according to umask
umask 022;

$SIG{CHLD} = 'IGNORE';
$SIG{PIPE} = \&exec_ncsvc_failed; 

my $pid = fork;
die "Couldn't fork: $!" unless defined $pid;

if ($pid == 0)  {
    POSIX::setsid();
   
    chdir $ncdir;

    close FROM_NCSVC;
    close TO_NCSVC;

    close  STDIN;
    open  (STDIN,  '<&FROM_PARENT') or die ("open: $!");

    close STDOUT;
    open  (STDOUT, '>&TO_PARENT') or die ("open: $!"); 

    close  STDERR;
    open  (STDERR, '>&STDOUT') or die;

    select STDERR;   $| = 1;
    select STDOUT;   $| = 1;
	 
    if($gui) {
      exec join (' ', "java -cp $ncdir/NC.jar NC", $ncsvc_args);
    }
    else {
      exec join (' ', "ncsvc", $ncsvc_args);
    }

}

close FROM_PARENT;
close TO_PARENT;

select STDOUT;   $| = 1;
select STDERR;   $| = 1;

sleep 1;
print TO_NCSVC $password, "\n";
close TO_NCSVC;
close FROM_NCSVC;

# if we have no gui check if ncsvc is running and if tun interface came up
if(not $gui) {
  my (@ifs, $if, $if_old, $tunif);
  %inet_addr = &inet_addr;
  @ifs = keys %inet_addr;
  print "Waiting for ncsvc for 3 seconds... ";
  sleep 3;
  while (1) {
    if (($#ifs - $#ifs_orig) == 0) {
      if(`ps -A | awk '{ print \$1 ":" \$4 }' | grep ':ncsvc\$'`){
        print "done\nncsvc is running, but tunnel is not established yet. Waiting for 3 seconds... ";
        sleep 3;
        %inet_addr = &inet_addr;
        @ifs = keys %inet_addr;
      }
      else {
        print "done: ncsvc exited.\n";
	print "Wrong host/user/password/realm/certfile? Is ncsvc binary available?\n";
        exit(1);
      }
    }
    elsif (($#ifs - $#ifs_orig) == 1) {
      foreach $if (@ifs) {
        my $found = 0;
        foreach $if_old (@ifs_orig) {
	 if ($if eq $if_old) { $found = 1; last; }
        }
        if (not $found) {
	 print "done.\nncsvc is running in background (PID: $pid):\n";
	 print "tunnel interface $if, addr: ",$inet_addr{$if},"\n";
	 exit(0);
        }
      }
    }
    else {
      print "done.\nncsvc is running in background (PID: $pid):\n";
      print "something strange happened to the number of your interfaces, check manually.\n"
    }
  }
}

exit(0);


sub help {
print <<HELP;
Usage: $im [OPTIONS]... [CONFIG]		  
       $im stop (stop all running ncsvc clients)
jnc: a wrapper for the Juniper network connect client (ncsvc)

-n, --nox	  start without Java GUI
-c, --confidr	  directory which contains the config files 
		  (default: 
		  ~/.juniper_networks/network_connect/config)
-l, --loglevel	  loglevel (0-5, default: 3) 
-h, --help	  print this help message

CONFIG: setting foo as CONFIG: config file is 
	confdir/foo.conf. if CONFIG is omitted, config file
	is confdir/default.conf

Example config file:
------------------------ %< ----------------------------- 
host=foo.bar.com
user=username
password=secret
realm=very long realm with spaces 
cafile=/etc/ssl/bar-chain.pem
certfile=
------------------------ %< ----------------------------- 
password and realm are optional.
cafile: ca chain to verify the host certificate
certfile: host certificate in DER format
cafile or certfile must be configured.

HELP
}

sub readargs {
  if ($#ARGV == -1) {
    $config = "$configdir/default.conf";
  }
  
  if ($#ARGV == 0 ) {
    if ($ARGV[0] eq "stop") {
      &ncstop;
    }
  }
  
  my $options = 1;
  my $arg;
  for (my $i=0; $i <= $#ARGV; $i++) {
    $arg = $ARGV[$i]; 
  
    if ($arg eq "--") {
      $options = 0;
    }
    elsif (($arg eq "--nox" or $arg =~ /^-n(.*)$/) and $options) {
      $gui = 0;
      if($arg =~ /^-n(.+)$/) {
        $ARGV[$i] = "-$1";
        $i--;
      }
    }
    elsif (($arg =~ /^--confdir/ or $arg =~ /^-c(.*)$/) and $options) {
      if($arg =~ /^-c(.+)$/) {
        $configdir = $1;
      }
      elsif($arg =~ /^--confdir=(.*)/) {
        $configdir = $1;
      }
      else {
        $i++;
        $configdir = $ARGV[$i];
      }
    }
    elsif (($arg =~ /^--loglevel/ or $arg =~ /^-l/) and $options) {
      if($arg =~ /^-l([0-5])$/) {
        $loglevel = $1;
      }
      elsif($arg =~ /^--loglevel=(.*)/) {
        $loglevel = $1;
      }
      else {
        $i++;
        $loglevel = $ARGV[$i];
      }
    }
    elsif (($arg eq "--help" or $arg eq "-h") and $options) {
      &help;
      exit(0);
    }
    elsif ($arg =~ /^-/ and $options) {
      print "$im: unrecognized option '$arg'\n";
      print "Try `$im --help' for more information.\n";
      exit(1);
    }
    else {
      $configfile = "$arg.conf";
    }
  }
  
  if ($configdir =~ /^(.*)\/$/) {
    $configdir = $1;
  }
  if(!$configfile) { $config = "$configdir/default.conf"; }
  else { $config = "$configdir/$configfile"; }
}

sub config {
  my $config = $_[0];
  open CONF, "$config" or die "Could not open config file $config.\n";

  my ($hash, $value,%conf);
  while (<CONF>) {
    next if /^#/ or /^$/;
    chomp;
    ($hash, $value) = split /=/;
    $hash =~ s/^\s*(.*)\s*$/$1/;
    $value =~ s/^\s*(.*)\s*$/$1/;
    $value =~ s/^"(.*)"$/$1/;
    $conf{$hash} = $value;
  }
  close CONF;

  if (! $conf{'host'}) { die "No host configured in $config.\n"; }
  if (! $conf{'user'}) { die "No user configured in $config.\n"; }
  if (! $conf{'certfile'} and ! $conf{'cafile'}) { die "Neither certfile nor cafile configured in $config.\n"; }

  if(!$conf{'certfile'}) {
    if($conf{'cafile'} !~ /\//) {
      $conf{'cafile'} = "$configdir/$conf{'cafile'}";
    }
    if (-e $conf{'cafile'}) {
      $conf{'certfile'} = &getcert($configdir, $conf{'host'}, $conf{'cafile'});
      return %conf;
    }
    else {
      print "CA file $conf{'cafile'} does not exist. Exiting.\n";
      exit(1);
    }
  }
 
  if($conf{'certfile'} !~ /\//) {
    $conf{'certfile'} = "$configdir/$conf{'certfile'}";
  }

  if (! -e $conf{'certfile'}) {
    print "Certificate file $conf{'certfile'} does not exist. Exiting.\n";
    exit(1);
  }
  
  return %conf;
}

sub printcert {
  my $out = $_[0];
  my $pemfile = $_[1];
  my @output = split (/\n/, $out);
  open (CERT, ">$pemfile") or die "Could not open $pemfile.\n";
  my $in = 0;
  foreach (@output) {
    if (!$in and not /^-----BEGIN CERTIFICATE-----$/) { next; }
    elsif (/^-----BEGIN CERTIFICATE-----$/) {
      print CERT $_, "\n";
      $in = 1;
    }
    elsif ($in and not /^-----END CERTIFICATE-----$/) {
      print CERT $_, "\n";
    }
    else {
      print CERT $_, "\n";
      close CERT;
      last;
    }
  }
}

sub getcert {
  my $configdir = $_[0];
  my $host = $_[1];
  my $cafile = $_[2];
  my $pemfile = "$configdir/$host.pem";
  my $derfile = "$configdir/$host.der";

  my $out = `openssl s_client -connect $host:443 -CAfile $cafile < /dev/null 2> /dev/null`;
  $_ = $out;
  s/\n//g;
  /\s*Verify return code: ([0-9]+?) \((.*?)\).*/;
  my $rc = $1;
  my $reason = $2;
  if($rc eq "") { 
      print "An error occurred while downloading the certificate. Check your internet connection.\n";
      exit(1);
  }
  if ($rc == 0) {
    &printcert($out, $pemfile);
    $_ = `openssl x509 -text -in $pemfile | grep 'Subject.*CN'`;
    chop;
    s/.*CN=(.*)$/$1/;
    my $cn = $_;
    if ($cn eq $host) {
      print "Server certificate verified and CN is $host. Saving in $derfile.\n";
      system("openssl x509 -in $pemfile -outform der -out $derfile");
      unlink "$pemfile";
      return $derfile;
    }
    else {
      print "Server certificate verified but CN $cn differs from host name $host. Exiting.\n";
      unlink "$pemfile";
      exit(1);
    }
  }
  else {
    print "Server certificate could not be verified. Reason: $reason.\n";
    print "Do you want to continue? (yes/no) ";
    my $answer=<STDIN>;
    chomp ($answer);
    if ($answer eq "yes") {
      &printcert($out, $pemfile);
      print "Saving certificate in $derfile.\n";
      system("openssl x509 -in $pemfile -outform der -out $derfile");
      unlink "$pemfile";
      return $derfile;
    }
    else {
      print "Exiting.\n";
      exit;
    }
  }
}

sub inet_addr {
  my $ifs = `ifconfig`;
  my @ifs = split (/\n\n/,$ifs);
  my ($if, $inet_addr, %inet_addr);
  foreach (@ifs) {
    s/\n//g;
    $if = $_;
    $inet_addr = $_;
    $if =~ s/^(.*?)\s.*/$1/;
    $inet_addr =~ s/.*inet addr:(.*?)\s.*/$1/;
    $inet_addr{$if} = $inet_addr;
  }
  return %inet_addr;
}

sub ncstop {
  my $pid;
  $ENV{'PATH'} = "$ncdir:$ENV{'PATH'}";

  if($pid=`ps -A | awk '{ print \$1 ":" \$4 }' | grep -m1 ':ncsvc\$' | sed 's/\\(.*\\):.*/\\1/'`) {
    print "ncsvc is running, sending signal... ";
    system("ncsvc -K");
      if($pid=`ps -A | awk '{ print \$1 ":" \$4 }' | grep ':ncsvc\$' | sed 's/\\(.*\\):.*/\\1/'` ) {
	print "\nCould not kill all ncsvc processes, try \"killall -9 ncsvc\" as root.\n";
	exit(1);
      }
      else {
	print "terminated.\n";
	exit(0);
      }
    
  }
  else {
    print "No running ncsvc found.\n";
    exit(0);
  }
}

sub exec_ncsvc_failed {
  print "Execution of NC.jar/ncsvc failed.\n";
  exit(1);
}
