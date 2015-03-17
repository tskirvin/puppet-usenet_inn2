# usenet_inn2::cycbuff (definition)
#
#   Create a cnfs (Cyclic News File System) buffer, in which we can store our
#   news articles.  This also creates a matching entry in the cycbuff.conf file
#   for the buffer (but not the 'metacycbuff' entry).
#
# == Parameters
#
#   ensure  String: 'present' or 'absent'.  Default: 'present'.
#   buffer  String: file name for the buffer.  No default, required.
#   group   String: group to control the file.  Default: 'news'
#   mode    String: permissions for the file.  Default: '0644'
#   owner   String: user to own the file.  Default: 'news'.
#   size    Integer: how big should the file be?  Default: 1048576 (1MB).
#
# == Usage
#
#   usenet_inn2::cycbuff { '/var/lib/news/cycbuffs/A01':
#     buffer => 'A01',
#     size   => 100000
#   }
#   usenet_inn2::cycbuff::meta { 'ALT': buffer => [ 'A01' ] }
#
define usenet_inn2::cycbuff (
  $ensure = present,
  $buffer = undef,
  $group  = 'news',
  $mode   = '0644',
  $owner  = 'news',
  $size   = 1048576
) {
  validate_string ($size)
  validate_string ($ensure, $buffer, $group, $owner, $mode)

  include usenet_inn2::cycbuff_conf

  exec { "cnfs ${name}":
    command => "/bin/dd if=/dev/zero bs=1024 of=${name} count=${size}",
    creates => $name,
    notify  => File[$name],
  }

  file { $name:
    ensure  => $ensure,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    require => Exec["cnfs ${name}"],
  }

  usenet_inn2::cycbuff::fragment { $name:
    size   => $size,
    buffer => $buffer
  }
}
