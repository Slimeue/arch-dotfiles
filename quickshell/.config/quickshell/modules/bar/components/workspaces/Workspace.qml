import QtQuick
import qs.components
import qs.config
import qs.services

// One workspace cell.
//
// The shape inside it says everything: a small dot means empty, a larger
// rounded square means occupied, and the focused one grows again. Caelestia
// picks a random Material shape for the focused workspace each time; without
// the M3Shapes plugin this animates radius and scale instead, which reads the
// same at bar size and costs nothing.
//
// The cell never changes size -- only its contents do -- so neighbouring
// workspaces stay put while one morphs.
Item {
    id: root

    required property int wsId
    required property int cellSize
    required property bool focused

    readonly property bool occupied: Hypr.isOccupied(root.wsId)

    implicitWidth: root.cellSize
    implicitHeight: root.cellSize

    StyledRect {
        id: shape

        anchors.centerIn: parent

        // Base box is the full cell; `scale` is what actually sizes the shape,
        // because scaling animates more smoothly than width and height do and
        // keeps the thing centred for free.
        implicitWidth: root.cellSize
        implicitHeight: root.cellSize

        scale: root.focused ? 0.62 : root.occupied ? 0.34 : 0.24

        // Circle when empty, squircle when occupied, softer square when
        // focused. radius is in pre-scale pixels, hence the full cellSize.
        radius: root.focused ? root.cellSize * 0.34 : root.occupied ? root.cellSize * 0.3 : root.cellSize / 2

        // Focused sits on top of the primary-coloured indicator, so it takes
        // the on-primary foreground. Everything else reads as content or as a
        // dim placeholder.
        color: root.focused ? Colours.onPrimary : root.occupied ? Colours.onSurface : Colours.outlineVar

        // Spatial curve overshoots slightly, so the shape springs rather than
        // easing flatly into its new size. This is most of the "expressive"
        // feel of the original.
        Behavior on scale {
            Anim {
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                curve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        }

        Behavior on radius {
            Anim {
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                curve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        }
    }

    TapHandler {
        onTapped: Hypr.focusWorkspace(root.wsId)
    }
}
