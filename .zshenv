export QT_QPA_PLATFORM=xcb

if [[ $XDG_SESSION_TYPE -eq "wayland" ]]; then
    export MOZ_ENABLE_WAYLAND=1
else
    export MOZ_X11_EGL=1
fi
