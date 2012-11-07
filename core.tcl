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
## API.

proc ::famfamfam::intercept {cmdprefix} {
    variable intercept
    if {$cmdprefix eq {}} { set cmdprefix  ::famfamfam::Nop }
    set intercept $cmdprefix
    return
}

proc ::famfamfam::names {} {
    variable known
    return [dict keys $known]
}

# Compatibility alias.
interp alias {} ::famfamfam::Declare {} ::famfamfam::declare

proc ::famfamfam::declare {name icondir {pattern *.png}} {
    variable known
    if {[dict exists $known $name]} {
        return -code error -errorcode {FAMFAMFAM CORE ICONSET KNOWN} \
            "Bad icon set \"$name\", already known"
    }

    namespace eval ::famfamfam::$name {
	variable icon
	variable cache
	array set icon  {} ; # Map: icon name -> icon path
	array set cache {} ; # Map: icon name -> Tk image (Cache)
    }

    namespace upvar ::famfamfam::$name \
	icon icon cache cache

    foreach i [glob -nocomplain -directory $icondir $pattern] {
        set iname [file rootname [file tail $i]]
        set icon($iname) $i
    }

    proc ::famfamfam::${name}::get  {icon}        "[::list ::famfamfam get  $name] \$icon"
    proc ::famfamfam::${name}::list {{pattern *}} "[::list ::famfamfam list $name] \$pattern"
    proc ::famfamfam::${name}::path {icon}        "[::list ::famfamfam path $name] \$icon"

    namespace eval ::famfamfam::$name {
        namespace export get list path
        namespace ensemble create
    }

    dict set known $name .
    return
}

proc ::famfamfam::list {iconset {pattern *}} {
    variable known
    if {![dict exists $known $iconset]} {
        return -code error -errorcode {FAMFAMFAM CORE ICONSET UNKNOWN} \
            "Bad icon set \"$iconset\", not known"
    }

    namespace upvar ::famfamfam::$iconset \
	icon icon
    return [array names icon $pattern]
}

proc ::famfamfam::get {iconset iconname} {
    variable known
    if {![dict exists $known $iconset]} {
        return -code error -errorcode {FAMFAMFAM CORE ICONSET UNKNOWN} \
            "Bad icon set \"$iconset\", not known"
    }

    variable intercept
    namespace upvar ::famfamfam::$iconset \
	icon icon cache cache

    if {![info exists icon($iconname)]} {
        return -code error \
            -errorcode {FAMFAMFAM CORE ICON UNKNOWN} \
            "Bad $iconset icon \"$iconname\", not known"
    }
    # Validate the cache, maybe the image was inadvertently deleted.
    # In that case we have to force regeneration.
    if {[info exists cache($iconname)] &&
        [catch {image type $cache($iconname)}]} {
        unset cache($iconname)
    }
    if {![info exists cache($iconname)]} {
        set cache($iconname) [image create photo -file $icon($iconname)]

        {*}$intercept $iconset $iconname $icon($iconname)
    }
    return $cache($iconname)
}

proc ::famfamfam::path {iconset iconname} {
    variable known
    if {![dict exists $known $iconset]} {
        return -code error -errorcode {FAMFAMFAM CORE ICONSET UNKNOWN} \
            "Bad icon set \"$iconset\", not known"
    }

    namespace upvar ::famfamfam::$iconset \
	icon icon

    if {![info exists icon($iconname)]} {
        return -code error \
            -errorcode {FAMFAMFAM CORE ICON UNKNOWN} \
            "Bad $iconset icon \"$iconname\", not known"
    }

    return $icon($iconname)
}

# # ## ### ##### ######## ############# #####################
## Internal helpers

# Standard reporting hook, doing nothing.
proc ::famfamfam::Nop {args} {}

# # ## ### ##### ######## ############# #####################
## Export

namespace eval ::famfamfam {
    # Set of known icon sets, implemented as dictionary
    variable known {}

    # Callback to report loaded images to.
    variable intercept ::famfamfam::Nop

    namespace export {[a-z]*}
    namespace ensemble create
}

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam 1.1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
