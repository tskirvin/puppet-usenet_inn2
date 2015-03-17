# usenet_inn2::readers::auth::fragment
#
#   Generate an 'auth' entry in /etc/news/readers/auth.conf (or equivalent).
#   Uses concat::fragment to do the merging.
#
#   Please see readers.conf(5) for details on each parameter.
#
# == Parameters
#
#   ensure    String.  'present' or 'absent'; default 'present'.
#   access    String.  No default.
#   auth      String.  Default: ''
#   comment   String.  Default: ''
#   hosts     String.  Default: ''
#   order     String.  Default: ''
#
# == Usage
#
#   usenet_inn2::readers::auth::fragment { '<name>':
#     ensure      => present | absent,
#     access      => <user-group>,      # matches 'default'
#     auth        => [ '<script-to-run>' ],
#     comment     => [ '<comment>' ],
#     hosts       => [ <host-list> ],
#     order       => [ <sort-string> ]
#   }
#
# Please see the readers.conf man page for details on the proper keys and
# values.  Note that we are only implementing a small sub-set of possible
# options; this is a difficult file!

define usenet_inn2::readers::auth::fragment (
  $ensure      = 'present',
  $access      = undef,
  $auth        = '',
  $comment     = '',
  $hosts       = '*',
  $order       = 20
) {
  validate_string ($order)
  validate_string ($ensure, $access, $auth, $comment, $hosts)

  include usenet_inn2::readers

  $config = $usenet_inn2::readers::config

  $o = 300 + $order

  concat::fragment { "auth-${name}":
    ensure  => $ensure,
    target  => $config,
    order   => $o,
    content => template ('usenet_inn2/fragments/readers_auth.conf.erb'),
  }
}
