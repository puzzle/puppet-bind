# manifests/defines/ddnsfile.pp

define bind::ddnsfile(
    $chroot = false
){
    if $chroot {
        $target = "/var/named/chroot/var/named/${name}"
        $require = Package['bind']
    } else {
        $target = "/var/named/${name}"
        $require = Package['bind-chroot']
    }
    file{"${target}":
        source => [ "puppet://$server/files/bind/ddns/${fqdn}/${name}",
                    "puppet://$server/files/bind/ddns/${domain}/${name}",
                    "puppet://$server/files/bind/ddns/default/${name}" ],
        replace => false,
        require => $require,
        notify => Service['bind'],
        owner => named, group => named, mode => 0640;
    }

}
