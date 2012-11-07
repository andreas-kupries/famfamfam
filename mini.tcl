# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Mini'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# @mdgen OWNER: mini/*
# @mdgen OWNER: mini/icons/*

# Kettle
# @owns: mini

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam 1.1

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam declare mini $selfdir/mini/icons *.gif
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::mini 1.0.1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
