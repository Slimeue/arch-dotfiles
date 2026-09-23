import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

// The focused window's title at a fixed width, so switching windows never
// reflows whatever contains it. A title that fits sits centred; one that
// overruns scrolls back and forth instead of being cut off.
RowLayout {
    id: root

    property int contentWidth: Style.activeWindowWidth

    readonly property var toplevel: Hyprland.activeToplevel
    readonly property string title: root.toplevel ? root.toplevel.title : ""

    spacing: 0

    Component.onCompleted: Hyprland.refreshToplevels()

    Item {
        id: viewport
        clip: true

        // Collapses to nothing when no window is focused, so a container can
        // hide itself entirely.
        Layout.preferredWidth: root.title === "" ? 0 : root.contentWidth
        Layout.preferredHeight: label.implicitHeight

        readonly property real overflow: Math.max(0, label.implicitWidth - width)

        // Driven by the animation rather than label.x directly, so that the
        // centring binding below survives -- assigning x from an animation
        // would overwrite it permanently.
        property real scrollX: 0

        Text {
            id: label
            text: root.title
            color: Style.fg
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSize
            anchors.verticalCenter: parent.verticalCenter

            // Centred while it fits; once it overruns, the scroll takes over
            // and starts flush with the left edge.
            x: viewport.overflow > 0
                ? viewport.scrollX
                : (viewport.width - label.implicitWidth) / 2
        }

        SequentialAnimation {
            id: marquee
            running: viewport.overflow > 0
            loops: Animation.Infinite

            onRunningChanged: if (!running) viewport.scrollX = 0

            PauseAnimation { duration: Style.marqueePause }
            NumberAnimation {
                target: viewport; property: "scrollX"
                from: 0; to: -viewport.overflow
                duration: (viewport.overflow / Style.marqueeSpeed) * 1000
                easing.type: Easing.Linear
            }
            PauseAnimation { duration: Style.marqueePause }
            NumberAnimation {
                target: viewport; property: "scrollX"
                from: -viewport.overflow; to: 0
                duration: (viewport.overflow / Style.marqueeSpeed) * 1000
                easing.type: Easing.Linear
            }
        }

        // A new title resets the cycle from the beginning.
        Connections {
            target: root
            function onTitleChanged() {
                viewport.scrollX = 0;
                marquee.restart();
            }
        }
    }
}
