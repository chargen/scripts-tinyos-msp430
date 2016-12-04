#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog; -*-
#
# Copyright (c) 2012, Tadashi G Takaoka
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
    local tinyos_src=$prefix/sources
    [[ -d $tinyos_src ]] || do_cmd sudo mkdir -p $tinyos_src
    if [[ $tinyos_main =~ system ]]; then
        :
    elif [[ $tinyos_main == current ]]; then
        local dir=$tinyos_src/tinyos-main-$tinyos_main
        clone --sudo git $tinyos_main_repo $dir
    else
        local tag=release_tinyos_${tinyos_main//./_}
        local url=$tinyos_main_url/$tag.tar.gz
        fetch $url tinyos-${tinyos_main}.tar.gz
    fi
    return 0
}

function prepare() {
    return 0
}

function build() {
    return 0
}

function install() { 
    local tinyos_src=$prefix/sources
    local dst=$prefix/root/tinyos-main
    if [[ $tinyos_main =~ system: ]]; then
        symlink --sudo ${tinyos_main#system:} $dst
    elif [[ $tinyos_main == current ]]; then
        symlink --sudo $tinyos_src/tinyos-main-$tinyos_main $dst
    else
        copy --sudo tinyos-$tinyos_main.tar.gz $tinyos_src/tinyos-$tinyos_main
        symlink --sudo $tinyos_src/tinyos-$tinyos_main $dst
    fi
}

function cleanup() {
    return 0
}

main "$@"

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4:
