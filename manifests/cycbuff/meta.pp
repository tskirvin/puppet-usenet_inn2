# Generate a cycbuff entry in /etc/news/cycbuff.conf (or equivalent).  Uses 
# concat::meta to do the merging.
#
# Usage: 
#
#   usenet_inn2::cycbuff::meta { '<name>':
#     ensure => present | absent,
#     meta   => '<string>',
#     buffer => '<buffer-name>'
#   }
#
# Please see the cycbuff.conf man page for details on the proper keys and
# values.

define usenet_inn2::cycbuff::meta ( $ensure = 'present', $buffer ) {
  include usenet_inn2::cycbuff_conf
  $config = $usenet_inn2::cycbuff_conf::config

  concat::fragment { "metacycbuff-$name":
    ensure  => $ensure,
    target  => $config,
    content => template('usenet_inn2/fragments/cycbuff_meta.erb');
  }
}
