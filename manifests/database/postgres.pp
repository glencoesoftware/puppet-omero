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
  $version = hiera('postgres_version'),
  $pg_user = hiera('postgres_user'),
  $owner = hiera('omero_db_user'),
  $owner_pass = hiera('omero_db_pass'),
  $database = hiera('omero_dbname'),
  $service_name = hiera('postgres_custom_service_name', ''),
) {

  # install classes
  class { 'omero::database::postgres::packages': }

  $pg_service_name = $service_name ? {
    ''      => "postgresql-${version}",
    default => $service_name
  }

  $vardir = "/var/lib/pgsql/${version}"
  $bindir = "/usr/pgsql-${version}/bin"

  File { 
    owner   => $pg_user,
    group   => $pg_user,
    require => Class['omero::database::postgres::packages'],
  }

  # this may only work on rhel/centos (depends on initscript)
  exec {
    'initdb':
      command     => "service postgresql-${version} initdb",
      path        => [ '/sbin', '/usr/sbin', '/bin', '/usr/bin', "${bindir}" ],
      creates     => "${vardir}/data/PG_VERSION",
      environment => [ 'LANG=en_US.UTF-8' ],
      require     => Class['omero::database::postgres::packages'],
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
  omero::database::postgres::db { $database:
    owner      => $owner,
    owner_pass => $owner_pass,
    pg_user    => $pg_user,
    version    => $version,
    require    => Class['omero::database::postgres::packages'],
  }

}

