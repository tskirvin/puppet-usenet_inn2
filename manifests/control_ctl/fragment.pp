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
  $action     = undef,
  $message    = undef,
  $from       = undef,
  $newsgroups = undef
) {

  include usenet_inn2::control_ctl

  $config = $usenet_inn2::control_ctl::config

  concat::fragment { $name:
    target  => $config,
    content => template ('usenet_inn2/fragments/control.ctl.erb'),
  }
}
