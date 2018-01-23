# usenet_inn2::storage::fragment (definition)
#
#   Generate an entry in /etc/news/storage.conf (or equivalent).  Uses
#   concat::fragment to do the merging.
#
#   Please see storage.conf(5) for details on each parameter.
#
# == Parameters
#
#   art_expires String.  Default: ''
#   art_size    String.  Default: ''
#   exactmatch  String.  Default: ''
#   newsgroups  String.  Default: '*'
#   number      Unique integer from 0 to 254.  Matches 'class'.  No default.
#   options     String.  Default: ''
#   storage     'cnfs', 'timecaf', 'timehash', 'tradspool', or 'trash';
#               default: 'tradspool'
#
# == Usage
#
#   usenet_inn2::storage::fragment { '<name>':
#     art_expires => [ <mintime> [,<maxtime>]],
#     art_size    => [ <minsize> [,<maxsize>]],
#     exactmatch  => [ <bool> ],
#     newsgroups  => <wildmat>,                      # defaults to '*'
#     number      => <unique-number-from-0-to-254>,  # matches 'class'
#     options     => [ <options> ],
#     storage     => 'cnfs' | 'timecaf' | 'timehash' | 'tradspool' | 'trash'
#   }
#
# Please see the storage.conf man page for details on the proper keys and
# values.

define usenet_inn2::storage::fragment (
  Integer $number,
  String $art_expires = '',
  String $art_size    = '',
  String $exactmatch  = '',
  String $newsgroups  = '*',
  String $options     = '',
  String $storage     = 'tradspool'
) {
  include usenet_inn2::storage

  $config = $usenet_inn2::storage::config

  concat::fragment { "${number}-${name}":
    target  => $config,
    content => template ('usenet_inn2/fragments/storage.conf.erb'),
  }
}
