# Auto-restart INN after config files change; actual details are in
# per-system-type configs.  
define usenet_inn2::ctlinnd($action, $keyword, $file) {
  case $action {
    flush:  { $ctlcommand = "/usr/sbin/ctlinnd flush '$keyword'" }
    reload: { $ctlcommand = "/usr/sbin/ctlinnd reload '$keyword' Puppet" }
  }
  exec { "ctlinnd $name":
    command     => $ctlcommand,
    subscribe   => File[$file],
    refreshonly => true,
  }
}
