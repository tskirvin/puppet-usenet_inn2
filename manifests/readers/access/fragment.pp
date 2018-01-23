# usenet_inn2::readers::access::fragment (definition)
#
#   Generate an 'access' entry in /etc/news/readers/access.conf (or 
#   equivalent).  Uses concat::fragment to do the merging.
#
#   Please see the readers.conf(5) for details on the proper keys and
#   values.  Note that we are only implementing a small sub-set of possible
#   options; this is a difficult file!
#
# == Parameters
#
#    access       String.  Default: ''
#    comment      String.  Default: ''
#    groups_post  String.  Default: ''
#    groups_read  String.  Default: ''
#    newsgroups   String.  Default: ''
#    order        Integer.  Default: 20
#    perlfilter   String.  Default: 'true'
#    users        String.  Default: ''
#
define usenet_inn2::readers::access::fragment (
  String $access      = '',
  String $comment     = '',
  String $groups_post = '',
  String $groups_read = '',
  String $newsgroups  = '',
  Integer $order      = 20,
  # lint:ignore:quoted_booleans
  String $perlfilter  = 'true',
  # lint:endignore
  String $users       = '*'
) {
  include usenet_inn2::readers

  $config = $usenet_inn2::readers::config

  $o = 700 + $order

  concat::fragment { "access-${name}":
    target  => $config,
    order   => $o,
    content => template ('usenet_inn2/fragments/readers_access.conf.erb'),
  }
}
