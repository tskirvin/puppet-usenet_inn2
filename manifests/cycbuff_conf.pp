# Create and manage /etc/news/distrib.pats (or similar).  This file is used to
# set the default value of the Distribution: header, depending on hierarchy.
#
# The underlying file is managed with the 'concat' module.  Stanzas are created
# using the usenet_inn2::distib_pats::fragment definition.
# 
# Usage (defaults come from usenet_inn2::params):
#
#   class { 'usenet_inn2::cycbuff_conf':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }

class usenet_inn2::cycbuff_conf (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {

  $config = "${path_conf}/cycbuff.conf"

  concat { $config:
    owner => $news_user,
    group => $news_group,
    mode  => 0644;
  }

  concat::fragment { 'cycbuff_conf_header':
    target  => $config,
    content => "## $config - managed with puppet\n\n",
    order   => 01
  }
}
