# -*- tcl -*-
# A Tcl packaging of the FamFamFam Icon set 'Silk'.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam

# # ## ### ##### ######## ############# #####################
## Initialization

::apply {{selfdir} {
    ::famfamfam::Declare silk $selfdir/silk/icons
}} [file dirname [file normalize [info script]]]

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::silk 1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
