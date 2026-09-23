//@ pragma UseQApplication

//c ~/.config/quickshell/shell.qml
// Default Quickshell config — run with `qs`. Saving this file hot-reloads it.
//
// UseQApplication above is required by the system tray: DBusMenu popups go
// through Qt's platform menu layer, which only exists under QApplication.
// Without it every tray menu fails silently. Changing it needs a full
// restart -- a hot reload will not switch application classes.
import Quickshell

Scope {
    Bar {}
}
