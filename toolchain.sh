#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog; -*-
#
#  Copyright (C) 2010 Tadashi G. Takaoka
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

. $(dirname $0)/main.subr

PATH=$prefix/bin:$PATH

modules="nesc tinyos-tools stow"

if [[ $# -eq 0 ]]; then
    for cmd in download build install; do
        for module in $modules; do
            $scriptdir/$module.sh $cmd
        done
    done
elif [[ $1 == "cleanup" ]]; then
    for module in $modules; do
        $scriptdir/$module.sh cleanup
    done
fi

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4: