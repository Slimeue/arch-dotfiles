pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.components
import qs.config
import qs.services

// The workspace switcher: a rounded pill holding a column of shapes, one per
// workspace, with a sliding indicator behind the focused one.
//
// Three layers, back to front:
//
//   1. OccupiedBg     merged backdrop joining runs of workspaces with windows
//   2. ActiveIndicator the primary-coloured pill that slides to the focused one
//   3. the shapes      circles, squares and the focused one, drawn on top
//
// Caelestia draws the indicator *over* the shapes and recolours what is beneath
// it with a C++ image effect. With no plugin to lean on, the order is inverted
// instead: the indicator sits underneath, and the focused shape simply asks for
// the on-primary colour. Same result, no shader.
StyledRect {
    id: root

    required property ShellScreen screen

    readonly property var monitor: Hypr.monitorFor(root.screen)
    readonly property var wsIds: Hypr.workspacesFor(root.monitor)
    readonly property int activeIdx: root.wsIds.indexOf(Hypr.activeWsId)

    // One square cell per workspace. The shapes inside are scaled fractions of
    // this, so the cell stays put while the shape morphs.
    readonly property int cellSize: Config.bar.innerWidth - Appearance.padding.small

    implicitWidth: Config.bar.innerWidth
    implicitHeight: column.implicitHeight + Appearance.padding.extraSmall * 2

    color: Colours.surfaceContainer
    radius: Appearance.rounding.full

    // Height changes when the workspace list grows or shrinks, which only
    // happens in showUnoccupied: false mode -- animate it so the bar does not
    // jump as windows open and close.
    Behavior on implicitHeight {
        Anim {}
    }

    // Scrolling anywhere over the pill steps through workspaces. Bound to the
    // whole widget rather than each cell so the gaps between them work too.
    WheelHandler {
        enabled: Config.scrollActions.workspaces
        onWheel: event => {
            const ids = root.wsIds;
            const at = ids.indexOf(Hypr.activeWsId);
            if (at === -1)
                return;
            const next = event.angleDelta.y < 0 ? at + 1 : at - 1;
            if (next >= 0 && next < ids.length)
                Hypr.focusWorkspace(ids[next]);
        }
    }

    // Layer 1. Loaded only when switched on, because it is pure decoration.
    Loader {
        anchors.fill: column
        active: Config.bar.workspaces.occupiedBg
        z: 0

        sourceComponent: OccupiedBg {
            wsIds: root.wsIds
            cellSize: root.cellSize
            wsSpacing: column.spacing
        }
    }

    // Layer 2. `activeWs` is the cell it should sit on; when the focused
    // workspace is not in the visible group the indicator simply keeps its
    // last position rather than jumping to nowhere.
    Loader {
        anchors.left: column.left
        anchors.right: column.right
        anchors.top: column.top
        active: Config.bar.workspaces.activeIndicator
        z: 1

        sourceComponent: ActiveIndicator {
            activeWs: root.activeIdx >= 0 ? repeater.itemAt(root.activeIdx) : null
        }
    }

    // Layer 3.
    Column {
        id: column

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Appearance.padding.extraSmall

        spacing: Appearance.spacing.extraSmall
        z: 2

        Repeater {
            id: repeater

            model: root.wsIds

            Workspace {
                required property var modelData

                wsId: modelData
                cellSize: root.cellSize
                focused: modelData === Hypr.activeWsId
            }
        }
    }
}
