# Create and manage /etc/news/storage.conf (or similar).  This file is 
# defines where articles are written.  
#
# The underlying file is managed with the 'concat' module.  Stanzas are created
# using the usenet_inn2::storage::fragment definition.
# 
# Usage (defaults come from usenet_inn2::params):
#
#   class { 'usenet_inn2::storage':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }

class usenet_inn2::storage (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  include concat::setup

  $config = "${path_conf}/storage.conf"

  concat { $config:
    owner   => $news_user,
    group   => $news_group,
    notify  => Exec["ctlinnd reload storage.conf"],
    mode    => 0644;
  }

  concat::fragment { 'storage.local_header':
    target  => $config,
    content => "## $config - managed with puppet\n\n",
    order   => 01
  }

  usenet_inn2::ctlinnd { 'reload storage.conf':
    action  => 'reload',
    keyword => 'storage.conf',
    file    => $config
  }


  usenet_inn2::storage::fragment { 'catchall':
    number     => 255,
    storage    => 'timecaf',
    newsgroups => '*'
  }
}
