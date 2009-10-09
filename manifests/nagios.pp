# use $domain if namevar is needed for disabiguation
define nagios::check_domain(
    $domain = '', 
    $record_type = 'SOA', 
    $expected_address = '',
    $target_host = $fqdn)
{
    $diggit = $domain ? {
        '' => $name,
        default => $domain
    }

    $real_name = "check_dig3_${diggit}_${record_type}"
    if $bind_bindaddress {
        nagios2::service{$real_name:
            check_command => "check_dig3!$diggit!$record_type!$bind_bindaddress!$expected_address",
            nagios2_host_name => $target_host,
        }
    } else {
        nagios2::service{$real_name:
            check_command => "check_dig2!$diggit!$record_type!$expected_address",
            nagios2_host_name => $target_host,
        }
    }
}
