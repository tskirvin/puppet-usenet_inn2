# Create and manage /etc/news/newsfeeds (or similar).  This file is used to
# decide which articles should be sent to which servers/scripts, and by which 
# protocol.
#
# The underlying file is managed with the concat module and the template
# newsfeeds.erb .  Also, when changes are made to the newsfeeds file, we will
# run 'ctlinnd reload newsfeeds' (as defined in usenet_inn2::ctlinnd):
# 
# Stanzas are created using the usenet_inn2::peer definition.
# 
# Usage (defaults come from usenet_inn2::params):
#  
#   class { 'usenet_inn2::newsfeeds':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   } 
#   
class usenet_inn2::newsfeeds (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  include concat::setup

  $config = "${path_conf}/newsfeeds"

  concat { $config:
    owner  => $news_user,
    group  => $news_group,
    notify => Exec["ctlinnd reload newsfeeds"],
    mode   => 0644;
  }

  usenet_inn2::ctlinnd { 'reload newsfeeds':
    action  => 'reload',
    keyword => 'newsfeeds',
    file    => $config
  }

  concat::fragment { 'newsfeeds_header':
    target  => $config,
    content => template ('usenet_inn2/newsfeeds.erb'),
    order   => 01
  }
}