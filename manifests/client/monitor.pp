
# ::xymon::client::monitor
define xymon::client::monitor (
  $cmd_file_source,
  $disabled         = false,
  $onhost           = undef,
  $maxtime          = undef,
  $needs            = undef,
  $group            = undef,
  $interval         = undef,
  $crondate         = undef,
  $envarea          = undef,
  $cfg_file_source  = undef,
  $cfg_file_content = '',
  $extra_packages   = {},
) {
  include ::xymon::client

  concat::fragment { $name:
    target  => $::xymon::params::default_client_task_file,
    content => template('xymon/client/monitor.cfg.erb'),
    notify  => Class['::xymon::client::service'],
  }

  file { "${::xymon::params::default_client_ext_dir}/${name}":
    ensure => 'file',
    notify => Class['::xymon::client::service'],
    owner  => $::xymon::params::default_user,
    group  => $::xymon::params::default_group,
    mode   => '0755',
    source => $cmd_file_source,
  }
  
  if($cfg_file_content != '' and $cfg_file_source){
    fail('Only one configuration file is permitted for monitors. Choose one between $cfg_file_content and $cfg_file_source')
  } elsif($cfg_file_content != ''){
    file { "${::xymon::params::default_client_etc_dir}/${name}.cfg":
      ensure  => 'file',
      notify  => Class['::xymon::client::service'],
      mode    => '0644',
      content => $cfg_file_content,
    }
    
  } elsif ($cfg_file_source) {
    file { "${::xymon::params::default_client_etc_dir}/${name}.cfg":
      ensure => 'file',
      notify => Class['::xymon::client::service'],
      mode   => '0644',
      source => $cfg_file_source,
    }
  }

  $defaults = {
    ensure => 'present',
  }
  create_resources('package', $extra_packages, $defaults)

}
