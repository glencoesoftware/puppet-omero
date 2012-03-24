#
class omero::web::apache (
  $rpmforge_release_rpm = hiera('rpmforge_release_rpm'),
) {

  package {
    'httpd':
      name => 'httpd',
      ;
    'mod_fastcgi':
      name    => 'mod_fastcgi',
      require => Package['rpmforge-release'],
      ;
    'rpmforge-release':
      source   => $rpmforge_release_rpm,
      provider => 'rpm',
      ;
  }

  service { 'httpd':
    ensure     => 'running',
    hasstatus  => 'true',
    hasrestart => 'true',
    require    => Package['httpd'],
    restart    => '/sbin/service httpd graceful',
  }
}
