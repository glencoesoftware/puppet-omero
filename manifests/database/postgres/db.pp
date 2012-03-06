define omero::database::postgres::db (
  $owner = $name,
  $ensure = 'present',
  $pg_user,
  $version
) {

  $pg_dir = "/usr/pgsql-${version}"

  omero::database::postgres::owner { $owner:
    ensure  => $ensure,
    version => $version,
    pg_user => $pg_user,
  }

  if $ensure == 'present' {

    exec { "createdb $name":
      command => "createdb -O $owner $name",
      path    => [ '/usr/bin', "${pg_dir}/bin" ],
      user    => $pg_user,
      unless  => $dbexists,
      require => Omero::Database::Postgres::User[$owner],
    }


  } elsif $ensure == 'absent' {

    exec { "dropdb $name":
      command => "dropdb $name",
      user => $pg_user,
      onlyif => $dbexists,
      before => Omero::Database::Postgres::User[$owner],
    }
  }
}
  
}
