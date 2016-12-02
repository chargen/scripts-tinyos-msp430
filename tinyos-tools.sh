#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog; -*-
#
# Copyright (c) 2016, Tadashi G Takaoka
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
# - Neither the name of Tadashi G. Takaoka nor the names of its
#   contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#

source $(dirname $0)/main.subr

function download() {
    return 0
}

function prepare() {
    [[ $tinyos_tools == system ]] && return 0
    [[ $(which autoheader) =~ autoheader ]] \
        || die "autoconf is not installed"
    [[ $(which automake) =~ automake ]] \
        || die "automake is not installed"
    if [[ $tinyos_main == current ]]; then
        copy $prefix/sources/tinyos-$tinyos_main $builddir
    else
        local tag=release_tinyos_${tinyos_main//./_}
        copy tinyos-$tinyos_main.tar.gz $builddir
    fi
    for p in $scriptsdir/tinyos-${tinyos_main}_*.patch; do
        do_patch $builddir $p -p1
    done
    if is_osx; then
        for p in $scriptsdir/tinyos-${tinyos_main}-osx_*.patch; do
            do_patch $builddir $p -p1
        done
    fi
    return 0
}

function build() {
    [[ $tinyos_tools == system ]] && return 0
    do_cd $builddir/tools
    do_cmd ./Bootstrap \
        || die "bootstrap failed"
    do_cmd ./configure --prefix=$prefix --disable-nls \
        || die "configure failed"
    do_cmd make -j$(num_cpus) \
        || die "make failed"
}

function install() { 
    [[ $tinyos_tools == system ]] && return 0
    do_cd $builddir/tools
    do_cmd sudo make -j$(num_cpus) install
    do_cd $buildtop
}

function cleanup() {
    [[ $tinyos_tools == system ]] && return 0
    do_cmd rm -rf $builddir
}

main "$@"

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4:
