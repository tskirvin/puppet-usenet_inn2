# all of this should end up in params.pp
class usenet_inn2 (

  $packages       = $usenet_inn2::params::packages,
  $article_cutoff = $usenet_inn2::params::article_cutoff,
  $host_name,
  $hismethod      = 'hisv6',
  $news_group     = 'news',
  $news_user      = 'news',
  $organization,
  $ovmethod       = 'tradindexed',
  $path_conf      = $usenet_inn2::params::path_conf,
  $path_bin       = $usenet_inn2::params::path_bin,
  $path_db        = $usenet_inn2::params::path_db,
  $path_log       = $usenet_inn2::params::path_log,
  $path_news      = $usenet_inn2::params::path_news,
  $path_run       = $usenet_inn2::params::path_run,
  $path_spool     = $usenet_inn2::params::path_spool,
  $port           = $usenet_inn2::params::port

) inherits usenet_inn2::params {
  class { 'usenet_inn2::gpg': path_conf => $path_conf }
  package { $packages: ensure => installed }

  class { 'usenet_inn2::distrib_pats':
    path_conf  => $path_conf,
    news_user  => $news_user,
    news_group => $news_group
  }

  class { 'usenet_inn2::incoming':
    path_conf  => $path_conf,
    news_user  => $news_user,
    news_group => $news_group
  }

  class { 'usenet_inn2::innfeed':
    path_conf  => $path_conf,
    news_user  => $news_user,
    news_group => $news_group
  }

  include usenet_inn2::newsfeeds
  # class { 'usenet_inn2::newsfeeds':
    # path_conf  => $path_conf,
    # news_user  => $news_user,
    # news_group => $news_group
  # }

  class { 'usenet_inn2::control_ctl':
    path_conf  => $path_conf,
    news_user  => $news_user,
    news_group => $news_group
  }

  $remember = $article_cutoff + 1

  class { 'usenet_inn2::expire':
    remember   => $remember,
    path_conf  => $path_conf,
    news_user  => $news_user,
    news_group => $news_group
  }

  class { 'usenet_inn2::cycbuff_conf':
    path_conf  => $path_conf,
    news_user  => $news_user,
    news_group => $news_group
  }

  file { $path_conf:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => 0755;
  }

  file { "${path_conf}/inn.conf":
    ensure  => present,
    content => template('usenet_inn2/inn.conf.erb');
  }

  file { "${path_conf}/subscriptions":
    ensure => present,
    owner  => $news_user,
    group  => $news_user,
    mode   => 0644,
  }

  file { "${path_conf}/motd.news":
    ensure  => present,
    owner   => $news_user,
    group   => $news_user,
    content => "${host_name} -- managed by puppet"
  }

  ## needs some parameterization to match OS release
  service { 'inn2':
    name      => 'inn2',
    ensure    => running,
    enable    => true,
    hasstatus => false,
    status    => "pidof innd",
    subscribe => File["${path_conf}/inn.conf"],
  }

  file { '/etc/filter-syslog/inn2':
    ensure => present,
    source => 'puppet:///modules/usenet_inn2/etc/filter-syslog/inn2';
  }
}

## FILES TO MANAGE

### Top Priority
## control.ctl.local      control_ctl.pp   ::control_ctl::fragment
## expire.ctl             expire.pp        ::expire::fragment
## incoming.conf          incoming.pp      ::peer
## inn.conf               init.pp          (none)
## innfeed.conf           innfeed.pp       ::peer
## newsfeeds              newsfeeds.pp     ::peer
## readers.conf           readers.pp       ::auth::fragment, ::access::fragment
## storage.conf           storage.pp       ::storage::fragment

### Medium Priority
## cycbuff.conf           cycbuff_conf.pp  ::cycbuff, ::cycbuff::meta
## distrib.pats           distrib_pats.pp  ::dist
## nocem.ctl              nocem.pp         ::nocem::ctl::fragment
## subscriptions          init.pp          file

### Low-To-Medium

## motd.news              init.pp          file

### Low Priority
## buffindexed.conf     
## distributions
## filter_innd.pl
## innreport.conf
## innwatch.ctl
## ovdb.conf
## passwd.nntp

## General plan for updates
## 1.  news.killfile.org will be moved to remote site, will be just Big-8 +
##     bofh.* and such; kill off dead hierarchies
## 2.  locust - will have an 'archive' feed which I will feed with everything
##     I've accumulated over the years, and continue to feed periodically.
##     This will replace my old 'kiboze' feed and such.
