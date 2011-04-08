#!/bin/bash
#
# battery status script
#

BATTERY=/proc/acpi/battery/C1C0

REM_CAP=`grep "^remaining capacity" $BATTERY/state | awk '{ print $3 }'`
FULL_CAP=`grep "^last full capacity" $BATTERY/info | awk '{ print $4 }'`
BATSTATE=`grep "^charging state" $BATTERY/state | awk '{ print $3 }'`

CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`


case "${BATSTATE}" in
   'charged')
   BATSTT="="
   ;;
   'charging')
   BATSTT="+"
   ;;
   'discharging')
   BATSTT="-"
   ;;
esac

# prevent a charge of more than 100% displaying
if [ "$CHARGE" -gt "99" ]
then
   CHARGE=100
fi

echo -e "${CHARGE}% ${BATSTT}"

# end of file
