# Touchpad Toggle Role

On Suz's laptop, she wants the touchpad to be enabled if and only if a mouse is not plugged in. This role adds a udev rule to detect when a mouse is added or removed and triggers a script to enable or disable the touchpad accordingly. The script is hard coded to use the dconf key for managing the touchpad in Mate. It would need to be modified to work in other desktop environments.

Another tweak I've applied is to disable the middle-click on the touchpad. It's too easy to accidentally hit it when you want to left or right click, and that can be disasterous when e.g. middle click closes a tab in the browser.

I haven't automated it yet, but might do so at some time in the future. Until then I'm just documenting the process here.

```sh
# This lists all the devices so you can get the name and id
xinput

# This shows the current button map. Output is e.g. '1 2 3 4 5 6 7'
xinput get-button-map 'ELAN1200:00 04F3:3045 Touchpad'

# First number is the device ID from 'xinput' above. The rest of the numbers are
# the output from get-button-map, but with whatever changes we want to make.
# It takes some trial and error to figure out what each number is, but by
# changing '2' to '0' it effectively unsets the middle button.
xinput set-button-map 15 1 0 3 4 5 6 7

# You can see how you could also re-order buttons etc.
# Numbers beyond 3 are for other things like two-finger scrolling, etc.
```
