#!/bin/bash

# Purpose: Debian / Ubuntu support
# Author : Kevin J. Goldman
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/gkjgh/pacapt/

# Copyright (C) 2010 - 2017 Anh K. Huynh
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_format_output()
{
    # auto option is invalid
    _CO=
    if [[ -t 1 ]]; then
        _CO=$(echo always)
    else
        _CO=$(echo never)
    fi
    egrep --color=${_CO} '[A-Z].+:(\s|$)|$' "${@}" | sed '/^$/d'
#    egrep --color=auto '[A-Z].+:(\s|$)|$' "${@}" | sed '/^$/d'
}

_apt-cache_rdepends()
{
    apt-cache rdepends --no-recommends --no-suggests \
        --no-conflicts --no-breaks --no-replaces --no-enhances ${@} \
        | sed '2s/ / (Pre-)/' | sed '1d' | sed '2,$s/$/,/' \
        | sed '$s/,//' | xargs | _format_output
    apt-cache rdepends --no-pre-depends --no-depends --no-suggests \
        --no-conflicts --no-breaks --no-replaces --no-enhances ${@} \
        | sed '2s/Depends/Recommends/' | sed '1d' | sed '2,$s/$/,/' \
        | sed '$s/,//' | xargs | _format_output
}

_dpkg_init() {
  export GREP_COLOR='1;37'
}

dpkg_Q()
{
    dpkg-query -l "${@}" | grep '^[ihr]'
}

dpkg_Qs()
{
    dpkg-query -l "*${@}*" | sed '/^[up]/d'
}

dpkg_Qi()
{
    _mark=$([[ $(apt-mark showauto "${@}") == "${@}" ]] && echo auto || echo manual )
    dpkg-query -s "${@}" | sed '/^Installed/a\Installed-Reason: '${_mark} \
        | sed -r '/^Maintainer|^Architecture/d' | _format_output
    _apt-cache_rdepends "--installed ${@}"
}

dpkg_Ql()
{
    if [[ -n "${@}" ]]; then
        dpkg-query -L "${@}"
        return
    fi

    dpkg-query -l | grep '^[ihr]' | awk '{print $2}' | while read _pkg; do
        dpkg-query -L "${_pkg}" | while read _line; do
        echo "${_pkg} ${_line}"
        done
    done
}

dpkg_Qo()
{
    dpkg-query -S "${@}"
}

dpkg_Qu()
{
    apt update
    apt list --upgradable --all-versions
}

dpkg_U()
{
    dpkg -i "${@}"
}

dpkg_S()
{
    apt-get install --reinstall "${@}"
}

dpkg_Sy()
{
    apt-get update
}

dpkg_Su()
{
    apt-get upgrade
}

dpkg_Syu()
{
    apt-get update && apt-get upgrade
}

dpkg_Sw()
{
    apt-get download "${@}"
}

dpkg_Ss()
{
    apt-cache -n search "${@}" | while read _ori_txt; do
        _name=$(echo ${_ori_txt} | awk '{print $1}')
        _ver=$(apt-cache policy ${_name} \
            | sed -rn '/Installed:\s[0-9]+/p' | xargs)
        [[ -z ${_ver} ]] && echo ${_ori_txt} || \
            echo ${_ori_txt} | awk '{printf $1 "'" (${_ver}) "'"; \
            for (i=2; i<=NF; i++) {printf "%s ", $i}; printf "\n"}' \
            | _format_output
    done
}

dpkg_Si()
{
    apt-cache show "${@}" | sed -r \
        '/^Maintainer|^Architecture|^Description-md5|^MD5sum|^SHA/d' \
        | _format_output
}

dpkg_Sii()
{
    dpkg_Si "${@}"
    _apt-cache_rdepends "${@}"
}

dpkg_Sc()
{
    apt-get autoclean
}

dpkg_Scc()
{
    apt-get autoclean && apt-get clean
}

dpkg_R()
{
    apt-get remove "${@}"
}

dpkg_Rs()
{
    apt-get remove "${@}" && apt-get autoremove
}

dpkg_Rn()
{
    apt-get purge "${@}"
}

dpkg_Rns()
{
    apt-get purge "${@}" && apt-get autoremove && \
        dpkg -P $(dpkg-query -l | awk '/^rc/ {print $2}')
}
