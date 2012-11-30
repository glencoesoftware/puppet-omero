#
class omero (
  $omero_owner = hiera('omero_owner'),
  $omero_group = hiera('omero_group'),
  $omero_home = hiera('omero_home'),
  $create_omero_user = hiera('create_omero_user'),
  $epel_release_rpm = hiera('epel_release_rpm'),
) {

  if $create_omero_user {
    user { $omero_owner:
      ensure  => 'present',
      home    => $omero_home,
    }

    group { $omero_group:
      ensure => 'present',
    }
  }

  if $iptables_enabled {
    # firewall rules go here
    $implement_later = 'FIXME'
  } else {
    # make sure stock ruleset doesn't bite us
    service { 'iptables':
      ensure => 'stopped',
    }
  }
    
  # we need epel, it may be installed b/c of puppet but possible not enabled.
  if defined(Yumrepo['epel']) {
    Yumrepo['epel'] {
      enabled => '1',
    }
  } else {
    yumrepo { 'epel':
      enabled => '1',
      require => Package['epel-release'],
    }

    package { 'epel-release':
      source   => $epel_release_rpm,
      provider => 'rpm',
    }
  }

  # both rc scripts will be generated if they don't exist -- otherwise will be left alone
  # to that end if they are generated once future changes will not be reflected
  file {
    'omero-profile.sh':
      # use ~/.profile as it shouldn't likely exist from skel or other places and is bash/sh specific
      path    => "${omero_home}/.profile",
      content => template("${module_name}/omero-profile.sh.erb"),
      replace => false,
      ;
    'omero-profile.csh':
      path    => "${omero_home}/.cshrc",
      content => template("${module_name}/omero-profile.csh.erb"),
      replace => false,
      ;
  }
}
