# Generate an entry in /etc/news/distrib.pats (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::distrib_pats::fragment { '<name>':
#     ensure  => present | absent,
#     weight  => '<number>',  
#     pattern => '<pattern>',
#     value   => '<value>'
#     order   => [ '<count>' ]
#   }
#
# Please see the distrib.pats man page for details on weight/pattern/value.

define usenet_inn2::distrib_pats::fragment (
  $ensure     = 'present',
  $weight,  
  $pattern,
  $value,
  $order      = 'NONE'
) {
  include usenet_inn2::distrib_pats

  $config = $usenet_inn2::distrib_pats::config

  if ($order == 'NONE') { $o = undef } else { $o = $order }

  concat::fragment { "dist_$name":
    ensure  => $ensure,
    target  => $config,
    content => "$weight:$pattern:$value\n",
    order   => $o
  }
}
