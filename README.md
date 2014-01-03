laptop
======

## Summary
Set up a new laptop.

## Steps
Do these things.

```bash
sudo yum -y install puppet git
ssh-keygen
ssh-copy-id pi@10.0.0.18
sudo git clone https://github.com/brasey/laptop.git /etc/puppet/modules
sudo puppet module install puppetlabs/stdlib
sudo puppet apply /etc/puppet/modules/profile/manifests/init.pp
```

## Caveats
Currently, my username is hard coded. That should change.

I'm backing up some things that this Puppetry uses ssh to restore. Things are
* .gnupg
* .purple
* .thunderbird
* .local/share/keyrings (Seahorse keyrings)
* .ssh
