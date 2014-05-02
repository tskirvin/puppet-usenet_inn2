class usenet_inn2::nocem::gpg (
) inherits usenet_inn2::params {

  $gpg_opts = "--no-default-keyring --no-options --allow-non-selfsigned-uid --no-permission-warning"
  $keyring = "${path_conf}/pgp/ncmring.gpg"

  exec { "nocem-gpg import":
    command     => "/bin/rm -f ${keyring} && gpg ${gpg_opts} --primary-keyring ${keyring} --import ${path_conf}/pgp/nocem/*",
    creates     => $keyring,
    notify      => File[$keyring]
  }

  file { 
    $keyring: 
      require => Exec['nocem-gpg import'],
      mode    => 644;
    "${path_conf}/pgp/nocem":
      source  => 'puppet:///modules/usenet_inn2/etc/news/pgp/nocem',
      recurse => true,
      notify  => Exec['nocem-gpg import'],
  }
}
