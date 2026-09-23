//@ pragma UseQApplication

// The shell's entry point. Composition only -- no UI is declared here.
//
// UseQApplication is required by the system tray: DBusMenu popups go through
// Qt's platform menu layer, which only exists under QApplication. Without it
// every tray menu fails silently. Changing it needs a full restart; a hot
// reload will not switch application classes.
//
// Layout of this config, outermost first:
//
//   config/      design tokens and user options       (no dependencies)
//   services/    singletons holding live system state (depend on config)
//   utils/       pure lookup tables and helpers       (no dependencies)
//   components/  generic widgets, nothing shell-specific
//   modules/     the actual surfaces -- currently just the bar
//
// Imports only ever point down that list: a module may use a component, a
// component may use a service, and nothing reaches back the other way. Adding
// a launcher or a dashboard means a new directory under modules/ and one more
// line in here.
import Quickshell
import qs.modules.bar

ShellRoot {
    BarWindow {}
}
