pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

// Numbered pills, one per workspace on this monitor. Plain content: it draws
// itself and nothing else, so it works inside an Island, inside a single
// full-width bar, or on its own.
RowLayout {
    id: root

    required property var screen

    readonly property var monitor: Hyprland.monitorFor(root.screen)
    readonly property var workspaces: Hyprland.workspaces.values
        .filter(ws => ws.monitor === root.monitor)
        .sort((a, b) => a.id - b.id)

    spacing: 2

    // Hyprland populates these models lazily, so a bar that starts before
    // the first IPC event would otherwise show nothing until you switched
    // workspace.
    Component.onCompleted: {
        Hyprland.refreshMonitors();
        Hyprland.refreshWorkspaces();
    }

    // Scrolling anywhere over the pills walks the workspace list.
    WheelHandler {
        onWheel: event => {
            const list = root.workspaces;
            const at = list.findIndex(ws => ws.active);
            if (at === -1) return;
            const next = event.angleDelta.y < 0 ? at + 1 : at - 1;
            if (next >= 0 && next < list.length) list[next].activate();
        }
    }

    Repeater {
        model: root.workspaces

        Rectangle {
            id: pill
            required property var modelData

            implicitWidth: Math.max(label.implicitWidth + 16, 24)
            implicitHeight: 22
            radius: Style.islandRadius

            // `active` is the workspace visible on THIS monitor. `focused` is
            // global, so using it would leave the unfocused monitor's bar with
            // no highlight at all. Urgent has to beat active, so it is first.
            color: pill.modelData.urgent ? Style.urgent
                 : pill.modelData.active ? Style.accent
                 : hover.hovered ? Theme.container
                 : "transparent"

            Behavior on color {
                ColorAnimation { duration: Style.animDuration }
            }

            Text {
                id: label
                anchors.centerIn: parent
                text: pill.modelData.name
                color: pill.modelData.urgent ? Style.onUrgent
                     : pill.modelData.active ? Style.onAccent
                     : Style.fgDim
                font.family: Style.fontFamily
                font.pixelSize: Style.fontSize

                Behavior on color {
                    ColorAnimation { duration: Style.animDuration }
                }
            }

            HoverHandler { id: hover }

            TapHandler {
                onTapped: pill.modelData.activate()
            }
        }
    }
}
