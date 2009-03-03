# manifests/chroot/base.pp

class bind::chroot::base inherits bind::base {
    package{'bind-chroot':
        ensure => installed,
        require => Package['bind'],
    }
    File['zone_files']{
        path => '/var/named/chroot/var/named/',
        require +> Package['bind-chroot'],
    }
}
