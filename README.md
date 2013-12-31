laptop
======

Set up a new laptop.

Do these things.

```
sudo yum -y install puppet git
ssh-keygen
ssh-copy-id pi@10.0.0.18
sudo git clone https://github.com/brasey/laptop.git /etc/puppet/modules
sudo puppet module install puppetlabs/stdlib
sudo puppet apply /etc/puppet/modules/profile/manifests/init.pp
```
