define bind::soa(
    $primary, $hostmaster, $serial,
    $ensure = 'present',
    $refresh = 7200, $retry = 3600, $expire = 604800, $minimum = 600)
{
    err ("deprecated")
    include bind::module_dir
    $zone_file    = "/var/lib/puppet/modules/bind/zones/${name}"
    $rrs_dir      = "/var/lib/puppet/modules/bind/${name}/rrs"
    config_file {
        "${rrs_dir}/00_soa":
            ensure => $ensure,
            content => "${name}.        SOA ${primary} ${hostmaster} ( ${serial} ${refresh} ${retry} ${expire} ${minimum} )\n",
            # notify => Exec["concat_${zone_file}"]
    }
}
