class omero::packages (
  $pytables_support = hiera('pytables_support', false),
  $omero_packages = hiera('omero_packages', false),
  $glencoe_release_rpm = hiera('glencoe_release_rpm', ''),
) {

  $packages = [
    'sqlite-devel',
    'zlib-devel',
    'gcc',
    'libxml2-devel',
    'libxslt-devel',
    'apg',
  ]

  # scipy will pull in numpy
  $python_packages = [
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

  # pytables... this is a little kludgy
  # we can build/install via pip but we have to upgrade numpy first
  # there's not an available upgraded package for numby that satisfies pytables
  # kludgy -- may want to roll our own packages for everything...

  if $pytables_support {
    package {
      'hdf5-devel':
        ensure => 'installed',
        tag    => 'pytables-dep',
        ;
      'python-pip':
        ensure => 'installed',
        ;
      'numexpr':
        ensure   => 'installed',
        provider => 'pip',
        tag      => 'pytables-dep',
        require  => Package['pip-numpy'],
        ;
      'Cython':
        ensure   => 'installed',
        provider => 'pip',
        tag    => 'pytables-dep',
        ;
      'pip-numpy':
        name     => 'numpy',
        provider => 'pip',
        ensure   => '1.6.1',
        tag      => 'pytables-dep',
        ;
      'pytables':
        ensure   => 'installed',
        name     => 'tables',
        provider => 'pip',
        ;
    }

    # packages with pip-provider require python-pip
    File['fix-pip-provider'] -> Package <| provider == 'pip' |>
    # all tagged pytables-deps are required for tables
    Package <| tag == 'pytables-dep' |> -> Package['pytables']

    # rhel/centos python-pip package doesn't match with the provider from puppet
    file { 'fix-pip-provider':
      path    => '/usr/bin/pip',
      ensure  => 'link',
      target  => '/usr/bin/pip-python',
      require => [ Package['python-pip'], Yumrepo['epel'] ],
    }
  }

  if $omero_packages {
    package {
      'glencoesoftware-release':
        ensure   => 'installed',
        source   => $glencoe_release_rpm,
        provider => 'rpm',
        ;
      'omero':
        ensure => 'installed',
        require => Package['glencoesoftware-release'],
        ;
      'omero-server':
        ensure  => 'installed',
        require => Package['glencoesoftware-release'],
        ;
      'omero-server-sql':
        ensure  => 'installed',
        require => Package['glencoesoftware-release'],
        ;
    }
  } else {
    # java setup and install
    class { 'omero::java': }

    # ice
    class { 'omero::ice': }
  }
}
