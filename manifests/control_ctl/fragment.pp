# Generate an entry in /etc/news/control.ctl.local (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::control_ctl::fragment { '<name>':
#     ensure     => present | absent,
#     message    => 'newgroup' | 'rmgroup' | 'checkgroups' | <other>,
#     from       => '<address>',
#     newsgroups => '<pattern>',
#     action     => 'doit' | 'drop' | 'log' | 'verify-pgp_userid'
#   }
#
# Please see the control.ctl man page for details on the proper values for 
# message/from/newsgroups/action.

define usenet_inn2::control_ctl::fragment (
  $ensure     = 'present',
  $message,
  $from,
  $newsgroups,
  $action
) {
  include usenet_inn2::control_ctl

  $config = $usenet_inn2::control_ctl::config

  concat::fragment { $name:
    ensure  => $ensure,
    target  => $config,
    content => template ('usenet_inn2/fragments/control.ctl.erb'),
  }
}
