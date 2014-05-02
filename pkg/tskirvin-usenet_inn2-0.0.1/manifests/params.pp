# Default values for usenet_inn2 configuration.  

class usenet_inn2::params {
  $packages   = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => [ 'inn2', 'inn2-inews' ],
  }

  $article_cutoff  = 10
  $news_group      = 'news'
  $news_user       = 'news'
  $path_bin        = '/usr/lib/news/bin'
  $path_conf       = '/etc/news'
  $path_db         = '/var/lib/news'
  $path_log        = '/var/log/news'
  $path_news       = '/usr/lib/news'
  $path_run        = '/var/run/news'
  $path_spool      = '/var/spool/news'
  $port            = 119

}
