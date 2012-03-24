#
class omero::web::apache::disabled {
  package {
    'httpd':
      name     => 'httpd',
      ensure => 'absent',
      ;
    'mod_fastcgi':
      ensure => 'absent',
      ;
  }

  service { 'httpd':
    ensure => 'stopped',
  }
}
