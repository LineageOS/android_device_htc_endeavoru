#!/sbin/sh

# This scripts gets executed by the updater script before installing the ROM.
# We check here if the running recovery supports the new storage layout and
# abort otherwise.

# Possible cases are:
#
# /----------------------------------------------------------------------------\
# |     Layouts    |               Action                                       |
# | Recovery | ROM |                                                            |
# |-----------------------------------------------------------------------------|
# |    old   | old | Install ROM normally.                                      |
# |-----------------------------------------------------------------------------|
# |    old   | new | This scripts aborts the installation.                      |                     
# |-----------------------------------------------------------------------------|
# |          |     | Not detectable. Or can we?                                 |
# |          |     | /system is replaced with an incompatible ROM that may be   |
# |          |     | able to mount /data (our /cache) and /sdcard (/data). The  |
# |    new   | old | ROM may boot normally and pollute /data with files and     |
# |          |     | folders that apps put on the /sdcard.                      |
# |          |     | We could add the same check we have here to new ROM builds |
# |          |     | with the old layout.
# |-----------------------------------------------------------------------------|
# |    new   | new | Install ROM normally.                                      |
# \-----------------------------------------------------------------------------/

# Check if
DATAMEDIA=`getprop ro.build.endeavoru.newlayout 0`

if [ "$DATAMEDIA" != "1" ]; then
    echo "You are running a incompatible recovery. Aborting installation!" >&2
    echo "The HTC One X storage layout was changed in Lollipop." >&2
    echo "Install a newer recovery with Lollipop support." >&2
    echo "Please read and understand http://goo.gl/vvy4c7 to continue." >&2
    exit 1
fi

exit 0
