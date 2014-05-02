# Configuration to allow bofh.* access from this server.  This pretty much 

class usenet_inn2::bofh (
) inherits usenet_inn2::params {

  usenet_inn2::distrib_pats::fragment { 'bofh':
    ensure  => present,
    weight  => 90,
    pattern => 'bofh.*',
    value   => 'bofh'
  }

  $bofhcontrol = 'bofh-control@lists.killfile.org'

  usenet_inn2::control_ctl::fragment { 
    'bofh-newgroup':
      message    => 'newgroup',
      from       => $bofhcontrol,
      newsgroups => 'bofh.*',
      action     => "verify-$bofhcontrol";
    'bofh-rmgroup':
      message    => 'rmgroup',
      from       => $bofhcontrol,
      newsgroups => 'bofh.*',
      action     => "verify-$bofhcontrol";
    'bofh-checkgroups':
      message    => 'checkgroups',
      from       => $bofhcontrol,
      newsgroups => 'bofh.*',
      action     => "verify-$bofhcontrol";
    }
}
