# usenet_inn2::inn_conf
#
#   Manage /etc/news/inn.conf via template.
#
# == Parameters
#
#   Default values for these parameters come from usenet_inn2::params unless
#   otherwise noted.
#
#     article_cutoff  Integer: how many days should we remember articles?
#     hismethod       String: 'hisv6'.
#     host_name       String: what host name should we be (internally)?
#                     Default: $::fqdn
#     news_group      String: e.g. 'news'
#     news_user       String: e.g. 'news'
#     organization    String: organization name for posts coming from this
#                     server.  No default, required.
#     path_bin        String: e.g. '/usr/lib/news/bin'
#     path_conf       String: e.g. '/etc/news'
#     path_db         String: e.g. '/var/lib/news/db'
#     path_log        String: e.g. '/var/log/news'
#     path_news       String: e.g. '/usr/lib/news'
#     path_run        String: e.g. '/var/run/news'
#     path_spool      String: e.g. '/var/spool/news'
#     port            Integer: e.g. 119
#
class usenet_inn2::inn_conf (
  Integer $article_cutoff = $usenet_inn2::params::article_cutoff,
  String $hismethod      = 'hisv6',
  String $host_name      = $::fqdn,
  String $news_group     = $usenet_inn2::params::news_group,
  String $news_user      = $usenet_inn2::params::news_user,
  String $organization   = undef,
  String $ovmethod       = 'tradindexed',
  String $path_bin       = $usenet_inn2::params::path_bin,
  String $path_conf      = $usenet_inn2::params::path_conf,
  String $path_db        = $usenet_inn2::params::path_db,
  String $path_log       = $usenet_inn2::params::path_log,
  String $path_news      = $usenet_inn2::params::path_news,
  String $path_run       = $usenet_inn2::params::path_run,
  String $path_spool     = $usenet_inn2::params::path_spool,
  Integer $port          = $usenet_inn2::params::port
) inherits usenet_inn2::params {
  file { "${path_conf}/inn.conf":
    owner   => $news_user,
    group   => $news_group,
    content => template ('usenet_inn2/inn.conf.erb');
  }
}
