# usenet_inn2::peer (definition)
#
#   Generates per-peer entries in the files that configure news feeds:
#
#     /etc/news/incoming.conf   incoming.conf(5)  usenet_inn2::incoming
#     /etc/news/innfeed.conf    innfeed.conf(5)   usenet_inn2::innfeed
#     /etc/news/newsfeeds       newsfeeds(5)      usenet_inn2::newsfeeds
#
# == Parameters
#
#   Most parameters come from the appropriate man pages.  The exception is
#   'server' vs 'server_in'/'server_out'.  In short, this is necessary for
#   hosts that send news from a different host name from which they receive
#   news.  If possible, you should just use 'server'.
#
#     comment     String - optional text.  Default: ''
#     contact     String - contact information for the site admin.  You should
#                 set this.  Default: 'unknown@unknown.invalid'
#     incoming    String - incoming feed specification.  Default: ''.
#     outgoing    String - outgoing feed specification.  Default: ''.
#     server      String - server name.  Default: 'NOSERVER'.
#     server_in   String - incoming server name.  Overrides 'server'.  No
#                 (useful) default.
#     server_out  String - outgoing server name.  Overrides 'server'.  No
#                 (useful) default.
#
# == Usage
#
#   usenet_inn2::peer { 'foobar':
#     comment  => 'foo and bar are friends'
#     server   => 'news.foobar.example',
#     contact  => 'baz@foobar.example'
#     incoming => '*',
#     outgoing => '!*,rec.*,comp.*'
#   }
#
define usenet_inn2::peer (
  String $comment    = '',
  String $contact    = 'unknown@unknown.invalid',
  String $incoming   = '',
  String $outgoing   = '',
  String $server     = 'NOSERVER',
  String $server_in  = 'NOSERVER',
  String $server_out = 'NOSERVER'
) {

  $incoming_conf = $usenet_inn2::incoming::config
  $newsfeeds     = $usenet_inn2::newsfeeds::config
  $innfeed_conf  = $usenet_inn2::innfeed::config

  if ($server_in  == 'NOSERVER') { $srv_in = $server }
  else                           { $srv_in = $server_in }

  if ($server_out == 'NOSERVER') { $srv_out = $server }
  else                           { $srv_out = $server_out }

  $feed_incoming = $incoming
  $feed_outgoing = $outgoing

  if ($incoming != '') {
    concat::fragment { "incoming_${name}":
      target  => $incoming_conf,
      content => template ('usenet_inn2/fragments/incoming.conf.erb')
    }
  }

  if ($outgoing != '') {
    concat::fragment { "newsfeeds_${name}":
      target  => $newsfeeds,
      content => template ('usenet_inn2/fragments/newsfeeds.erb')
    }
    concat::fragment { "innfeed_${name}":
      target  => $innfeed_conf,
      content => template ('usenet_inn2/fragments/innfeed.conf.erb')
    }
  }
}
