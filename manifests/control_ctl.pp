# usenet_inn2::control_ctl
#
#   Create and manage /etc/news/control.ctl.local (or similar).  This file is
#   used to manage newgroup/rmgroup/checkgroups messages on a per-hierarchy
#   basis.  It supplements /etc/news/control.ctl, which is provided by the main
#   package install.
#
#   The underlying file is managed with the 'concat' module.  Stanzas are
#   created using the usenet_inn2::control_ctl::fragment definition.
#
# == Usage
#
#   Defaults come from usenet_inn2::params
#
#   class { 'usenet_inn2::control_ctl':
#     $news_group => [ '<unix-group>' ],
#     $news_user  => [ '<unix-user>' ],
#     $path_conf  => [ '<path-to-files>' ]
#   }
#
class usenet_inn2::control_ctl (
  $news_group = $usenet_inn2::params::news_group,
  $news_user  = $usenet_inn2::params::news_user,
  $path_conf  = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  validate_string ($news_group, $news_user, $path_conf)

  $config = "${path_conf}/control.ctl.local"

  concat { $config: owner => $news_user, group => $news_group, mode  => 0644 }

  concat::fragment { 'control.ctl.local_header':
    target  => $config,
    content => template ('usenet_inn2/control.ctl.local.erb'),
    order   => 01
  }
}
