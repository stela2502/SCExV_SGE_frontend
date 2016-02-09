#!/bin/sh
#
# The NGS_SGE backend script.
#
# Copyright (C) 20015 Dr. Stefan Lang
#
# This file is part of the NGS_SGE web server. This file is free software;
# you can redistribute it and/or modify it under the terms of the GNU
# General Public License (GPL) as published by the Free Software
# Foundation, in version 2 as it comes in the "COPYING" file of the
# VirtualBox OSE distribution. VirtualBox OSE is distributed in the
# hope that it will be useful, but WITHOUT ANY WARRANTY of any kind.
#

# chkconfig: 35 35 01
# description: NGS_SGE backend script
#
### BEGIN INIT INFO
# Provides:       ngs_sge
# Required-Start: rocks-tracker
# Required-Stop:  rocks-tracker
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Description:    NGS_SGE backend script
### END INIT INFO

PATH=$PATH:/usr/local/bin
CONFIG='###OPTIONS_NGS_SGE###'
EXEC=ngs_pipeline_backend.pl
PIDFILE="/var/run/ngs_sge-service"

start() {
	if ! test -f $PIDFILE; then
		echo "Starting NGS_SGE backend"
		/usr/local/bin/$EXEC $CONFIG -pid_file $PIDFILE -log_file /var/log/ngs_sge_backend.log
	fi
}
stop() {
	if test -f $PIDFILE; then
		echo "Stopping NGS_SGE backend"
		PIDservice=$(<$PIDFILE)
		killall $EXEC
		if ! pidof $EXEC > /dev/null 2>&1; then
            rm -f $PIDFILE
            echo "Success"
        else
            echo "failed"
        fi
	fi
    return $RETVAL
}

restart() {
    stop && start
}

status() {
    echo -n "Checking for NGS_SGE backend"
    if [ -f $PIDFILE ]; then
        echo " ...running"
    else
        echo " ...not running"
    fi
}
case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    restart
    ;;
force-reload)
    restart
    ;;
status)
    status
    ;;
setup)
    ;;
cleanup)
    ;;
*)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
esac

exit $RETVAL


		