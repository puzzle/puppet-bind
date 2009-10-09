class bind::base::centos inherits bind::base {
    Service[bind]{
        name => 'named',
    }
}
