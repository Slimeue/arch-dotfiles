import QtQuick
import QtQuick.Layouts

// A rounded container. Anything declared inside lands in a centered row.
Rectangle {
    id: island

    default property alias content: row.data
    property int spacing: Style.islandSpacing
    property int padding: Style.islandPadding

    implicitWidth: row.implicitWidth + island.padding * 2
    implicitHeight: Style.islandHeight

    // # TODO: need to change where when its not single island we they need to have separate styling.
    // radius: Style.islandRadius
    bottomLeftRadius: Style.islandRadius
    bottomRightRadius: Style.islandRadius
    color: Style.islandBg
    // border.width: 1
    // border.color: Theme.outlineVar
    visible: row.implicitWidth > 0   // collapse when there is nothing to show

    Behavior on color {
        ColorAnimation {
            duration: Style.animDuration
        }
    }

    // The row fills the island rather than sitting centred inside it, so
    // pointer handlers an island declares cover its padding too — otherwise
    // clicking just inside the rounded edge would miss.
    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: island.padding
        anchors.rightMargin: island.padding
        spacing: island.spacing
    }
}
