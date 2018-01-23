# usenet_inn2::readers::auth::fragment
#
#   Generate an 'auth' entry in /etc/news/readers/auth.conf (or equivalent).
#   Uses concat::fragment to do the merging.
#
#   Please see readers.conf(5) for details on each parameter.
#
# == Parameters
#
#   access    String.  No default.
#   auth      String.  Default: ''
#   comment   String.  Default: ''
#   hosts     String.  Default: ''
#   order     String.  Default: ''
#
# == Usage
#
#   usenet_inn2::readers::auth::fragment { '<name>':
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
  String $access,
  String $auth        = '',
  String $comment     = '',
  String $hosts       = '*',
  Integer $order       = 20
) {
  include usenet_inn2::readers

  $config = $usenet_inn2::readers::config

  $o = 300 + $order

  concat::fragment { "auth-${name}":
    target  => $config,
    order   => $o,
    content => template ('usenet_inn2/fragments/readers_auth.conf.erb'),
  }
}
