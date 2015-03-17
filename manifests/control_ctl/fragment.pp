# usenet_inn2::control_ctl::fragment (definition)
#
#   Generate an entry in /etc/news/control.ctl.local (or equivalent).  Uses
#   concat::fragment to do the merging.
#
#   Please see control.ctl(5) for details on each parameter.
#
# == Parameters
#
#   action      String: 'doit', 'drop', 'log', or 'verify-pgp_userid'.
#               No default, required.
#   ensure      String: 'present' or 'absent'.  Default: 'present'.
#   message     String: 'newgroup', 'rmgroup', 'checkgroups', or perhaps
#               something else.  No default, required.
#   from        String: address pattern to match.  No default, required.
#   newsgroups  String: newsgroup pattern to match.  No default, required.
#
# == Usage
#
#   usenet_inn2::control_ctl::fragment { 'foobar-newgroup':
#     message    => 'newgroup',
#     from       => 'foobar-control@example.invalid',
#     newsgroups => 'foobar.*',
#     action     => 'doit'
#   }
#
define usenet_inn2::control_ctl::fragment (
  $ensure     = 'present',
  $action     = undef,
  $message    = undef,
  $from       = undef,
  $newsgroups = undef
) {
  validate_string ($ensure, $action, $message, $from, $newsgroups)

  include usenet_inn2::control_ctl

  $config = $usenet_inn2::control_ctl::config

  concat::fragment { $name:
    ensure  => $ensure,
    target  => $config,
    content => template ('usenet_inn2/fragments/control.ctl.erb'),
  }
}
