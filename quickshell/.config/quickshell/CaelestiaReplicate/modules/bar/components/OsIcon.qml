import QtQuick
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.utils

// Distro mark at the top of the bar.
//
// In caelestia this opens the launcher. There is no launcher in this shell yet,
// so it runs wofi -- which is already bound to SUPER+D in hyprland.lua. When a
// launcher module lands here, this is the one line that changes.
Item {
    id: root

    implicitWidth: Config.bar.innerWidth
    implicitHeight: Config.bar.innerWidth

    StateLayer {
        tint: Colours.primary
        onClicked: Quickshell.execDetached(["wofi", "--show", "drun"])
    }

    Icon {
        anchors.centerIn: parent

        text: Icons.logo
        size: Appearance.font.size.large
        color: Colours.tertiary
    }
}
