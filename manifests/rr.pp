define bind::rr(
    $domain,
    $ensure = 'present',
    $content)
{
    include bind::module_dir
    err ("deprecated")
    $zone_file    = "/var/lib/puppet/modules/bind/zones/${domain}"
    $rrs_dir      = "/var/lib/puppet/modules/bind/${domain}/rrs"
    config_file {
        "${rrs_dir}/${name}":
            ensure => $ensure,
            content => $content,
            notify => Exec["concat_${zone_file}"]
    }
}

