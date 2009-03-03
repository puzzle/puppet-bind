# manifests/cache.pp

class bind::cache {
    include bind
    package{'caching-nameserver':
        ensure => installed,
        require => Package['bind'],
        notify => Service['bind'],
    }
}
