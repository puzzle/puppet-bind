# you can have a common pool of 
# zone files set by $bind_zone_files_tag

class bind::base {
    if $use_nagios {
        nagios::service{'check_dns': }
    }

    if ! $bind_zone_files_tag {
        $bind_zone_files_tag = 'bind_zone_files_tag_is_not_set'
    }

    package{ ['bind', 'bind-utils']:
        ensure => present,
    }
    service{'bind':
        ensure => running,
        enable => true,
        name => named,
        hasstatus => true,
        require => Package[bind],
    }
    file{'named.conf':
        path => '/etc/named.conf',
        source => [ "puppet:///modules/site-bind/etc/${fqdn}/named.conf",
                    "puppet:///modules/site-bind/etc/${domain}/named.conf",
                    "puppet:///modules/site-bind/etc/${bind_zone_files_tag}/named.conf",
                    "puppet:///modules/site-bind/etc/default/named.conf" ],
        require => Package[bind],
        notify => Service[bind],
        owner => root, group => named, mode => 0640;
    }
    file{'named.local':
        path => '/etc/named.local',
        source => [ "puppet:///modules/site-bind/etc/${fqdn}/named.local",
                    "puppet:///modules/site-bind/etc/${domain}/named.local",
                    "puppet:///modules/site-bind/etc/${bind_zone_files_tag}/named.local",
                    "puppet:///modules/site-bind/etc/default/named.local" ],
        require => Package[bind],
        notify => Service[bind],
        owner => root, group => named, mode => 0640;
    }
    file{'zone_files':
        path => '/var/named/',
        source => [ "puppet:///modules/site-bind/zone_files/${fqdn}/",
                    "puppet:///modules/site-bind/zone_files/${domain}/",
                    "puppet:///modules/site-bind/zone_files/${bind_zone_files_tag}/",
                    "puppet:///modules/site-bind/zone_files/default/" ],
        require => Package[bind],
        notify => Service[bind],
        recurse => true,
        force => true,
        purge => true,
        owner => root, group => named, mode => 0640; 
    }
}
