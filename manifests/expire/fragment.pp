# Generate an entry in /etc/news/expire.ctl (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::expire::fragment { '<name>':
#     ensure       => present | absent,
#     comment      => [ <comment string> ],
#     days_default => [ <days> | 'never' ],
#     days_max     => [ <days> | 'never' ],
#     days_min     => [ <days> | 'never' ],
#     flag         => [ 'M' | 'U' | 'A' | 'MX' | 'UX' | 'AX' ],
#     pattern      => [ <matching-group-pattern> ]
#   }
#
# Please see the expire.ctl man page for details on the proper keys and
# values.

define usenet_inn2::expire::fragment (
  $ensure       = 'present',
  $pattern      = '*',
  $flag         = 'A',
  $comment      = '',
  $days_min     = '1',
  $days_default = '30',
  $days_max     = 'never'
) {
  include usenet_inn2::expire

  $config = $usenet_inn2::expire::config

  concat::fragment { "expire-$name":
    ensure  => $ensure,
    target  => $config,
    content => template ('usenet_inn2/fragments/expire.ctl.erb'),
  }
}
