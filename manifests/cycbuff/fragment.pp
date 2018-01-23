# usenet_inn2::cycbuff::fragment
#
#   Generate a cycbuff entry in /etc/news/cycbuff.conf (or equivalent).
#   Uses concat::fragment to do the merging.  See cycbuff.conf(5) for more
#   details.
#
# == Parameters
#
#   buffer  String: file location for the buffer.  No default, required.
#   size    Integer: size of the buffer.  No default, required.
#
# == Usage
#
#   usenet_inn2::cycbuff::fragment { '<file-name>':
#     buffer       => '<short-buffer-name>',
#     size         => '<file-size-in-kB>'
#   }
#
define usenet_inn2::cycbuff::fragment (
  String $buffer,
  Integer $size,
) {
  include usenet_inn2::cycbuff_conf
  $config = $usenet_inn2::cycbuff_conf::config

  concat::fragment { "cycbuff-${name}":
    target  => $config,
    content => "cycbuff:${buffer}:${name}:${size}\n";
  }
}
