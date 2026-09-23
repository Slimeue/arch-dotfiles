import QtQuick
import qs.components
import qs.config
import qs.services
import qs.utils

// The focused window's title, rotated to run down the bar.
//
// A vertical bar has height to spare and almost no width, so the title is
// turned 90 degrees rather than truncated to three characters. The rotation
// swaps the text's own width and height, which is why this item's implicit
// *height* is derived from the label's implicit *width*.
Item {
    id: root

    readonly property string title: {
        const t = Hypr.activeToplevel?.title;
        if (!t)
            return "Desktop";
        if (Config.bar.activeWindow.compact) {
            // "kitty — ~/src" reads better as "~/src". Splits on hyphen, en
            // dash and em dash, all surrounded by whitespace, and keeps the
            // last part -- which is the document rather than the app.
            const parts = t.split(/\s+[\-–—]\s+/);
            if (parts.length > 1)
                return parts[parts.length - 1].trim();
        }
        return t;
    }

    implicitWidth: Config.bar.innerWidth
    implicitHeight: icon.implicitHeight + Appearance.spacing.small + Math.min(label.implicitWidth, Config.bar.activeWindow.maxLength)

    clip: true

    Icon {
        id: icon

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        text: Hypr.activeToplevel ? Icons.window : Icons.desktop
        size: Appearance.font.size.normal
        color: Colours.primary
    }

    // Rotating about the top-left corner and then nudging into place is more
    // predictable than rotating about the centre, whose offset depends on the
    // text length.
    Item {
        anchors.top: icon.bottom
        anchors.topMargin: Appearance.spacing.small
        anchors.horizontalCenter: parent.horizontalCenter

        width: label.implicitHeight
        height: Math.min(label.implicitWidth, Config.bar.activeWindow.maxLength)

        StyledText {
            id: label

            // Reading top-to-bottom: rotate clockwise, then shift right by the
            // line height so the rotated text lands back inside the box.
            transform: [
                Rotation {
                    angle: 90
                },
                Translate {
                    x: label.implicitHeight
                }
            ]

            width: Math.min(label.implicitWidth, Config.bar.activeWindow.maxLength)
            text: root.title
            color: Colours.primary
            elide: Text.ElideRight
        }
    }
}
