#!./bin/python3
# Prints current window focus.
# See: https://apple.stackexchange.com/q/123730

#Setup
#/usr/bin/python3 -m venv ~/python-env
#cd ~/python-env
#source bin/activate
#pip install pyobjc

#Run
# cd ~/python-env
# get_active_focus.py

from AppKit import NSWorkspace
import time
workspace = NSWorkspace.sharedWorkspace()
active_app = workspace.activeApplication()['NSApplicationName']
print('Active focus: ' + active_app)
while True:
    time.sleep(1)
    prev_app = active_app
    active_app = workspace.activeApplication()['NSApplicationName']
    if prev_app != active_app:
        print('Focus changed to: ' + active_app)

