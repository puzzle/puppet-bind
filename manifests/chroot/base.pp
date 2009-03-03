# manifests/chroot/base.pp

class bind::chroot::base inherits bind::base {
    package{'bind-chroot':
        ensure => installed,
        require => Package['bind'],
    }
    File['named.conf']{
        path => '/var/named/chroot/etc/named.conf',
    }
    file{'/etc/named.conf':
        ensure => '/var/named/chroot/etc/named.conf',
    }
    File['named.local']{
        path => '/var/named/chroot/etc/named.local',
    }
    file{'/etc/named.local':
        ensure => '/var/named/chroot/etc/named.local',
    }
    File['zone_files']{
        path => '/var/named/chroot/var/named/',
        require +> Package['bind-chroot'],
    }
}
