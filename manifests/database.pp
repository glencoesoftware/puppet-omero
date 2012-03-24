#
class omero::database (
  $dbtype = hiera('dbtype'),
) {
  class { "omero::database::${dbtype}": }
}
