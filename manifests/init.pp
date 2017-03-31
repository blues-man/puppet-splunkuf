# == Class: splunkuf
#
# Installs and manages the Splunk Universal Forwarder
#
# === Parameters
#
# [*targeturi*]
#   String accepts a deployment server and port
#   e.g. "deploymentserver.tld:8089"
#
# [*system_user*]
#   System user that run splunk binary
#   e.g. "splunk"
#
# === Examples
#
#  class { 'splunkuf':
#    targeturi => 'deploymentserver.tld:8089',
#  }
#
# === Authors
#
# Paul Badcock <paul@bad.co.ck>
#
# === Copyright
#
# Copyright 2015 Paul Badcock, unless otherwise noted.
#
class splunkuf (
  $targeturi    = $::splunkuf::params::targeturi,
  $package_url  = $::splunkuf::params::package_url,
  $systemd      = $::splunkuf::params::systemd,
  $enabled      = $::splunkuf::params::enabled,
  $system_user  = $::splunkuf::params::system_user,
  $mgmthostport = $::splunkuf::params::mgmthostport,
  $unmanaged    = $::splunkuf::params::unmanaged
) inherits splunkuf::params {


  if $unmanaged and !$enabled {

    package { 'splunkforwarder':
      ensure   => absent,
      notify => Exec['purge_dir']
    }

    exec { 'purge_dir':
      command => '/bin/rm -fr /opt/splunkforwarder',
      logoutput => true,
      onlyif => '/usr/bin/test -d /opt/splunkforwarder'

    }

    case $systemd {
      true: {
        file { '/usr/lib/systemd/system/splunkforwarder.service':
              ensure => absent,
              notify => Exec['daemon-reload']
        }
      }
      default: {
        file { '/etc/init.d/splunkforwarder':
          ensure => absent
        }
      }
    }

    exec { 'daemon-reload':
      command => '/usr/bin/systemctl daemon-reload'
    }

  } else {

    if $package_url != undef {
      $provider = $::osfamily ? {
        'RedHat' => 'rpm',
        'Debian' => 'apt',
        default  => 'rpm',
      }
      package { 'splunkforwarder':
        ensure   => installed,
        provider => $provider,
        source   => $package_url
      }
    } else {
      package { 'splunkforwarder':
        ensure => latest,
      }
    }


    case $systemd {
      true: {
        file { '/usr/lib/systemd/system/splunkforwarder.service':
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('splunkuf/splunkforwarder.service.erb'),
        }
      }
      default: {
        file { '/etc/init.d/splunkforwarder':
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('splunkuf/splunkforwarder.erb'),
        }
      }
    }

    file { '/opt/splunkforwarder':
      ensure  => directory,
      owner   => $system_user,
      group   => $system_user,
      recurse => true,
      require => Package['splunkforwarder'],
    }

    if $unmanaged {
      file { '/opt/splunkforwarder/etc/system/local/deploymentclient.conf':
        owner   => $system_user,
        group   => $system_user,
        mode    => '0644',
        replace => 'no',
        content => template('splunkuf/deploymentclient.conf.erb'),
        notify  => Service['splunkforwarder'],
        require => File['/opt/splunkforwarder']
      }

      if $mgmthostport != undef {
        file { '/opt/splunkforwarder/etc/system/local/web.conf':
          owner   => $system_user,
          group   => $system_user,
          mode    => '0644',
          replace => 'no',
          content => template('splunkuf/web.conf.erb'),
          notify  => Service['splunkforwarder'],
          require => Package['splunkforwarder'],
        }
      }
    } else {
      file { '/opt/splunkforwarder/etc/system/local/deploymentclient.conf':
        owner   => $system_user,
        group   => $system_user,
        mode    => '0644',
        content => template('splunkuf/deploymentclient.conf.erb'),
        notify  => Service['splunkforwarder'],
        require => File['/opt/splunkforwarder']
      }

      if $mgmthostport != undef {
        file { '/opt/splunkforwarder/etc/system/local/web.conf':
          owner   => $system_user,
          group   => $system_user,
          mode    => '0644',
          content => template('splunkuf/web.conf.erb'),
          notify  => Service['splunkforwarder'],
          require => Package['splunkforwarder'],
        }
      }

    }

    if $enabled {
      service { 'splunkforwarder':
        ensure => 'running',
        enable => true,
      }
    } else {
      service { 'splunkforwarder':
        ensure => 'stopped',
        enable => false,
      }
    }

  }

}
