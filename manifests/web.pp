#
class omero::web (
  $web_config = hiera('omero_web_config', ''),
  $web_source = hiera('omero_web_config_source', ''),
  $omero_owner = hiera('omero_owner'),
  $omero_home = hiera('omero_home'),
  $omero_installed = hiera('omero_installed', false),
  $webtype = hiera('webtype')
) {
  package {
    'matplotlib':
      name => 'python-matplotlib',
      ;
  }

  case $webtype {
    'apache': {
      class { "omero::web::nginx::disabled": }
      class { "omero::web::apache":
        require => Class['omero::web::nginx::disabled'],
      }
    }
    'nginx': {
      class { "omero::web::apache::disabled": }
      class { "omero::web::nginx":
        require => Class['omero::web::apache::disabled'],
      }
    }
  }

  if $omero_installed {
    omero::web::config { 'omero-web':
      config      => $web_config,
      source      => $web_source,
      webtype     => $webtype,
      omero_home  => $omero_home,
      omero_owner => $omero_owner,
    }
  }
}
