# class encompassing setup / deps for building omero vs running it
# this class is probably only interseting to developers / maintainers
#
class omero::build {
  package {
    'epydoc':
      ensure => 'installed',
      ;
    'findbugs':
      ensure => 'installed',
      ;
  }

  class { 'omero::packages': }
}
