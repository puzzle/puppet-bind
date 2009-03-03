#
# bind module
# Copyright (c) 2007 David Schmitt <david@schmitt.edv-bus.at>
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

import "zone.pp"

modules_dir { [ "bind", "bind/zones", "bind/options.d" ]: }

import 'defines/*.pp'

# bind will deploy zones files from a source
# you can have a common pool of zone files set by
# $bind_zone_files_tag or in default
class bind {
  case $operatingsystem {
    centos: { include bind::centos }
    debian,ubuntu: { include bind::debian }
    default: { include bind::base }
  }
}

class bind::base {
    package{ ['bind', 'bind-utils']:
        ensure => present,
    }

    service{'bind':
        ensure => running,
        enable => true,
        name => named,
        hasstatus => true,
        require => Package['bind'],
    }

    file{'zone_files':
        path => '/var/named/',
        source => [ "puppet://$server/files/bind/zone_files/${fqdn}/",
                    "puppet://$server/files/bind/zone_files/${domain}/",
                    "puppet://$server/files/bind/zone_files/${bind_zone_files_tag}/",
                    "puppet://$server/files/bind/zone_files/default/" ],
        require => Package['bind'],
        notify => Service['bind'],
        recurse => true,
        purge => true,
        force => true,
        owner => root, group => 0, mode => 0644; 
    }

    if $use_nagios {
        nagios::service { "check_dns": }
    }
}

class bind::centos inherits bind::base {
  Service[bind]{
    name => 'named',
  }
}

class bind::debian inherits bind::base {
  Package[bind]{
    name => 'bind9',
  }
  Package[bind-utils]{
    name => 'dnsutils',
  }

  Service[bind]{
    name => 'bind9',
  }
}
