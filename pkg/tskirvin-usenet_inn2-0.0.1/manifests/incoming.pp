# Create and manage /etc/news/incoming.conf (or similar).  This file defines 
# which articles are received from which servers.
#
# The underlying file is managed with the concat module and the template
# incoming.conf.erb .  Also, when changes are made to the config file, we will
# run 'ctlinnd reload incoming.conf' (as defined in usenet_inn2::ctlinnd).
#
# Stanzas are created using the usenet_inn2::peer definition.
# 
# Usage (defaults come from usenet_inn2::params):
#
#   class { 'usenet_inn2::incoming':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }
#
class usenet_inn2::incoming (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  include concat::setup

  $config = "${path_conf}/incoming.conf"

  concat { $config:
    owner => $news_user,
    group => $news_group,
    notify => Exec["ctlinnd reload incoming"],
    mode  => 0644;
  }

  usenet_inn2::ctlinnd { 'reload incoming':
    action  => 'reload',
    keyword => 'incoming.conf',
    file    => $config
  }

  concat::fragment { 'incoming_header':
    target  => $config,
    content => template ('usenet_inn2/incoming.conf.erb'),
    order   => 01
  }
}
