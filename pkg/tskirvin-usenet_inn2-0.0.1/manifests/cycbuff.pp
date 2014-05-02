# Create a cnfs buffer, which is where we store most of our news.  Useful for
# initial system creation, and not much more.  Note that 'size' is the number
# that we will input into cycbuff.conf.
define usenet_inn2::cycbuff ( 
  $ensure = present,
  $buffer,
  $group  = 'news',
  $mode   = 644,
  $owner  = 'news',
  $size   = 1048576
) {
  include usenet_inn2::cycbuff_conf

  exec { "cnfs $name":
    command => "/bin/dd if=/dev/zero bs=1024 of=${name} count=${size}",
    creates => $name,
    notify  => File[$name],
  }

  file { $name:
    ensure  => $ensure,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    require => Exec["cnfs $name"],
  }

  usenet_inn2::cycbuff::fragment { $name:
    size   => $size,
    buffer => $buffer
  }
}
