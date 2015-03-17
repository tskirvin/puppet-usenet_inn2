# usenet_inn2::distrib_pats::fragment (definition)
#
#   Generate an entry in /etc/news/distrib.pats (or equivalent).  Uses
#   concat::fragment to do the merging.
#
#   Please see the distrib.pats man page for details on weight/pattern/value.
#
# == Usage
#
#   usenet_inn2::distrib_pats::fragment { '<name>':
#     ensure  => present | absent,
#     order   => [ '<count>' ],
#     pattern => '<pattern>',
#     value   => '<value>'
#     weight  => '<number>'
#   }
#
define usenet_inn2::distrib_pats::fragment (
  $ensure  = 'present',
  $order   = 'NONE',
  $pattern = undef,
  $value   = undef,
  $weight  = undef
) {
  include usenet_inn2::distrib_pats
  validate_string ($ensure, $order, $pattern, $value, $weight)

  $config = $usenet_inn2::distrib_pats::config

  if ($order == 'NONE') { $o = undef } else { $o = $order }

  concat::fragment { "dist_${name}":
    ensure  => $ensure,
    target  => $config,
    content => "${weight}:${pattern}:${value}\n",
    order   => $o
  }
}
