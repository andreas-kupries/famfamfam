# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Flags'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# @mdgen OWNER: flags/*
# @mdgen OWNER: flags/icons/*

# Kettle
# @owns: flags

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam 1.1

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam declare flags $selfdir/flags/icons
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::flags 1.0.1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
