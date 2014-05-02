# Generate an entry in /etc/news/readers::access.conf (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::readers::access::fragment { '<name>':
#     ensure      => present | absent,
#     comment     => [ <string> ],
#     users       => [ <user-group> ],  # defaults to '*'
#     newsgroups  => [ <list-of-groups> ],
#     groups_read => [ <list-of-groups> ],
#     groups_post => [ <list-of-groups> ],
#     access      => [ <group-access-rights> ],
#     perlfilter  => [ true | false ],
#     order       => [ <sort-number> ]
#   }
#
# Please see the readers.conf man page for details on the proper keys and
# values.  Note that we are only implementing a small sub-set of possible
# options; this is a difficult file!

define usenet_inn2::readers::access::fragment (
  $ensure      = 'present',
  $comment     = '',
  $users       = '*',
  $newsgroups  = '',
  $groups_read = '',
  $groups_post = '',
  $access      = '',
  $perlfilter  = 'true',
  $order       = 20
) {
  include usenet_inn2::readers

  $config = $usenet_inn2::readers::config

  $o = 700 + $order

  concat::fragment { "access-$name":
    ensure  => $ensure,
    target  => $config,
    order   => "${o}",
    content => template ('usenet_inn2/fragments/readers_access.conf.erb'),
  }
}
