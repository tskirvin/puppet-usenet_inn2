# usenet_inn2::expire::fragment (definition)
#
#   Generate an entry in /etc/news/expire.ctl (or equivalent).  Uses
#   concat::fragment to do the merging.
#
#   See expire.ctl(5) for more details.
#
# == Parameters
#
#   comment       String: comment.  Default: ''
#   days_default  String: default number of days after which to expire
#                 articles, or 'never'.  Default: '30'
#   days_max      String: maximum number of days after which to expire
#                 articles, or 'never',  Default: 'never'
#   days_min      String: minimum number of days after which to expire
#                 articles, or 'never',  Default: '1'
#   flag          String: 'M' | 'U' | 'A' | 'MX' | 'UX' | 'AX'.  Default: 'A'
#   pattern       String: matching-group-pattern>  Default: '*'
#
# == Usage
#
#   usenet_inn2::expire::fragment { 'default':
#     pattern      => '*',
#     comment      => 'keep for 1-100 days, allow Expires to work',
#     days_default => '100',
#     days_min     => '1',
#     days_max     => '365',
#   }
#
define usenet_inn2::expire::fragment (
  String $pattern      = '*',
  String $flag         = 'A',
  String $comment      = '',
  String $days_min     = '1',
  String $days_default = '30',
  String $days_max     = 'never'
) {
  include usenet_inn2::expire

  $config = $usenet_inn2::expire::config

  concat::fragment { "expire-${name}":
    target  => $config,
    content => template ('usenet_inn2/fragments/expire.ctl.erb'),
  }
}
