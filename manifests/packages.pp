class omero::packages {

  $packages = [
    'sqlite-devel',
    'zlib-devel',
    'gcc',
    'libxml2-devel',
    'libxslt-devel',
    'apg',
  ]

  $python_packages = [
    'numpy',
    'scipy',
    'python-imaging',
    'python-devel',
  ]

  # pytables ommited
  # bit of a rabbit hole here pytables in pip requires >1.4
  # you can upgrade numpy from pip but then you have to upgrade
  # numexp as well -- not sure how deep it goes

  package {
    $packages:
      ensure => 'installed',
      ;
    $python_packages:
      ensure => 'installed',
      ;
  }

  # java setup and install
  class { 'omero::java': }

  # ice
  class { 'omero::ice': }

}
