# == Class xymon::params
#
# This class is meant to be called from xymon.
# It sets variables according to platform.
#
class xymon::params {

  include xymon

  $default_user               = 'xymon'
  $default_group              = 'xymon'

  if($::xymon::enable_terabithia_repo){
    $default_client_config_file = '/etc/sysconfig/xymon-client'
    $default_home_dir           = '/usr/share/xymon-client'
    $default_client_task_file   = '/etc/xymon-client/clientlaunch.cfg'
    $default_client_etc_dir   = "${default_home_dir}/etc"
    $default_client_ext_dir   = "${default_home_dir}/ext"
    $default_client_package_provider = 'yum'
    $default_client_package_file = undef
  } else {
    $default_client_config_file = '/etc/default/xymon-client'
    $default_home_dir           = '/usr/lib/xymon'
    $default_client_task_file   = "${default_home_dir}/client/etc/clientlaunch.cfg"
    $default_client_etc_dir   = "${default_home_dir}/client/etc"
    $default_client_ext_dir   = "${default_home_dir}/client/ext"


    case $::osfamily {
      'Debian'           : {
        $default_client_package_file = 'xymon-client'
        $default_client_package_provider = 'apt'
      }
      'RedHat': {
        case $::operatingsystem {
          'RedHat', 'CentOS': {
            if ($::architecture == 'x86_64') {
              if versioncmp($::operatingsystemrelease, '6.0.0') < 0 {
                $default_client_package_file = 'http://downloads.sourceforge.net/project/xymon/Xymon/4.3.10/RHEL5/xymon-client-4.3.10-1.x86_64.rpm'
              } else {
                $default_client_package_file = 'http://downloads.sourceforge.net/project/xymon/Xymon/4.3.10/RHEL6/xymon-client-4.3.10-1.x86_64.rpm'
              }
            }
          }
          'Fedora':{
            if ($::architecture == 'x86_64') {
              $default_client_package_file = 'http://downloads.sourceforge.net/project/xymon/Xymon/4.3.10/Fedora17/xymon-client-4.3.10-1.x86_64.rpm'
            } else {
              $default_client_package_file = 'http://downloads.sourceforge.net/project/xymon/Xymon/4.3.10/Fedora17/xymon-client-4.3.10-1.i386.rpm'
            }
          }
          default: {
            fail("${::operatingsystem} not supported")
          }
        }
        $default_client_package_provider = 'rpm'
      }
      default: {
        fail("${::operatingsystem} not supported")
      }
    }
  }
}

