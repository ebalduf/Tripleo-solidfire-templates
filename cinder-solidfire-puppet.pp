if hiera('cinder_enable_solidfire_backend', false) {
  $cinder_solidfire_backend = hiera('cinder::backend::solidfire::title')

  cinder::backend::solidfire { $cinder_solidfire_backend :
    san_ip                      => hiera('cinder::backend::solidfire::san_ip', undef),
    san_login                   => hiera('cinder::backend::solidfire::san_login', undef),
    san_password                => hiera('cinder::backend::solidfire::san_password', undef),
    sf_emulate_512              => hiera('cinder::backend::solidfire::sf_emulate_512', undef),
    sf_allow_tenant_qos         => hiera('cinder::backend::solidfire::sf_allow_tenant_qos', undef),
    sf_account_prefix           => hiera('cinder::backend::solidfire::sf_account_prefix', undef),
    sf_api_port                 => hiera('cinder::backend::solidfire::sf_api_port', undef),
  }

  # This mess is to not screw up already configured backends. This is fixed in Liberty.
  if hiera('cinder_enable_iscsi_backend', true) {
    $cinder_iscsi_backend = 'tripleo_iscsi'
  }
  if hiera('cinder_enable_rbd_backend', false) {
    $cinder_rbd_backend = 'tripleo_ceph'
  }
  if hiera('cinder_enable_eqlx_backend', false) {
    $cinder_eqlx_backend = hiera('cinder::backend::eqlx::volume_backend_name')
  }
  if hiera('cinder_enable_dellsc_backend', false) {
    $cinder_dellsc_backend = hiera('cinder::backend::dellsc_iscsi::volume_backend_name')
  }
  if hiera('cinder_enable_netapp_backend', false) {
    $cinder_netapp_backend = hiera('cinder::backend::netapp::title')
  }
  if hiera('cinder_enable_nfs_backend', false) {
    $cinder_nfs_backend = 'tripleo_nfs'
  }
  $cinder_enabled_backends = delete_undef_values([$cinder_iscsi_backend, $cinder_rbd_backend, $cinder_eqlx_backend, $cinder_dellsc_backend, $cinder_netapp_backend, $cinder_nfs_backend])
  class { '::cinder::backends' :
    enabled_backends => union($cinder_enabled_backends, hiera('cinder_user_enabled_backends')),
  }
}
