class omero::server (
  $omero_owner = hiera('omero_owner'),
  $omero_group = hiera('omero_group'),
  $omero_home = hiera('omero_home'),
  $omero_home_link = hiera('omero_home_link', ''),
  $omero_db_user = hiera('omero_db_user'),
  $db_version = hiera('db_version'),
  $db_patch = hiera('db_patch'),
  $omero_root_pw = hiera('root_password'),
  $omero_dbname = hiera('omero_dbname'),
  $omero_installed = hiera('omero_installed', false),
  $dbtype = hiera('dbtype'),
) inherits omero {

  class {
    'omero::packages':
      ;
    'omero::database':
      ;
    'omero::web':
      ;
    'omero::repo':
      ;
  }

  # create omero_home as a link to a target if defined otherwise a directory
  file { 'omero-home':
    path   => $omero_home,
    ensure => $omero_home_link ? { '' => 'directory', default => 'link' },
    target => $omero_home_link ? { '' => 'notlink', default   => $omero_home_link },
    owner  => $omero_owner,
    group  => $omero_group,
  }

  if $omero_installed {
    # if configs are non-standard we need to update omero's xml config to match
    # will need more here -- maybe a better way to do this
    if $omero_db_user != 'omero' {
      omero::config { 'omero.db.user':
        omero_owner => $omero_owner,
        omero_home => $omero_home,
        mode       => 'set',
        value      => $omero_db_user,
      }
    }

    if $dbtype == 'postgres' {
      $schema_created_file = "${omero_home}/.db.by_puppet"
      exec { 'create-schema':
        command => "omero db script ${db_version} ${db_patch} ${omero_root_pw} --file - | psql ${omero_dbname} && touch ${schema_created_file}",
        user    => $omero_owner,
        path    => [ '/bin', '/usr/bin', $omero::database::postgres::bindir, "${omero_home}/bin" ],
        creates => $schema_created_file,
        require => Class['omero::database::postgres'],
      }
    }
  }

}
