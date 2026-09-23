import QtQuick
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.utils

// Power button, pinned to the bottom of the bar.
//
// Error-coloured because it is the one control here that ends your session --
// M3 reserves that role for exactly this kind of destructive action, and it
// makes the button findable without a label.
//
// Caelestia opens its own session menu. This runs hyprlock, matching what
// SUPER+L already does, and leaves building a session module for later.
Item {
    id: root

    implicitWidth: Config.bar.innerWidth
    implicitHeight: Config.bar.innerWidth

    StateLayer {
        tint: Colours.error
        onClicked: Quickshell.execDetached(["hyprlock"])
    }

    Icon {
        anchors.centerIn: parent

        text: Icons.power
        size: Appearance.font.size.larger
        color: Colours.error
    }
}
