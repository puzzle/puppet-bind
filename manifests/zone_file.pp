define bind::zone_file(
    $ensure = 'present', 
    $content, 
    $source, 
    $master = false, 
    $public = true
) {
    err ("deprecated")
    include bind

    if $master {
        if $public {
            debug("this space is intentionally left blank")
        }
        else {
            fail ("zone_file for ${name} is master, but not public!")
        }
    }

    $zone_file    = "/var/lib/puppet/modules/bind/zones/${name}"
    $rrs_dir      = "/var/lib/puppet/modules/bind/${name}/rrs"
    $zone_header  = "/var/lib/puppet/modules/bind/${name}/zoneheader"
    $content_file = "${rrs_dir}/content"
    $ns_type = $master ? {
        true  => "masters",
        false => "slaves",
    }
    $registration_file = "/var/lib/puppet/modules/bind/${name}/${ns_type}/${bind_bindaddress}"

    modules_dir {
        [ "bind/${name}", "bind/${name}/masters", "bind/${name}/slaves", "bind/${name}/rrs" ] :
            tag => 'bind'
        }

    @@config_file { $registration_file:
        ensure  => $ensure,
        content => "${bind_bindaddress};\n",
        tag => 'bind'
    }

    nagios::check_domain { $name: }

    if $master {

        # construct the zone file
        concatenated_file {
            $zone_file:
                dir => $rrs_dir,
                header => $zone_header,
                notify => Service["bind"],
        }
        config_file {
            $zone_header:
                content => "\$ORIGIN ${name}.\n\$TTL 86400\n\n";
                #TODO: notify => Exec["concat_${zone_file}"];
            $content_file:
                ensure => $ensure,
                content => $content,
                source => $source,
                #TODO: notify => Exec["concat_${zone_file}"]
        }

        concatenated_file_part {
            "legacy_zone_conf_${name}":
                dir => "/var/lib/puppet/modules/bind/options.d",
                content => "zone \"${name}\" { type master; file \"/var/lib/puppet/modules/bind/zones/${name}\"; };\n"
        }

    }
    else
    {

        $conf_header  = "/var/lib/puppet/modules/bind/${name}/confheader"
        $conf_footer  = "/var/lib/puppet/modules/bind/${name}/conffooter"
        $conf_file    = "/var/lib/puppet/modules/bind/options.d/zone_conf_${name}"
        config_file {
            $conf_header:
                content => "zone \"${name}\" { type slave; file \"${name}\"; masters {\n",
                notify => Exec["concat_${conf_file}"];
            $conf_footer:
                content => "}; };\n",
                notify => Exec["concat_${conf_file}"];
        }
        concatenated_file {
            $conf_file:
                dir => "/var/lib/puppet/modules/bind/${name}/masters",
                header => $conf_header,
                footer => $conf_footer,
                notify => Exec["concat_/etc/bind/named.conf.local"]
        }

    }

}

