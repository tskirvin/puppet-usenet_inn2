# Create and manage /etc/news/innfeed.conf (or similar).  This file defines 
# the hosts that we send files to via innfeed.
#
# The underlying file is managed with the concat module and the template
# innfeed.conf.erb . 
# 
# Stanzas are created using the usenet_inn2::peer definition.
# 
# Usage (defaults come from usenet_inn2::params):
#  
#   class { 'usenet_inn2::innfeed':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   } 
#   
class usenet_inn2::innfeed (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  include concat::setup

  $config = "${path_conf}/innfeed.conf"

  concat { $config:
    owner => $news_user,
    group => $news_group,
    mode  => 0644;
  }

  concat::fragment { 'innfeed_header':
    target  => $config,
    content => template ('usenet_inn2/innfeed.conf.erb'),
    order   => 01
  }
}
