# usenet_inn2::cycbuff (definition)
#
#   Create a cnfs (Cyclic News File System) buffer, in which we can store our
#   news articles.  This also creates a matching entry in the cycbuff.conf file
#   for the buffer (but not the 'metacycbuff' entry).
#
# == Parameters
#
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
  Variant[String, Undef] $buffer = undef,
  String $group = 'news',
  String $mode  = '0644',
  String $owner = 'news',
  Integer $size = 1048576
) {
  include usenet_inn2::cycbuff_conf

  exec { "cnfs ${name}":
    command => "/bin/dd if=/dev/zero bs=1024 of=${name} count=${size}",
    creates => $name,
    notify  => File[$name],
  }

  file { $name:
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
