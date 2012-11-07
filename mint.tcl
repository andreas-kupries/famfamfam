# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Mint'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# @mdgen OWNER: mint/*
# @mdgen OWNER: mint/icons/*

# Kettle
# @owns: mint

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam 1.1

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam declare mint $selfdir/mint/icons
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::mint 1.0.1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
