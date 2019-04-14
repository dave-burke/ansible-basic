# Touchpad Toggle Role

On Suz's laptop, she wants the touchpad to be enabled if and only if a mouse is not plugged in. This role adds a udev rule to detect when a mouse is added or removed and triggers a script to enable or disable the touchpad accordingly. The script is hard coded to use the dconf key for managing the touchpad in Mate. It would need to be modified to work in other desktop environments.
