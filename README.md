# splunkuf

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with splunkuf](#setup)
    * [What splunkuf affects](#what-splunkuf-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with splunkuf](#beginning-with-splunkuf)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The SplunkUF module manages the Splunk Universal forwarder on RedHat, Debian, and Ubuntu.

## Module Description

This module installs the Splunk Universal forwarder only and will configure it to talk to a deployment server. Supported OS's include RedHat, Debian, and Ubuntu.

For a more full featured Splunk intall or module look at [huit/splunk](https://forge.puppetlabs.com/huit/splunk)

## Setup

### What splunkuf affects

* /etc/init.d/splunkforwarder
* /opt/splunkforwarder

### Setup Requirements

Have access to a yum repostiroy or debian repository with splunkforwarder from [Splunk](http://www.splunk.com/en_us/download/universal-forwarder.html)

### Beginning with splunkuf

The only mode this module has is to install a [Universal Forwarder](http://docs.splunk.com/Documentation/Splunk/6.2.3/Forwarding/Introducingtheuniversalforwarder) If you need a fully featured Splunk install [huit/splunk](https://forge.puppetlabs.com/huit/splunk)

## Usage

To use the universal forwarder one parameter can be passed to the class to set the deployment server to communicate with

```Puppet
class { 'splunkuf':
  targeturi => 'deployment.tld:8089',
}
```

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

####RHEL/CentOS 7
RHEL/CentOS 7 is fully supported and functional

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc 

### v0.1.0
* Initial work