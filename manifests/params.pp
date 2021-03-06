# == Class: params
#
# Default settings for Splunk Universal Forwarder
#
# === Variables
#
# [*targeturi*]
#   String accepts a deployment server and port.
#   e.g. "deploymentserver.tld:8089"
#
# [*system_user*]
#   System user that run splunk binary
#   e.g. "splunk"
#
# === Authors
#
# Paul Badcock <paul@bad.co.ck>
#
# === Copyright
#
# Copyright 2015 Paul Badcock, unless otherwise noted.
#
class splunkuf::params {
  $targeturi   = 'spunk.tld:8089'
  $system_user = 'splunk'
  $package_url     = undef

  $mgmthostport = undef

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      if $::operatingsystemmajrelease >= 7 {
        $systemd = true
      }
    }
    'Debian': {
      if $::operatingsystemmajrelease >= 8 {
        $systemd = true
      }
    'Debian': {
      if $::operatingsystemmajrelease >= 8 {
        $systemd = true
    }
    'Ubuntu': {
      if $::operatingsystemmajrelease >= 15 {
        $systemd = true
      }
        $systemd = true
      }
    }
    default: {
      $systemd = false
    }
  }
}
