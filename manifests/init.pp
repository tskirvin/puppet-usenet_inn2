# usenet_inn2
#
#   Manage an INN2 Usenet news server.  This is the top-level module, which:
#
#     * Installs necessary packages
#     * Manages /etc/news/motd.news
#     * Loads a series of other modules from other manifests to manage the
#       other configuration files.
#     * Makes sure that the service itself is running
#
# == Parameters
#
#   Default values for these parameters come from usenet_inn2::params unless
#   otherwise noted.
#
#     article_cutoff  Integer: how many days should we remember articles?
#     host_name       String: what host name should we be (internally)?
#                     Default: $::fqdn
#     news_group      String: e.g. 'news'
#     news_user       String: e.g. 'news'
#     organization    String: organization name for posts coming from this
#                     server.  No default, required.
#     packages        Array: e.g. [ 'inn2', 'inn2-inews' ]
#     path_conf       String: e.g. '/etc/news'
#
class usenet_inn2 (
  $article_cutoff = $usenet_inn2::params::article_cutoff,
  $host_name      = $::fqdn,
  $news_group     = $usenet_inn2::params::news_group,
  $news_user      = $usenet_inn2::params::news_user,
  $organization   = undef,
  $packages       = $usenet_inn2::params::packages,
  $path_conf      = $usenet_inn2::params::path_conf
) inherits usenet_inn2::params {
  # validate_integer ($article_cutoff)
  validate_string ($host_name, $organization)
  validate_string ($news_group, $news_user, $path_conf)
  validate_array ($packages)

  include usenet_inn2::control_ctl
  include usenet_inn2::cycbuff_conf
  include usenet_inn2::distrib_pats
  include usenet_inn2::incoming
  include usenet_inn2::innfeed
  include usenet_inn2::newsfeeds

  include usenet_inn2::gpg

  package { $packages: ensure => installed }

  file { $path_conf:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755';
  }

  file { "${path_conf}/motd.news":
    ensure  => present,
    owner   => $news_user,
    group   => $news_group,
    content => "${host_name} -- managed by puppet"
  }

  ## The INN2 docs recommend this setting, even though it does now require
  ## us to invoke the class via class {} instead of just include ()
  class { 'usenet_inn2::expire': remember => $article_cutoff + 1 }

  ## We want to gather the necessary parameters here and pass them in to
  ## generate inn.conf later.
  class { 'usenet_inn2::inn_conf':
    host_name    => $host_name,
    organization => $organization
  }

  service { 'inn2':
    ensure    => running,
    name      => 'inn2',
    enable    => true,
    hasstatus => false,
    status    => 'pidof innd',
    subscribe => File["${path_conf}/inn.conf"],
  }
}
