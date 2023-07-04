#!/bin/bash
# run.sh for Chrysalis-Firmware-Bundle
#
# Copyright (c) 2022 Christopher White (https://github.com/cxw42).
# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and
# this notice are preserved. This file is offered as-is, without any warranty.
# SPDX-License-Identifier: FSFAP
#
# Details at <https://devwrench.wordpress.com/2022/10/21/keyboardio-model100-custom-firmware-notes/>

set -euo pipefail

# === Globals ===============================================================

gHere="$(cd "$(dirname "$0")" ; pwd)"
gVerbose=

g_ToShift=0

# === Command-line options and parsing ======================================

# Parse the command line.  This happens before main() is called.
parse_command_line() {
    local OPTIND
    local option
    while getopts "v-:" option "$@" ; do
        case "$option" in
            # TODO add your short options

            v)  ((++gVerbose)) ;;

            -)
                case "$OPTARG" in
                    # TODO add your long options

                    verbose)    ((++gVerbose)) ;;
                    *)          print_usage "Unknown option --$OPTARG" ;;
                esac
                ;;

            *)  print_usage "Unknown option" ;;
        esac
    done

    g_ToShift="$(( OPTIND - 1 ))"
} # parse_command_line()

# === main ==================================================================

main() {
    local -r cmd="${1:-make}"
    local -a opts

    case "$cmd" in
        setup)  RUN make setup ;;
        make)   
            opts=("KALEIDOSCOPE_TEMP_PATH=$(realpath .kaleidoscope-temp)")
            if (( gVerbose > 1 )); then 
                opts+=('VERBOSE=1')
            fi
            RUN make Keyboardio/Model100 "${opts[@]}"
            ;;
        flash)  RUN dfu-util --device 0x3496:0005 -R -D ./output/Keyboardio/Model100/default.bin ;;
        *) die "Unknown command [$cmd]" ;;
    esac

    return 0
}

# === Utilities =============================================================

# Run a program, printing the command line first if verbose.
RUN() {
    if (( gVerbose )); then
        printf '%s ' "$@" 1>&2
        echo 1>&2
    fi

    "$@"
    return "$?"
}

# die ['2'] <message>... - print <message> to stderr, then exit.
# The exit code is 1 unless $1 = '2', in which case the exit code is 2.
die() {
    local exitval=1
    if [[ "${1:-}" = '2' ]]; then
        exitval=2
        shift
    fi

    printf '%s ' "Error:" "$@" \
        "(at ${BASH_SOURCE[0]}:${BASH_LINENO[0]})" 1>&2
    echo 1>&2
    exit "$exitval"
} # die()

# === Do it, Rockapella! ====================================================
parse_command_line "$@"
shift "$g_ToShift"

main "$@"
exit "$?"

# vi: set ts=4 sts=4 sw=4 et ai: #
