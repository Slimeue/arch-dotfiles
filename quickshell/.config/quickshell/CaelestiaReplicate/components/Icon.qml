import QtQuick
import qs.config
import qs.services

// A glyph from utils/Icons.qml, boxed so it behaves like an icon rather than
// like a line of text.
//
// This wraps a Text rather than being one, for two reasons: Text's implicit
// size is read-only, and icon fonts carry uneven side bearings, so glyphs of
// the same point size report different widths. Forcing the box to at least
// `size` wide and centring inside it is what keeps a vertical column of icons
// optically aligned.
Item {
    id: root

    property string text
    property int size: Appearance.font.size.large
    property color color: Colours.onSurface

    implicitWidth: Math.max(root.size, label.implicitWidth)
    implicitHeight: label.implicitHeight

    Text {
        id: label

        anchors.centerIn: parent

        text: root.text
        color: root.color
        font.family: Appearance.font.family
        font.pixelSize: root.size
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            CAnim {}
        }
    }
}
