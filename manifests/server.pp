
class bind::server {
    if $use_nagios {
        nagios::service { "check_dns": }
    }

    config_file { "/etc/bind/named.conf.options":
        content => template( "bind/named.conf.options.erb"),
        notify => Service["bind"]
    }

    concatenated_file {
        "/etc/bind/named.conf.local":
            dir => "/var/lib/puppet/modules/bind/options.d",
    }

    concatenated_file_part {
        legacy_include:
            dir => "/var/lib/puppet/modules/bind/options.d",
            content => "include \"/var/local/puppet/bind/edv-bus/config/master.conf\";\n",
    }

    Config_file <<| tag == 'bind' |>>
}

