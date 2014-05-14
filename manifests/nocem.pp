# Configuration to support NoCeM filtering from a server.  Consists of three
# parts: a managing /etc/news/nocem.ctl, managing a GPG file for valid 
# keys, and actually adding entries to listen to.

class usenet_inn2::nocem (
) inherits usenet_inn2::params {
  include usenet_inn2::nocem::gpg
  include usenet_inn2::nocem::newsfeeds
  include usenet_inn2::nocem::ctl

  usenet_inn2::nocem::fragment { 
    'vlad-pgpmoose':
      ensure => present,
      issuer => 'pgpmoose@killfile.org',
      type   => 'pgpmoose-forged-moderation';
    'bleachbot':
      ensure => present,
      issuer => 'bleachbot@httrack.com',
      type   => 'site,spam';
  }
}
