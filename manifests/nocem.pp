# usenet_inn2::nocem
#
#   Enables NoCeM filtering on a server.  This mostly consists of loading
#   sub-classes, and configuring two default filters: 'bleachbot' and
#   'vlad-pgpmoose'.
#
#   See usenet_inn2::nocem::gpg, usenet_inn2::nocem::newsfeeds, and
#   usenet_inn2::nocem::ctl for more details.
#
class usenet_inn2::nocem () {
  include usenet_inn2::nocem::ctl
  include usenet_inn2::nocem::gpg
  include usenet_inn2::nocem::newsfeeds

  usenet_inn2::nocem::fragment {
    'vlad-pgpmoose':
      issuer => 'pgpmoose@killfile.org',
      type   => 'pgpmoose-forged-moderation';
    'bleachbot':
      issuer => 'bleachbot@httrack.com',
      type   => 'site,spam';
  }
}
