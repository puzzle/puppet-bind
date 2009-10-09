class bind::base::debian inherits bind::base {
    Package[bind]{
        name => 'bind9',
    }
    Package[bind-utils]{
        name => 'dnsutils',
    }
    Service[bind]{
        name => 'bind9',
    }
}
