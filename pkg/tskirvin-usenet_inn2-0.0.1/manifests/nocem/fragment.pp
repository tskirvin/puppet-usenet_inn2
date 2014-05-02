# Generate an entry in /etc/news/nocem.ctl (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::nocem::fragment { '<name>':
#     ensure     => present | absent,
#     issuer     => '<address>',
#     type       => '<nocem-type>'
#   }
#
# Please see the perl-nocem man page for details on the proper values for 
# issuer/type.

define usenet_inn2::nocem::fragment (
  $ensure     = 'present',
  $issuer,
  $type
) {
  include usenet_inn2::nocem::ctl

  $config = $usenet_inn2::nocem::ctl::config

  concat::fragment { $name:
    ensure  => $ensure,
    target  => $config,
    content => "# ${name}\n${issuer}:${type}\n\n";
  }
}
