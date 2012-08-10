#
class omero::web::apache::disabled {
  service { 'httpd':
    ensure => 'stopped',
  }
}
