#
class omero::ice (
  $repo_url = hiera('zeroc_ice_repo_url'),
) {
  $ice_packages = [
    'ice',
    'ice-python',
    'ice-servers',
    'ice-libs',
    'ice-utils',
    'ice-java-devel',
    'ice-python-devel',
    'ice-java',
  ]

  if !defined(Package['glencoesoftware-release']) {
    yumrepo { 'zeroc-ice':
      baseurl  => $repo_url,
      descr    => 'ZeroC Ice Packages',
      gpgcheck => '0',
      before   => Package[$ice_packages],
    }
  }

  package { $ice_packages:
    ensure  => 'installed',
  }
}
