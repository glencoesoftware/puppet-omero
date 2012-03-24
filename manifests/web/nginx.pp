#
class omero::web::nginx {
  package {
    'nginx':
      name    => 'nginx',
      require => Package['nginx-release'],
      ;
    'nginx-release':
      source   => $nginx_release_rpm,
      provider => 'rpm',
      ;
  }

  service { 'nginx':
    ensure     => 'running',
    enable     => 'true',
    hasrestart => 'true',
    hasstatus  => 'true',
    require    => Package['nginx'],
    restart    => '/sbin/service nginx reload'
  }
}
