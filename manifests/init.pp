#
# bind module
# Copyright (c) 2007 David Schmitt <david@schmitt.edv-bus.at>
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

class bind {
  case $operatingsystem {
    centos: { include bind::base::centos }
    debian,ubuntu: { include bind::base::debian }
    default: { include bind::base }
  }
}
