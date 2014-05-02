# Manage GPG keys for a Usenet server.  Creates a directory full of PGP keys
# (there is a large set of defaults) and combines them all with 'gpg --import'.

# Usage:
#
#   class { 'usenet_inn2::gpg': path_conf => DIRECTORY }
# 
# If you want to add more keys, you can add them (with puppet) to 
# /etc/news/gpg/keys (or wherever you put your conf directory).
#
# Note: we don't really have a way of *removing* keys at the moment, besides
# removing /etc/news/gpg/pubring.gpg (or equivalent) manually.

class usenet_inn2::gpg (
  $path_conf = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {

  $gpg_opts = "--no-default-keyring --no-options --allow-non-selfsigned-uid --no-permission-warning"
  $keyring = "${path_conf}/pgp/pubring.gpg"

  # Generate our control message signer keyring from all the individual
  # saved public keys.
  exec { "gpg import":
    command     => "/bin/rm -f ${keyring} && gpg ${gpg_opts} --primary-keyring ${keyring} --import ${path_conf}/pgp/keys/*",
    creates     => $keyring,
    notify      => File["${path_conf}/pgp/pubring.gpg"],
  }

  file {
    "${path_conf}/pgp":
      ensure => directory,
      mode   => 711,
      owner  => root,
      group  => root;
    $keyring:
      require => Exec['gpg import'],
      mode    => 644;
    "${path_conf}/pgp/keys":
      source  => 'puppet:///modules/usenet_inn2/etc/news/pgp/keys',
      recurse => true,
      notify  => Exec['gpg import'],
  }
}
