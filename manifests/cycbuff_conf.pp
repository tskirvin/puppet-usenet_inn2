# usenet_inn2::cycbuff_conf
#
#   Create and manage /etc/news/cycbuff.conf (or similar).  This file
#   configures the CNFS storage method; see cycbuff.conf(5) for details.
#
#   The underlying file is managed with the 'concat' module.  Stanzas are
#   created using the usenet_inn2::cycbuff::fragment definition.  Actual
#   cnfs buffers are created with usenet_inn2::cycbuff.
#
# == Usage
#
#   Defaults come from usenet_inn2::params
#
#   class { 'usenet_inn2::cycbuff_conf':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }
#
class usenet_inn2::cycbuff_conf (
  String $news_group = $usenet_inn2::params::news_group,
  String $news_user  = $usenet_inn2::params::news_user,
  String $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {

  $config = "${path_conf}/cycbuff.conf"

  concat { $config: owner => $news_user, group => $news_group, mode => '0644' }
  concat::fragment { 'cycbuff_conf_header':
    target  => $config,
    content => "## ${config} - managed with puppet\n\n",
    order   => 01
  }
}
