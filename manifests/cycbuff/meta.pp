# usenet_inn2::cycbuff::meta (definition)
#
#   Generate a metacycbuff entry in /etc/news/cycbuff.conf (or equivalent).
#   Uses concat::fragment to do the merging.  See cycbuff.conf(5) for more
#   details.
#
# == Parameters
#
#   ensure  String: 'present' or 'absent'.  Default: 'present'.
#   buffer  Array: a list of buffer names to include in this entry.
#           No default, required.
#
# == Usage
#
#   usenet_inn2::cycbuff::meta { '<name>':
#     ensure => present | absent,
#     buffer => '<buffer-name>'
#   }
#
# Please see the cycbuff.conf man page for details on the proper keys and
# values.
#
define usenet_inn2::cycbuff::meta (
  $ensure = 'present',
  $buffer = undef,
) {
  validate_array ($buffer)
  validate_string ($ensure)

  include usenet_inn2::cycbuff_conf
  $config = $usenet_inn2::cycbuff_conf::config

  concat::fragment { "metacycbuff-${name}":
    ensure  => $ensure,
    target  => $config,
    content => template ('usenet_inn2/fragments/cycbuff_meta.erb');
  }
}
