To fix stuttering issues with vulkan, force GL.

Add an executable ~/.local/bin/zeditor

```
#!/bin/sh
exec env VK_DRIVER_FILES=/dev/null /usr/bin/zeditor "$@"
```

Copy the .desktop file

```
cp /usr/share/applications/dev.zed.Zed.desktop ~/.local/share/applications/
```

Edit the exec

```
Exec=env VK_DRIVER_FILES=/dev/null /usr/bin/zeditor %U
```

I set the hyprland keybind to use the env var as well.
