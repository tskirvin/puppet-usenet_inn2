# Generate a cycbuff entry in /etc/news/cycbuff.conf (or equivalent).  Uses 
# concat::fragment to do the merging.
#
# Usage: 
#
#   usenet_inn2::cycbuff::fragment { '<file-name>':
#     ensure       => present | absent,
#     buffer       => '<short-buffer-name>',
#     size         => '<file-size-in-kB>'
#   }
#
# Please see the cycbuff.conf man page for details on the proper keys and
# values.

define usenet_inn2::cycbuff::fragment ( $ensure = 'present', $buffer, $size ) {
  include usenet_inn2::cycbuff_conf
  $config = $usenet_inn2::cycbuff_conf::config

  concat::fragment { "cycbuff-$name":
    ensure  => $ensure,
    target  => $config,
    content => "cycbuff:${buffer}:${name}:${size}\n";
  }
}
