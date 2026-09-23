import QtQuick
import QtQuick.Layouts

// Time and date. Clicking swaps to the long form, which is what waybar's
// `format-alt` did.
RowLayout {
    id: root

    property bool expanded: false

    spacing: Style.islandSpacing

    TapHandler {
        onTapped: root.expanded = !root.expanded
    }

    Text {
        text: root.expanded ? Time.long : Time.time
        color: Style.accent
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
        font.bold: true
    }

    Text {
        text: "·"
        color: Style.fgDim
        font.pixelSize: Style.fontSize
        visible: !root.expanded
    }

    Text {
        text: Time.date
        color: Style.fgDim
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
        visible: !root.expanded
    }
}
