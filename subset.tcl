# -*- tcl -*-

# A package to collect the images loaded by icon sets based on famfamfam::core
# as into a new package and to serve as stand-in for the icon sets the images
# were collected from.

# Inspired by the subset patch send to me by
#	W. T. Schueller <wtschueller@users.sourceforge.net>
# and fixing the issues I had with how said patch went about its work.

# @mdgen OWNER: subset/*
# @mdgen OWNER: subset/icons/*

# # ## ### ##### ######## ############# #####################
## Requisites

package require famfamfam 1.1

namespace eval ::famfamfam::subset {}

# # ## ### ##### ######## ############# #####################
## API - Start interception and saving.

proc ::famfamfam::subset::new {name version dst} {
    # Create a package NAME + VERSION with saved icons at the given
    # location.

    variable ptemplate
    variable ttemplate
    variable template
    variable destination

    if {$destination ne {}} {
        return -code error "Assembly in progress, unable to start a second"
    }

    set destination $dst

    # Create the directory we will collect the images in.
    file mkdir $destination

    lappend map @@name@@    $name
    lappend map @@qname@@   [list $name]
    lappend map @@version@@ $version
    lappend map @@time@@    [clock format [clock seconds]]
    lappend map @@qtime@@   [list [clock format [clock seconds]]]
    lappend map @@user@@    $::tcl_platform(user)

    # Generate a package index ...
    set    c [open $destination/pkgIndex.tcl w]
    puts  $c [string map $map $ptemplate]
    close $c

    # ... And the package code
    set    c [open $destination/loader.tcl w]
    puts  $c [string map $map $template]
    close $c

    # Generate a teapot.txt ...
    set    c [open $destination/teapot.txt w]
    puts  $c [string map $map $ttemplate]
    close $c

    # At last tell the core to report to us which images are loaded so
    # that we can record them into the package we are creating.
    famfamfam intercept ::famfamfam::subset::save
    return
}

proc ::famfamfam::subset::save {iconset iconname iconpath} {
    variable destination

    if {$destination eq {}} {
        return -code error "No assembly in progress."
    }

    # Record the image into the package we are assembling.

    file mkdir $destination/icons/$iconset
    file copy -force -- $iconpath $destination/icons/$iconset/
    return
}

proc ::famfamfam::subset::done {} {
    # Stop recording.
    variable destination

    if {$destination eq {}} {
        return -code error "No assembly in progress"
    }

    set destination {}
    famfamfam intercept {}
    return
}

# # ## ### ##### ######## ############# #####################
## Export

namespace eval ::famfamfam::subset {
    # Directory a new package is assembled in.
    variable destination {}

    variable dedent    [list "\n        " "\n"]
    variable ptemplate [string trim [string map $dedent {
        package ifneeded @@qname@@ @@version@@ [list source [file join $dir loader.tcl]]
    }]]

    variable template [string trim [string map $dedent {
        # -*- tcl -*- Generated package @@name@@
        #
        # Generated by package famfamfam::subset
        # at  @@time@@
        # for @@user@@
        #
        # @mdgen OWNER: *
        # @mdgen OWNER: icons/*

        # NOTE: The icons stored with this package are copied out of
        # the other famfamfam packages and are under their
        # copyright.
        #
        # This work is licensed under a
        # Creative Commons Attribution 2.5 License.
        # [ http://creativecommons.org/licenses/by/2.5/ ]
        #
        # This means you may use it for any purpose, and make any
        # changes you like.  All I ask is that you include a link back
        # to this page in your credits if possible.
        #
        # Are you using this icon set? Send me an email (a link or
        # picture if available) to mjames@gmail.com
        #
        # Any other questions about this icon set please contact
        # mjames@gmail.com
        #
        # See also http://www.famfamfam.com.

        # Requisites...
        package require Tcl 8.5 ; # apply
        package require famfamfam 1.1

        # Initialization...
        ::apply {{selfdir} {
            # We declare all the sub-directories we find as our icon sets
            foreach path [glob -nocomplain -types d -directory $selfdir/icons *] {
                set iconset [file tail $path]
                ::famfamfam declare $iconset $path *
            }
        }} [file dirname [file normalize [info script]]]

        # Ready...
        package  provide @@qname@@ @@version@@
        # Note: Keep the double spacing to hide the above command from build.tcl (version)
        return
    }]]

    variable ttemplate [string trim [string map $dedent {
        Package @@qname@@ @@version@@
        Meta platform tcl
        Meta require famfamfam
        Meta entrykeep .
        Meta included pkgIndex.tcl
        Meta included loader.tcl
        Meta included icons
        Meta build::date @@qtime@@
        Meta author @@user@@
        Meta category icons
        Meta license BSD
        Meta subject icon subset famfamfam 
        Meta description Binding for a subset of the famfamfam icon sets
    }]]

    namespace export {[a-z]*}
    namespace ensemble create
}

# # ## ### ##### ######## ############# #####################
## Ready

package provide famfamfam::subset 1
return

# # ## ### ##### ######## ############# #####################
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
