#
class omero::repo (
  $repo_dir = hiera('omero_data_repo_dir'),
  $repo_owner = hiera('omero_data_repo_owner'),
  $repo_group = hiera('omero_data_repo_group'),
  $mode = hiera('omero_data_repo_perms'),
  $repo_target = hiera('omero_data_repo_link', ''),
) {
  file { 'repo-dir':
    path   => $repo_dir,
    ensure => $repo_target ? { '' => 'directory', default => 'link' },
    target => $repo_target ? { '' => 'notlink', default   => $repo_target },
    owner  => $repo_owner,
    group  => $repo_group,
    mode   => $mode,
  }
}
