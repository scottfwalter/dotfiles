#!/bin/bash
echo "Kill and restart wacom drivers"
sudo killall WacomTouchDriver WacomTabletDriver "Wacom Desktop Center" com.wacom.UpdateHelper. com.wacom.DisplayMgr com.wacom.DataStoreMgr
open -a /Library/Application\ Support/Tablet/WacomTabletDriver.app
