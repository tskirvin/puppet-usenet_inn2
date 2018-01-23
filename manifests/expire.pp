# usenet_inn2::expire
#
#   Create and manage /etc/news/expire.ctl (or similar).  This file defines
#   how long it takes to expire articles.
#
#   The underlying file is managed with the concat module and the template
#   expire.ctl.erb .  Also, when changes are made to the config file, we will
#   run 'ctlinnd reload expire.ctl' (as defined in usenet_inn2::ctlinnd).
#
#   Stanzas are created using the usenet_inn2::expire::fragment definition.
#
# == Usage
#
#   Defaults come from usenet_inn2::params
#
#   class { 'usenet_inn2::expire':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ],
#     $remember   => [ '<days>' ]
#   }
#
class usenet_inn2::expire (
  String $news_group = $usenet_inn2::params::news_group,
  String $news_user  = $usenet_inn2::params::news_user,
  String $path_conf  = $usenet_inn2::params::path_conf,
  Integer $remember   = $usenet_inn2::params::article_cutoff
) inherits usenet_inn2::params {
  $config = "${path_conf}/expire.ctl"

  concat { $config:
    owner => $news_user,
    group => $news_group,
    mode  => '0644';
  }

  concat::fragment { 'expire_header':
    target  => $config,
    content => template ('usenet_inn2/expire.ctl.erb'),
    order   => 01
  }
}
