# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Silk'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# @mdgen OWNER: silk/*
# @mdgen OWNER: silk/icons/*

# Kettle
# @owns: silk

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam 1.1

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam declare silk $selfdir/silk/icons
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::silk 1.0.1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
