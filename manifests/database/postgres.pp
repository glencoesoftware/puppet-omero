# Class: puppet-omero::database::postgres
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
class omero::database::postgres (
  $version = '9.1',
  $pg_user = 'postgres',
  $service_name = ''
) {

  # install classes
  class { 'omero::database::postgres::packages':
    version => $version,
    ensure  => 'present',
  }

  $pg_service_name = $service_name ? {
    ''      => "postgresql-${version}",
    default => $service_name
  }

  $pg_vardir = "/var/lib/pgsql/${version}"
  $pg_bindir = "/usr/pgsql-${version}/bin"

  File { 
    owner   => $pg_user,
    group   => $pg_user,
    require => Class['omero::database::postgres::packages'],
  }

  # this may only work on rhel/centos (depends on initscript)
  exec {
    'initdb':
      command => "service postgresql-${version} initdb"
      path    => [ '/sbin', '/usr/sbin', '/bin', '/usr/bin', "${pg_bindir}" ],
      creates => "${pg_vardir}/data/PG_VERSION",
      require => Class['omero::database::postgres::packages'],
      ;
  }

  file {
    "/var/lib/pgsql/${version}/data/pg_hba.conf":
      content => template("${module_name}/pg_hba.conf.erb"),
      require => Exec['initdb'],
      notify  => Service['postgres'],
      ;
  }

  service { 'postgres':
    name       => "postgresql-${version}",
    ensure     => 'running',
    enable     => 'true',
    hasrestart => 'true',
    hasstatus  => 'true',
    restart    => "/sbin/service postgresql-${version} reload",
  }

  # create db and db_owner
  omero::database::postgres::db { $omero_db:
    owner   => $omero_db_owner,
    require => Class['omero::database::postgres::packages'],
  }

}

