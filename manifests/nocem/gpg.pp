# usenet_inn2::nocem::gpg
#
#   Create and manage /etc/news/pgp/ncmring.gpg and /etc/news/pgp/nocem/* .
#   The former is also populated with the data from the latter.
#
# == Usage
#
#   include usenet_inn2::nocem::gpg
#
class usenet_inn2::nocem::gpg (
  $path_conf = $usenet_inn2::params::path_conf
) {
  require usenet_inn2::params

  $gpg_opts = '--no-default-keyring --no-options --allow-non-selfsigned-uid --no-permission-warning'
  $keyring = "${path_conf}/pgp/ncmring.gpg"

  exec { 'nocem-gpg import':
    command => "/bin/rm -f ${keyring} && gpg ${gpg_opts} --primary-keyring ${keyring} --import ${path_conf}/pgp/nocem/*",
    creates => $keyring,
    notify  => File[$keyring]
  }

  file { $keyring: require => Exec['nocem-gpg import'], mode => '0644' }

  file { "${path_conf}/pgp/nocem":
    notify  => Exec['nocem-gpg import'],
    recurse => true,
    source  => 'puppet:///modules/usenet_inn2/etc/news/pgp/nocem',
  }
}
