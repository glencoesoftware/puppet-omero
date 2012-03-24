# default settings go here
# hiera looks at this class to find values
# should never be directly included
# anything here needs a hiera call to be used
# these settings should be overridden by another hiera backend
# do not edit without knowing what you are doing
# these are references
#
class omero::data {
  # general os settings
  $omero_owner = 'omero'
  $omero_group = 'omero'

  # create the omero user?
  $create_omero_user = true

  # directories
  $omero_home = '/opt/omero'
  $ice_home = '/usr/share/Ice-3.3.1'

  # these don't have defaults but are listed for reference
  $omero_home_link = ''
  $omero_data_repo_link = ''
  $postgres_custom_service_name = ''
  $omero_web_config = ''
  $omero_web_config_source = ''

  # software decisions
  $webtype = 'apache'
  $dbtype = 'postgres'
  $java_version = '1.6.0'

  $epel_release_rpm = 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm'
  $rpmforge_release_rpm = 'http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm'
  $nginx_release_rpm = 'http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm'
  $java_repo_url = "http://sloth.glencoesoftware.com/yum/java-sun-jdk/${operatingsystemrelease}/${architecture}/"
  $zeroc_ice_repo_url = "http://sloth.glencoesoftware.com/yum/zeroc-ice/${operatingsystemrelease}/${architecture}"

  # database settings
  $postgres_version = '9.1'
  $postgres_user = 'postgres'
  $omero_db_user = 'omero'
  $omero_db_pass = 'omero'
  $omero_dbname = 'omero'
  $db_version = 'OMERO4.3'
  $db_patch = '0'
  $root_password = 'omeroroot'

  # data repo settings
  $omero_data_repo_dir = '/OMERO'
  $omero_data_repo_owner = 'omero'
  $omero_data_repo_group = 'omero'
  $omero_data_repo_perms = '0775'

  # development only -- if you want to setup the structure for omero without actually having omero installed/setup
  $omero_installed = false
}
