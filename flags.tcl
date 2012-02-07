# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Flags'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam::Declare flags $selfdir/flags/icons
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::flags 1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
