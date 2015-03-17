# usenet_inn2::ctlinnd (definition)
#
#   Restart or reconfigure INN after config files change, using an exec
#   subscribed to a particular file's change.  See ctlinnd(8) for details.
#
# == Parameters
#
#   action    String: either 'reload' or 'flush'.  No default, required.
#   file      String: file resource name to watch; if it changes, we'll
#             actually run the exec.  File resource must already be defined.
#             No default, required.
#   keyword   String. Text to include in the ctlinnd comment field.
#
# == Usage
#
#   usenet_inn2::ctlinnd { 'reload incoming':
#     action  => 'reload',
#     file    => '/etc/news/incoming.conf',
#     keyword => 'incoming'
#   }
#
define usenet_inn2::ctlinnd (
  $action  = undef,
  $file    = undef,
  $keyword = undef
) {
  validate_string ($action, $file, $keyword)

  case $action {
    flush:  { $ctlcommand = "/usr/sbin/ctlinnd flush '${keyword}'" }
    reload: { $ctlcommand = "/usr/sbin/ctlinnd reload '${keyword}' Puppet" }
    default: { fail "unknown ctlinnd command: ${action}" }
  }
  exec { "ctlinnd ${name}":
    command     => $ctlcommand,
    subscribe   => File[$file],
    refreshonly => true,
  }
}
