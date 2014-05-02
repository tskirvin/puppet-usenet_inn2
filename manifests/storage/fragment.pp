# Generate an entry in /etc/news/storage.conf (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::storage::fragment { '<name>':
#     ensure      => present | absent,
#     storage     => 'cnfs' | 'timecaf' | 'timehash' | 'tradspool' | 'trash',
#     newsgroups  => <wildmat>,                      # defaults to '*'
#     number      => <unique-number-from-0-to-254>,  # matches 'class'
#     art_size    => [ <minsize> [,<maxsize>]],
#     art_expires => [ <mintime> [,<maxtime>]],
#     options     => [ <options> ],
#     exactmatch  => [ <bool> ]
#   }
#
# Please see the storage.conf man page for details on the proper keys and
# values.

define usenet_inn2::storage::fragment (
  $ensure      = 'present',
  $number,
  $storage     = 'tradspool',
  $newsgroups  = '*',
  $art_size    = '',
  $art_expires = '',
  $options     = '',
  $exactmatch  = ''
) {
  include usenet_inn2::storage

  $config = $usenet_inn2::storage::config

  concat::fragment { "$number-$name":
    ensure  => $ensure,
    target  => $config,
    content => template ('usenet_inn2/fragments/storage.conf.erb'),
  }
}
