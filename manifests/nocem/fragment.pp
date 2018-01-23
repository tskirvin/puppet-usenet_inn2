# usenet_inn2::nocem::fragment (definition)
#
#   Generate an entry in /etc/news/nocem.ctl (or equivalent).  Uses
#   concat::fragment to do the merging.
#
#   Please see the perl-nocem man page for details on the proper values for
#   issuer/type.
#
# == Parameters
#
#   issuer     => '<address>',
#   type       => '<nocem-type>'
#
# == Usage
#
#   usenet_inn2::nocem::fragment { 'foobar':
#     issuer => 'foo@bar.invalid',
#     type   => 'testing'
#   }
#

define usenet_inn2::nocem::fragment (
  String $issuer,
  String $type,
) {

  include usenet_inn2::nocem::ctl

  $config = $usenet_inn2::nocem::ctl::config

  concat::fragment { $name:
    target  => $config,
    content => "# ${name}\n${issuer}:${type}\n\n";
  }
}
