# Class: omero::web::nginx::disabled
#
# This class does stuff that you describe here
#
# Parameters:
#   $parameter:
#       this global variable is used to do things
#
# Actions:
#   Actions should be described here
#
# Requires:
#   - Package["foopackage"]
#
# Sample Usage:
#
class omero::web::nginx::disabled {
  package { 'nginx':
    ensure => 'absent',
  }

  service { 'nginx':
    ensure => 'stopped',
  }
}
