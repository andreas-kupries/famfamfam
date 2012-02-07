# -*- tcl -*-
# Core functionality for the icon set packages.
# Copyright (c) 2012 Andreas Kupries <andreas_kupries@users.sourceforge.net>

# # ## ### ##### ######## ############# #####################
## IDEAS / FUTURE
# - Commands to generate packages containing a subset of the icon set.
#   - With the icons hardwired into the package code (base64 encoded).
#     => Deployable as Tcl Module.
#   - With the icons in a subdirectory as for this package.
#   - With the icons attached to the base tcl code (virtual fs).

# # ## ### ##### ######## ############# #####################
## Requisites

package require Tcl 8.5
package require Tk 8.5
package require img::png

namespace eval ::famfamfam {}

# # ## ### ##### ######## ############# #####################
## API

proc ::famfamfam::Declare {name icondir {pattern *.png}} {
    namespace eval ::famfamfam::$name {
	variable icon
	variable cache
	array set icon  {} ; # Map: icon name -> icon path
	array set cache {} ; # Map: icon name -> Tk image (Cache)
    }

    namespace upvar ::famfamfam::$name \
	icon icon cache cache

    foreach i [glob -directory $icondir $pattern] {
        set iname [file rootname [file tail $i]]
        set icon($iname) $i
    }

    proc ::famfamfam::${name}::get  {icon}        "[list ::famfamfam::Get  $name] \$icon"
    proc ::famfamfam::${name}::list {{pattern *}} "[list ::famfamfam::List $name] \$pattern"

    namespace eval ::famfamfam::$name {
        namespace export get list
        namespace ensemble create
    }
    return
}

proc ::famfamfam::List {iconset {pattern *}} {
    namespace upvar ::famfamfam::$iconset \
	icon icon
    return [array names icon $pattern]
}

proc ::famfamfam::Get {iconset iconname} {
    namespace upvar ::famfamfam::$iconset \
	icon icon cache cache

    if {![info exists icon($iconname)]} {
        return -code error "Bad $iconset icon name \"$iconname\""
    }
    if {![info exists cache($iconname)]} {
        set cache($iconname) [image create photo -file $icon($iconname)]
    }
    return $cache($iconname)
}

# # ## ### ##### ######## ############# #####################
## Export

namespace eval ::famfamfam {
    namespace export {[a-z]*}
    namespace ensemble create
}

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam 1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
