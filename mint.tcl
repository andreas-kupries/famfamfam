# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Mint'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam::Declare mint $selfdir/mint/icons
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::mint 1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
