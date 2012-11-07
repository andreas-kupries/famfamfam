#!/bin/sh
# -*- tcl -*- \
exec kettle -f "$0" "${1+$@}"
kettle tclapp icon_selector
kettle tcl
