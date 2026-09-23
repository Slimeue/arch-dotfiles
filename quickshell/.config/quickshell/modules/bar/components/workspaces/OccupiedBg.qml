pragma ComponentBehavior: Bound

import QtQuick
import qs.components
import qs.config
import qs.services

// The soft backdrop behind workspaces that have windows.
//
// Adjacent occupied workspaces merge into one capsule rather than showing as
// separate blobs: each rect rounds only the ends of its run and grows by the
// column spacing wherever its neighbour is also occupied, closing the gap.
// That merging is the only reason this is a component and not two lines in
// Workspaces.qml.
Item {
    id: root

    required property var wsIds
    required property int cellSize
    required property int wsSpacing

    Repeater {
        model: root.wsIds

        StyledRect {
            id: cell

            required property var modelData
            required property int index

            readonly property bool occupied: Hypr.isOccupied(modelData)
            readonly property bool prevOccupied: cell.index > 0 && Hypr.isOccupied(root.wsIds[cell.index - 1])
            readonly property bool nextOccupied: cell.index < root.wsIds.length - 1 && Hypr.isOccupied(root.wsIds[cell.index + 1])

            // Square off the edge facing an occupied neighbour and stretch into
            // the gap, so the two rects read as one continuous shape.
            property real topRadius: cell.prevOccupied ? 0 : width / 2
            property real bottomRadius: cell.nextOccupied ? 0 : width / 2
            readonly property real topGrow: cell.prevOccupied ? root.wsSpacing : 0
            readonly property real bottomGrow: cell.nextOccupied ? root.wsSpacing : 0

            anchors.left: parent.left
            anchors.right: parent.right

            y: cell.index * (root.cellSize + root.wsSpacing) - cell.topGrow
            implicitHeight: root.cellSize + cell.topGrow + cell.bottomGrow

            color: Colours.surfaceHighest
            opacity: cell.occupied ? 1 : 0

            topLeftRadius: cell.topRadius
            topRightRadius: cell.topRadius
            bottomLeftRadius: cell.bottomRadius
            bottomRightRadius: cell.bottomRadius

            Behavior on opacity {
                Anim {
                    duration: Appearance.anim.durations.expressiveDefaultEffects
                    curve: Appearance.anim.curves.expressiveDefaultEffects
                }
            }

            // Radii and growth animate so a run joining or splitting looks like
            // the capsule reshaping, not like rects popping.
            Behavior on topRadius {
                Anim {
                    duration: Appearance.anim.durations.expressiveDefaultEffects
                }
            }

            Behavior on bottomRadius {
                Anim {
                    duration: Appearance.anim.durations.expressiveDefaultEffects
                }
            }
        }
    }
}
