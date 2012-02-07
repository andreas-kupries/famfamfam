if {![package vsatisfies [package provide Tcl] 8.5]} {
    # PRAGMA: returnok
    return
}
package ifneeded famfamfam        1 [list source [file join $dir core.tcl]]
package ifneeded famfamfam::flags 1 [list source [file join $dir flags.tcl]]
package ifneeded famfamfam::mini  1 [list source [file join $dir mini.tcl]]
package ifneeded famfamfam::mint  1 [list source [file join $dir mint.tcl]]
package ifneeded famfamfam::silk  1 [list source [file join $dir silk.tcl]]
