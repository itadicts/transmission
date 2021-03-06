#!/bin/sh

SERVER="127.0.0.1:9091 --auth USUARIO:CONTRASEÑA"

TORRENTLIST=`transmission-remote $SERVER --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=" "  --fields=1`

for TORRENTID in $TORRENTLIST
do
    DL_COMPLETED=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "Percent Done: 100%"`

    STATE_STOPPED=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "State: Seeding\|Stopped\|Finished\|Idle"`

    if [ "$DL_COMPLETED" ] && [ "$STATE_STOPPED" ]; then
        transmission-remote $SERVER --torrent $TORRENTID --remove
    else
        echo "Torrent #$TORRENTID no esta completo. Ignorado."
    fi
done
exit
