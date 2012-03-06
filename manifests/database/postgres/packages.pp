# Class: omero::database::postgres::packages
#
# This class does stuff that you describe here
#
# Parameters:
#   $parameter:
#       this global variable is used to do things
#
# Actions:
#   Actions should be described here
#
# Requires:
#   - Package["foopackage"]
#
# Sample Usage:
#
class omero::database::postgres::packages {
  case $operatingsystem {
    /CentOS|RedHat/: {

      # remove the '.' from the version
      $package_version = regsubst($version, '^(\d+)\.(\d+)', '\1\2')

      # release is a guess
      $release = $operatingsystem ? {
        'CentOS' => '4',
        'RedHat' => '5',
      }

      # get the repo release rpm
      $pg_release_rpm = $operatingsystem ? {
        'CentOS' => "http://yum.postgresql.org/${version}/redhat/rhel-${operatingsystemrelease}-${architecture}/pgdg-centos${package_version}-${version}-${release}.noarch.rpm",
        'RedHat' => "http://yum.postgresql.org/${version}/redhat/rhel-${operatingsystemrelease}-${architecture}/pgdg-redhat${package_version}-${version}-${release}.noarch.rpm",
        default  => 'os-not-supported'
      }
    
      package {
        'postgres-repo-release':
          name     => $pg_release_rpm,
          provider => 'rpm',
          ensure   => $ensure,
          ;
        'postgres':
          name    => "postgresql${package_version}",
          ensure  => $ensure,
          require => Package['postgres-repo-release'],
          ;
        'postgres-server':
          name    => "postgresql${package_version}-server",
          ensure  => $ensure,
          require => Package['postgres'],
          ;
        'postgresql-devel':
          name   => "postgresql${package_version}-devel",
          ensure => $ensure,
          require => Package['postgres'],
          ;
      }
    }
    'Darwin': {
    }
    'Ubuntu': {
    }
    'Debian': {
    }
    default {
      err "operating system ${operatingsystem} not support"
    }
  }
}
