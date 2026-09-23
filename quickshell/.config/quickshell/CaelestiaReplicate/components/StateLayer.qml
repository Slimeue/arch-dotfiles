import QtQuick
import qs.config
import qs.services

// Material 3 state layer: the translucent tint a control shows on hover and
// press, plus the click handling that goes with it.
//
// Fills its parent by default, so a control becomes interactive by declaring
// one inside it. Anything needing a hit area larger than its visible content
// clears `anchors.fill` and sizes this explicitly.
Rectangle {
    id: root

    signal clicked

    property color tint: Colours.onSurface
    // M3's own numbers: 8% on hover, 12% held down.
    property real hoverOpacity: 0.08
    property real pressOpacity: 0.12

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.containsPress

    anchors.fill: parent
    radius: Appearance.rounding.full

    color: root.tint
    opacity: root.pressed ? root.pressOpacity : root.hovered ? root.hoverOpacity : 0

    Behavior on opacity {
        NumberAnimation {
            duration: Appearance.anim.durations.expressiveFastEffects
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: root.clicked()
    }
}
