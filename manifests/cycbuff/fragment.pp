# usenet_inn2::cycbuff::fragment
#
#   Generate a cycbuff entry in /etc/news/cycbuff.conf (or equivalent).
#   Uses concat::fragment to do the merging.  See cycbuff.conf(5) for more
#   details.
#
# == Parameters
#
#   ensure  String: 'present' or 'absent'.  Default: 'present'.
#   buffer  String: file location for the buffer.  No default, required.
#   size    Integer: size of the buffer.  No default, required.
#
# == Usage
#
#   usenet_inn2::cycbuff::fragment { '<file-name>':
#     ensure       => present | absent,
#     buffer       => '<short-buffer-name>',
#     size         => '<file-size-in-kB>'
#   }
#
define usenet_inn2::cycbuff::fragment (
  $ensure = 'present',
  $buffer = undef,
  $size   = undef
) {
  validate_string ($ensure, $buffer)
  if ! is_integer ($size) {
    fail('usenet_inn2::cycbuff::fragment - must pass int for $size')
  }

  include usenet_inn2::cycbuff_conf
  $config = $usenet_inn2::cycbuff_conf::config

  concat::fragment { "cycbuff-${name}":
    ensure  => $ensure,
    target  => $config,
    content => "cycbuff:${buffer}:${name}:${size}\n";
  }
}
