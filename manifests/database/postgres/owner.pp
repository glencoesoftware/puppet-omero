define omero::database::postgres::owner (
  $ensure  = 'present',
  $owner   = $name,
  $pg_user,
  $password,
  $version,
) {

  $pg_dir = "/usr/pgsql-${version}"

  $userexists = "psql --tuples-only -c 'SELECT rolname FROM pg_catalog.pg_roles;' | grep '^ ${owner}$'"
  $user_owns_zero_databases = "psql --tuples-only --no-align -c \"SELECT COUNT(*) FROM pg_catalog.pg_database JOIN pg_authid ON pg_catalog.pg_database.datdba = pg_authid.oid WHERE rolname = '${owner}';\" | grep -e '^0$'"

  if $ensure == 'present' {

    $owner_pass = $password ? { '' => '', default => "PASSWORD '${password}'" }
    $a = '\"'
    $q_owner = "${a}${owner}${a}"

    $p_create = [
      "CREATE ROLE ${q_owner} ${owner_pass} NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN"
    ]

    exec { "createuser $owner":
      command         => "psql -c \"${p_create}\"",
      path            => [ '/bin', '/usr/bin', "${pg_dir}/bin" ],
      user            => $pg_user,
      unless          => $userexists,
      logoutput       => 'true',
    }

  } elsif $ensure == 'absent' {

    exec { "dropuser $owner":
      command => "dropuser ${owner}",
      user => $pg_user,
      onlyif => "$userexists && $user_owns_zero_databases",
    }
  }
}
