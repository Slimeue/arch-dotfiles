pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config

// A thin, opinionated face over Quickshell.Hyprland.
//
// Why wrap it at all: widgets should ask "which workspaces belong to this
// monitor" and not care that the answer is a filter over a flat model that
// Hyprland populates lazily. Every awkward detail of that lives here, once.
Singleton {
    id: root

    readonly property var workspaces: Hyprland.workspaces.values
    readonly property var activeToplevel: Hyprland.activeToplevel
    readonly property int activeWsId: Hyprland.focusedWorkspace?.id ?? 1

    // Hyprland populates these models lazily, so a bar that starts before the
    // first IPC event would otherwise sit empty until you switched workspace.
    Component.onCompleted: root.refresh()

    function refresh(): void {
        Hyprland.refreshMonitors();
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }

    function monitorFor(screen: ShellScreen): var {
        return Hyprland.monitorFor(screen);
    }

    // Workspaces this bar should draw, already sorted.
    //
    // Two modes, matching caelestia's: a fixed group of N that pages as you
    // move past it (showUnoccupied), or only the workspaces that actually have
    // windows plus whichever one is focused.
    function workspacesFor(monitor: var): var {
        const shown = Math.max(1, Config.bar.workspaces.shown);

        if (Config.bar.workspaces.showUnoccupied) {
            // Which group of `shown` the active workspace falls into: with
            // shown = 5, workspace 7 puts you in the 6..10 group.
            const offset = Math.floor((root.activeWsId - 1) / shown) * shown;
            return Array.from({
                length: shown
            }, (_, i) => offset + i + 1);
        }

        const perMonitor = Config.bar.workspaces.perMonitor;
        const occupied = root.workspaces.filter(w => w.id > 0 && (!perMonitor || w.monitor === monitor) && (w.id === root.activeWsId || w.toplevels.values.length > 0)).sort((a, b) => a.id - b.id).map(w => w.id);

        // Window onto that list, anchored so the active workspace stays visible.
        const at = occupied.indexOf(root.activeWsId);
        if (at < 0)
            return occupied.slice(0, shown);
        const end = Math.min(occupied.length, Math.max(at + 1, shown));
        return occupied.slice(Math.max(0, end - shown), end);
    }

    // Workspace object for an id, or null if Hyprland has never seen it.
    // Unoccupied workspaces in a fixed group are exactly this case.
    function wsById(id: int): var {
        return root.workspaces.find(w => w.id === id) ?? null;
    }

    function isOccupied(id: int): bool {
        return (root.wsById(id)?.toplevels?.values?.length ?? 0) > 0;
    }

    // Windows on a workspace, for the little stack of app glyphs.
    function toplevelsFor(id: int): var {
        return root.wsById(id)?.toplevels?.values ?? [];
    }

    // Hyprland accepts either its own dispatcher syntax or Lua, depending on
    // how the compositor was configured -- and this user's hyprland.lua means
    // `usingLua` is true. Getting it wrong is a silent no-op, so ask.
    function focusWorkspace(id: int): void {
        Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus({ workspace = "${id}" })` : `workspace ${id}`);
    }
}
