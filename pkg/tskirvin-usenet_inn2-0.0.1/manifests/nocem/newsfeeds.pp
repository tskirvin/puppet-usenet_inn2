class usenet_inn2::nocem::newsfeeds (
  $config   = $usenet_inn2::params::path_conf,
  $path_bin = $usenet_inn2::params::path_bin
) inherits usenet_inn2::params {

  $groups = '!*,alt.nocem.misc,news.lists.filters'
  $binary = "${path_bin}/perl-nocem"

  concat::fragment { 'newsfeeds-nocem':
    ensure  => present,
    target  => "${config}/newsfeeds",
    content => "\n# nocem feed\nnocem!:${groups}:Tc,Wf,Ap:${binary}\n"
  }
}
