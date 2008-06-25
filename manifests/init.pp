#
# bind module
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

# modules_dir { \"bind\": }

class bind {
    include bind::base
}

class bind::base {
    package{'bind':
        ensure => present,
    }
    service{bind:
        ensure => running,
        enable => true,
        hasstatus => true,
        require => Package[bind],
    }
}
