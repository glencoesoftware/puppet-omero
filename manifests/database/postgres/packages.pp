#
class omero::database::postgres::packages {
  case $operatingsystem {
    /CentOS|RedHat/: {

      # remove the '.' from the version
      $version = $omero::database::postgres::version
      $package_version = regsubst($omero::database::postgres::version, '^(\d+)\.(\d+)', '\1\2')

      case $operatingsystem {
        'CentOS': {
          $release = '4'
          $lc_os = 'centos'
          $release_pkg_name = "pgdg-${lc_os}${package_version}"
        }
        'RedHat': {
          $release = '5'
          $lc_os = 'redhat'
        }
      }

      # pgdg-centos91-9.1-4.noarch.rpm
      # get the repo release rpm
      $pg_release_rpm = "http://yum.postgresql.org/${version}/redhat/rhel-${operatingsystemrelease}-${architecture}/${release_pkg_name}-${version}-${release}.noarch.rpm"
    
      package {
        'postgres-release':
          name     => $release_pkg_name,
          source   => $pg_release_rpm,
          provider => 'rpm',
          ;
        'postgres':
          name    => "postgresql${package_version}",
          require => Package['postgres-release'],
          ;
        'postgres-server':
          name    => "postgresql${package_version}-server",
          require => Package['postgres'],
          ;
        'postgresql-devel':
          name   => "postgresql${package_version}-devel",
          require => Package['postgres'],
          ;
      }
    }
    default: {
      err "operating system ${operatingsystem} not support"
    }
  }
}
