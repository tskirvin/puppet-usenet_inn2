# usenet_inn2::nocem::ctl
#
#   Create and manage /etc/news/nocem.ctl (or similar).  This file defines
#   which NoCeM messages to honor.
#
#   The underlying file is managed with the 'concat' module.  Stanzas are
#   created using the usenet_inn2::nocem::fragment definition.
#
# == Usage
#
#   Defaults come from usenet_inn2::params
#
#   class { 'usenet_inn2::nocem::ctl':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }
#
class usenet_inn2::nocem::ctl (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) {
  require usenet_inn2::params

  $config = "${path_conf}/nocem.ctl"

  concat { $config:
    owner => $news_user,
    group => $news_group,
    mode  => 0644;
  }

  concat::fragment { 'nocem.ctl.local_header':
    target  => $config,
    content => "## ${config} - managed with puppet\n\n",
    order   => 01
  }
}
