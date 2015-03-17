# usenet\_inn2

This module provides the basic building blocks necessary to configure
a Usenet news server.  It was designed for a single news server -
news.killfile.org - but it should provide the tools necessary for other
servers as necessary.

Yes, this module seems overly-complicated; but it manages a dozen or so
separate configuration files, because that's how INN2 works.

Note that this is only checked-out to work on a Debian host, but it's
probably fairly portable through the ::params class.

## Classes

Individual documentation is included with each manifest.

### Configuration Files

Each configuration file is generally managed at a top level with a single
puppet manifest.


#### /etc/news/control.ctl

Managed with `usenet_inn2::control_ctl`.  Individual entries are loaded
with `usenet_inn2::control_ctl::fragment`:

    usenet_inn2::control_ctl::fragment { 
      'internal-newgroup':
        message    => 'newgroup',
        from       => 'me@internal.invalid',
        newsgroups => 'internal.*'
        action     => 'doit';
      'internal-rmgroup':
        message    => 'rmgroup',
        from       => 'me@internal.invalid',
        newsgroups => 'internal.*'
        action     => 'doit';
      'internal-checkgroups':
        message    => 'checkgroups',
        from       => 'me@internal.invalid',
        newsgroups => 'internal.*'
        action     => 'doit';
    }

#### /etc/news/cycbuff.conf

Managed with `usenet_inn2::cycbuff_conf`.  Individual entries are loaded
with `usenet_inn2::cycbuff::meta` and `usenet_inn2::cycbuff`:

    usenet_inn2::cycbuff { 
      '/var/lib/news/cycbuffs/A01':
        buffer => 'A01',
        size   => 100000;
      '/var/lib/news/cycbuffs/A02':
        buffer => 'A02',
        size   => 100000;
    }
    usenet_inn2::cycbuff::meta { 'ALT': buffer => [ 'A01', 'A02' ] }

#### /etc/news/distrib.pats

Managed with `usenet_inn2::distrib_pats`.  Individual entries are loaded
with `usenet_inn2::distrib_pats::fragment`:

    usenet_inn2::distrib_pats::fragment { 'internal':
      weight  => 90,
      pattern => 'internal.*',
      value   => 'internal'
    }

#### /etc/news/expire.ctl

Managed with `usenet_inn2::expire`.  Individual entries are loaded
with `usenet_inn2::expire::fragment`:

    usenet_inn2::expire::fragment { 'default':
      pattern      => '*',
      comment      => 'keep for 1-100 days, allow Expires to work',
      days_default => '100',
      days_min     => '1',
      days_max     => '365',
    }

#### /etc/news/inn.conf

Managed with `usenet_inn2::inn_conf`.

#### /etc/news/incoming.conf, /etc/news/innfeed.conf, /etc/news/newsfeeds

Managed with `usenet_inn2::incoming.conf`, `usenet_inn2::innfeed`, and
`usenet_inn2::newsfeeds`, respectfully.  Individual entries are loaded
with `usenet_inn2::peer`:

    usenet_inn2::peer { 'foobar':
      comment    => 'accept everything, send everything but binaries',
      contact    => 'example@foobar.invalid',
      server_in  => 'news-out.foobar.invalid',
      server_out => 'news-in.foobar.invalid',
      incoming   => '*',
      outgoing   => '*,!alt.bainar*,@*.bina*'
    }

#### /etc/news/nocem.ctl

Managed with `usenet_inn2::nocem`.  You may not care about this, but if
you do, look at the manifests directly.

#### /etc/news/pgp/\*

Managed with `usenet_inn2::gpg`.  This includes managing both the central 
`pubring.gpg` key ring and distribution of sample keys.

This is then used to authenticate control messages, and is not *strictly*
necessary.

#### /etc/news/readers.conf

Managed with `usenet_inn2::readers`.  Individual entries
are loaded with `usenet_inn2::readers::auth::fragment` and
`usenet_inn2::readers::access::fragment`, as so:

    usenet_inn2::readers::auth::fragment { 'passwd':
      comment => 'check the local password file',
      order   => 00,
      auth    => 'ckpasswd -f /var/spool/news/db/passwd',
      access  => '<USERS>'
    }

    usenet_inn2::readers::access::fragment { 'passwd':
      comment     => 'public access',
      order       => 00,
      users       => '<USERS>',
      perlfilter  => 'false',
      groups_read => $public_read,
      groups_post => $public_post,
      access      => 'RP'
    }

#### /etc/news/storage.conf

Managed with `usenet_inn2::storage`.  Individual entries are loaded
with `usenet_inn2::storage::fragment`:

    usenet_inn2::storage::fragment {
      'local':
        number     => 0,
        newsgroups => 'internal.*',
        storage    => tradspool;
      'alt':
        number     => 2,
        newsgroups => 'alt.*',
        options    => 'ALT',
        storage    => 'cnfs';
    }

## Prerequisites

* puppetlabs/concat
* puppetlabs/stdlib
