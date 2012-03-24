define omero::web::config (
  $webtype,
  $omero_home,
  $omero_owner,
  $config = '',
  $source = '',
) {

  case $webtype {
    'apache': {
      $config_loc = '/etc/httpd/conf.d/omero-web.conf'
      $pkg_name = 'httpd'
    }
    'nginx': {
      $config_loc = '/etc/nginx/conf.d/omero-web.conf'
      $pkg_name = 'nginx'
    }
  }

  if $source {
    case $source {
      /template/: {
        $source_loc = undef
        $template_loc = $source
      }
      default: {
        $source_loc = $source
        $template_loc = undef
      }
    }
  } else {
    $source_loc = "${omero_home}/etc/${webtype}-config.conf"
    $template_loc = undef

    exec { 'generate-omero-web-config':
      command => "omero web config ${webtype} > ${source_loc}",
      path    => [ '/bin', '/usr/bin', "${omero_home}/bin" ],
      user    => $omero_owner,
      creates => $source_loc,
      notify  => File['omero-web-config'],
    }
  }

  file { 'omero-web-config':
    path    => $config_loc,
    source  => $source_loc,
    content => $template_loc,
    notify  => Service[$pkg_name],
    require => Package[$pkg_name],
  }
}
