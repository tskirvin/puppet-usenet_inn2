# Generate per-peer entries in the files that configure news feeds, based on
# individual ERB templates:
#
#   /etc/news/incoming.conf   ../templates/fragments/incoming.conf.erb
#   /etc/news/innfeed.conf    ../templates/fragments/innfeed.conf.erb
#   /etc/news/newsfeeds       ../templates/fragments/newsfeeds.erb
# 
# Usage:
#
#   usenet_inn2::peer { '<name>':
#     ensure     => present | absent,
#     comment    => [ '<optional text>' ],
#     contact    => [ '<name and email address>' ],
#     incoming   => [ '<incoming feed spec>' ],
#     outgoing   => [ '<outgoing feed spec>' ],
#     server     => [ '<server name' ],
#     server_in  => [ '<server name>' ],
#     server_out => [ '<server name>' ]
#   }
#
# The incoming feed spec is defined in incoming.conf(5)
# The outgoing feed spec is defined in newsfeeds(5)
#
# server vs server_in/server_out is necessary for hosts that send news from
# a different hostname as they receive.  In general, just use server.
#
# Note that the "base" information for these files is configured in:
#
#   incoming.conf     usenet_inn2::incoming
#   innfeed.conf      usenet_inn2::innfeed
#   newsfeeds         usenet_inn2::newsfeeds
#
define usenet_inn2::peer (
  $ensure     = 'present',
  $comment    = '',
  $contact    = 'unknown@unknown.invalid',
  $incoming   = '',
  $outgoing   = '',
  $server     = 'NOSERVER',
  $server_in  = 'NOSERVER',
  $server_out = 'NOSERVER'
) {
  # include usenet_inn2::incoming
  # include usenet_inn2::newsfeeds
  # include usenet_inn2::innfeed

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
    concat::fragment { "incoming_$name":
      ensure  => $ensure,
      target  => $incoming_conf,
      content => template ('usenet_inn2/fragments/incoming.conf.erb')
    }
  }

  if ($outgoing != '') {
    concat::fragment { "newsfeeds_$name":
      ensure  => $ensure,
      target  => $newsfeeds,
      content => template ('usenet_inn2/fragments/newsfeeds.erb')
    }
    concat::fragment { "innfeed_$name":
      ensure  => $ensure,
      target  => $innfeed_conf,
      content => template ('usenet_inn2/fragments/innfeed.conf.erb')
    }
  }
}
