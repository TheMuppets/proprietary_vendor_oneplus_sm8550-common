#! /vendor/bin/sh

# Copyright (c) 2009-2016, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


mtk_platform=`getprop ro.boot.hardware`
if [ -z "${mtk_platform##*mt*}" ]; then
    mtk_mipc_support=`getprop ro.vendor.mtk_mipc_support`
    if [ "$mtk_mipc_support" == "1" ]; then
        setprop persist.vendor.radio.mtk_mipc_support "1"
    fi
    setprop persist.vendor.radio.oem_urc_enable 1
else
    if [ -f /data/vendor/olog/ver_info.txt ]; then
        old_ver_info=`cat /data/vendor/olog/ver_info.txt`
    else
        old_ver_info=""
    fi
    cur_ver_info=`cat /vendor/firmware_mnt/verinfo/ver_info.txt`
    if [ ! -f /vendor/firmware_mnt/verinfo/ver_info.txt -o "$old_ver_info" != "$cur_ver_info" ]; then
        chmod u+w -R /data/vendor/olog/*
        rm -rf /data/vendor/olog/*
        cp --preserve=m -d /vendor/firmware_mnt/verinfo/ver_info.txt /data/vendor/olog/ver_info.txt
        echo -n > /data/vendor/olog/diag
        echo -n > /data/vendor/olog/diag_temp
        echo -n > /data/vendor/olog/diag_info
        echo 0 > /data/vendor/olog/enable_olog
        chmod 0666 /data/vendor/olog/diag
        chmod 0660 /data/vendor/olog/diag_temp
        chmod 0666 /data/vendor/olog/diag_info
        chmod 0660 /data/vendor/olog/enable_olog
        chown -hR root.system /data/vendor/olog/*
    fi
fi

