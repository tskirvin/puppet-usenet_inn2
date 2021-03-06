# usenet_inn2::readers
#
#   Create and manage /etc/news/readers.conf (or similar).  This file defines
#   who is able to read news from the server and with what permissions.
#
#   The underlying file is managed with the concat module.  There are two types
#   of stanzas: 'auth', created with usenet_inn2::readers::auth::fragment, and
#   'access', created with usenet_inn2::readers::access::fragment.
#
# == Usage
#
#   Defaults come from usenet_inn2::params
#
#   class { 'usenet_inn2::readers':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }
#
class usenet_inn2::readers (
  String $news_group = $usenet_inn2::params::news_group,
  String $news_user  = $usenet_inn2::params::news_user,
  String $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  $config = "${path_conf}/readers.conf"

  concat { $config: owner => $news_user, group => $news_group, mode => '0644' }

  concat::fragment { 'readers_header':
    target  => $config,
    content => "## ${config} - managed with puppet\n\n",
    order   => 000
  }

  concat::fragment { 'readers_auth_header':
    target  => $config,
    content => "\n###\n### Authorization Area ###\n###\n\n",
    order   => 100
  }

  concat::fragment { 'readers_access_header':
    target  => $config,
    content => "\n###\n### Access Area ###\n###\n\n",
    order   => 600
  }
}
