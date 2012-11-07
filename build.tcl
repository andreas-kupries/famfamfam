#!/bin/sh
# -*- tcl -*- \
exec tclsh "$0" ${1+"$@"}
package require Tcl 8.5
set me [file normalize [info script]]
set packages {
    {famfamfam       core.tcl  0}
    {famfamfam_silk  silk.tcl  1}
    {famfamfam_flags flags.tcl 1}
    {famfamfam_mini  mini.tcl  1}
    {famfamfam_mint  mint.tcl  1}
    {famfamfam_subset subset.tcl 0}
}
set applications {
    icon_selector
}
proc main {} {
    global argv tcl_platform tag
    set tag {}
    if {![llength $argv]} {
	if {$tcl_platform(platform) eq "windows"} {
	    set argv gui
	} else {
	    set argv help
	}
    }
    if {[catch {
	eval _$argv
    }]} usage
    exit 0
}
proc usage {{status 1}} {
    global errorInfo
    if {($errorInfo ne {}) &&
	![string match {invalid command name "_*"*} $errorInfo]
    } {
	puts stderr $::errorInfo
	exit
    }

    global argv0
    set prefix "Usage: "
    foreach c [lsort -dict [info commands _*]] {
	set c [string range $c 1 end]
	if {[catch {
	    H${c}
	} res]} {
	    puts stderr "$prefix$argv0 $c args...\n"
	} else {
	    puts stderr "$prefix$argv0 $c $res\n"
	}
	set prefix "       "
    }
    exit $status
}
proc tag {t} {
    global tag
    set tag $t
    return
}
proc myexit {} {
    tag ok
    puts DONE
    return
}
proc log {args} {
    global tag
    set newline 1
    if {[lindex $args 0] eq "-nonewline"} {
	set newline 0
	set args [lrange $args 1 end]
    }
    if {[llength $args] == 2} {
	lassign $args chan text
	if {$chan ni {stdout stderr}} {
	    ::_puts {*}[lrange [info level 0] 1 end]
	    return
	}
    } else {
	set text [lindex $args 0]
	set chan stdout
    }
    # chan <=> tag, if not overriden
    if {[string match {Files left*} $text]} {
	set tag warn
	set text \n$text
    }
    if {$tag eq {}} { set tag $chan }
    #::_puts $tag/$text

    .t insert end-1c $text $tag
    set tag {}
    if {$newline} { 
	.t insert end-1c \n
    }

    update
    return
}
proc +x {path} {
    catch { file attributes $path -permissions u+x }
    return
}
proc grep {file pattern} {
    set lines [split [read [set chan [open $file r]]] \n]
    close $chan
    return [lsearch -all -inline -glob $lines $pattern]
}
proc version {file} {
    #puts GREP\t[join [grep $file {*package provide *}] \nGREP\t]
    set v [lindex [grep $file {*package provide *}] 0 3]
    puts "Version:  $v"
    return $v
}
proc Hhelp {} { return "\n\tPrint this help" }
proc _help {} {
    usage 0
    return
}
proc Hrecipes {} { return "\n\tList all brew commands, without details." }
proc _recipes {} {
    set r {}
    foreach c [info commands _*] {
	lappend r [string range $c 1 end]
    }
    puts [lsort -dict $r]
    return
}
proc Hdrop {} { return "?destination?\n\tUninstall all packages and applications.\n\tdestination = path of package directory, default \[info library\]." }
proc _drop {{ldir {}}} {
    global packages applications
    if {[llength [info level 0]] < 2} {
	set ldir [info library]
	set bdir [file dirname [info nameofexecutable]]
    } else {
	set bdir [file dirname $ldir]/bin
    }

    foreach item $packages {
	foreach {dir vfile icons} $item break
	set name $dir
	set src      [file dirname $::me]/$vfile
	set version  [version $src]
	set pkg [string map {_ ::} $dir]

	file delete -force $ldir/$name$version
	puts -nonewline "Removed package:     "
	tag ok
	puts $ldir/$name$version
    }

    foreach item $applications {
	file delete -force $bdir/$item
	puts -nonewline "Removed application: "
	tag ok
	puts $bdir/$item
    }
    return
}
proc Hdoc {} { return "\n\t(Re)Generate the embedded documentation." }
proc _doc {} {
    cd [file dirname $::me]/doc

    puts "Removing old documentation..."
    file delete -force ../embedded/man
    file delete -force ../embedded/www

    # TODO == require doctools packages, or dtplite-as-package
    puts "Generating man pages..."
    exec 2>@ stderr >@ stdout dtplite        -o ../embedded/man -ext n nroff .
    puts "Generating 1st html..."
    exec 2>@ stderr >@ stdout dtplite -merge -o ../embedded/www html .
    puts "Generating 2nd html, resolving cross-references..."
    exec 2>@ stderr >@ stdout dtplite -merge -o ../embedded/www html .

    return
}
proc Hfigures {} { return "\n\t(Re)Generate the figures." }
proc _figures {} {
    cd [file dirname $::me]/doc/figures

    # TODO == require dia packages, or dia-as-package
    puts "Generating figures (dia)..."
    exec 2>@ stderr >@ stdout dia convert -t -o . png {*}[glob *.dia]
    return
}
proc Hshow-figures {} { return "\n\tShow the figures." }
proc _show-figures {} {
    cd [file dirname $::me]/doc/figures

    # TODO == require dia packages, or dia-as-package
    puts "Showing the figures (dia)..."
    exec 2>@ stderr >@ stdout dia show -t {*}[glob *.dia]
    return
}
proc Hinstall {} { return "?destination?\n\tInstall all packages and applications.\n\tdestination = path of package directory, default \[info library\]." }
proc _install {{ldir {}}} {
    global packages applications
    if {$ldir eq {}} {
	set ldir [info library]
	set bdir [file dirname [info nameofexecutable]]
    } else {
	set bdir [file dirname $ldir]/bin
    }

    # Create directories, might not exist.
    file mkdir $ldir
    file mkdir $bdir

    foreach item $packages {
	# Package: /name/

	foreach {dir vfile icons} $item break
	set name $dir
	set version  [version [file dirname $::me]/$vfile]
	set pkg [string map {_ ::} $dir]

	file mkdir                                               $ldir/${name}-new
	file copy -force [file dirname $::me]/$vfile             $ldir/${name}-new
	if {$icons} {
	    file copy -force [file dirname $::me]/[file root $vfile] $ldir/${name}-new
	}

	set    c [open $ldir/${name}-new/pkgIndex.tcl w]
	puts  $c "package ifneeded $pkg $version \[list ::apply {{dir} {source \$dir/$vfile}} \$dir\]"
	close $c

	set    c [open $ldir/${name}-new/teapot.txt w]
	puts $c "Package $pkg $version"
	puts $c "Meta platform tcl"
	puts $c "Meta entrykeep ."
	puts $c "Meta included pkgIndex.tcl"
	puts $c "Meta included $vfile"
	puts $c "Meta subject icon famfamfam "
	puts $c "Meta build::date [clock format [clock seconds] -format {%Y-%m-%d}]"
	puts $c "Meta author \{Andreas Kupries\}"
	puts $c "Meta as::origin http://chiselapp.com/user/andreas_kupries/repository/famfamfam/home"
	puts $c "Meta category icons"
	puts $c "Meta license BSD"
	if {$icons} {
	    set icons [file root $vfile]
	    puts $c "Meta require famfamfam"
	    puts $c "Meta subject $icons"
	    puts $c "Meta included $icons"
	    puts $c "Meta description Binding to the famfamfam $icons icon set"
	} else {
	    puts $c "Meta description Common code for the famfamfam icon bindings"
	}
	close $c

	file delete -force $ldir/$name$version
	file rename        $ldir/${name}-new     $ldir/$name$version
	puts "Installed package:     $ldir/$name$version"
    }

    foreach item $applications {
	file copy -force [file dirname $::me]/$item $bdir/${item}-new
	file delete -force $bdir/$item
	file rename $bdir/${item}-new     $bdir/$item
	puts "Installed application: $bdir/$item"
    }
    return
}
proc Hgui {} { return "\n\tInstall all packages.\n\tDone from a small GUI." }
proc _gui {} {
    global INSTALLPATH
    package require Tk
    package require widget::scrolledwindow

    wm protocol . WM_DELETE_WINDOW ::_exit

    label  .l -text {Install Path: }
    entry  .e -textvariable ::INSTALLPATH
    button .i -command Install -text Install

    widget::scrolledwindow .st -borderwidth 1 -relief sunken
    text   .t
    .st setwidget .t

    .t tag configure stdout -font {Helvetica 8}
    .t tag configure stderr -background red    -font {Helvetica 12}
    .t tag configure ok     -background green  -font {Helvetica 8}
    .t tag configure warn   -background yellow -font {Helvetica 12}

    grid .l  -row 0 -column 0 -sticky new
    grid .e  -row 0 -column 1 -sticky new
    grid .i  -row 0 -column 2 -sticky new
    grid .st -row 1 -column 0 -sticky swen -columnspan 2

    grid rowconfigure . 0 -weight 0
    grid rowconfigure . 1 -weight 1

    grid columnconfigure . 0 -weight 0
    grid columnconfigure . 1 -weight 1
    grid columnconfigure . 2 -weight 0

    set INSTALLPATH [info library]

    # Redirect all output into our log window, and disable uncontrolled exit.
    rename ::puts ::_puts
    rename ::log ::puts
    rename ::exit   ::_exit
    rename ::myexit ::exit

    # And start to interact with the user.
    vwait forever
    return
}
proc Install {} {
    global INSTALLPATH NOTE
    .i configure -state disabled

    set NOTE {ok DONE}
    set fail [catch {
	_install $INSTALLPATH

	puts ""
	tag  [lindex $NOTE 0]
	puts [lindex $NOTE 1]
    } e o]

    .i configure -state normal
    .i configure -command ::_exit -text Exit -bg green

    if {$fail} {
	# rethrow
	return {*}$o $e
    }
    return
}

main
