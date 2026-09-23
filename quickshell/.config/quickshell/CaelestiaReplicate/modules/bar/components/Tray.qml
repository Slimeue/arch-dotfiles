pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.components
import qs.config
import qs.services

// StatusNotifierItem tray, stacked vertically.
//
// Collapses to zero height while no app has registered, so a quiet session
// costs no space in the bar. The pointer handling below is unchanged from the
// horizontal bar this replaces -- it was already right, and tray semantics do
// not depend on which way the bar runs.
ColumnLayout {
    id: root

    // Menus are real Wayland surfaces and need a window to anchor to.
    required property var window

    spacing: Appearance.spacing.small

    Repeater {
        model: SystemTray.items

        Item {
            id: entry

            required property SystemTrayItem modelData

            Layout.alignment: Qt.AlignHCenter

            implicitWidth: Appearance.font.size.large
            implicitHeight: Appearance.font.size.large

            IconImage {
                anchors.fill: parent

                source: entry.modelData.icon
                // Dim until hovered, so the tray reads as secondary to the
                // workspaces and clock rather than competing with them.
                opacity: hover.hovered ? 1 : 0.75

                Behavior on opacity {
                    Anim {
                        duration: Appearance.anim.durations.expressiveFastEffects
                    }
                }
            }

            HoverHandler {
                id: hover
            }

            function openMenu(): void {
                // Anchor to the right edge, since the bar is on the left and a
                // menu opening leftwards would run off the screen.
                const p = entry.mapToItem(null, entry.width, 0);
                entry.modelData.display(root.window, Math.round(p.x), Math.round(p.y));
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: {
                    // Ayatana/libappindicator items -- nm-applet among them --
                    // ship a menu and no Activate method at all, yet never set
                    // ItemIsMenu to say so. onlyMenu is therefore false and
                    // activate() calls into nothing. Where an item offers a
                    // menu, that menu is the action it actually expects.
                    if (entry.modelData.onlyMenu || entry.modelData.hasMenu)
                        entry.openMenu();
                    else
                        entry.modelData.activate();
                }
            }

            TapHandler {
                acceptedButtons: Qt.RightButton
                onTapped: {
                    if (entry.modelData.hasMenu)
                        entry.openMenu();
                }
            }

            TapHandler {
                acceptedButtons: Qt.MiddleButton
                onTapped: entry.modelData.secondaryActivate()
            }

            WheelHandler {
                onWheel: event => {
                    if (event.angleDelta.y !== 0)
                        entry.modelData.scroll(event.angleDelta.y, false);
                    if (event.angleDelta.x !== 0)
                        entry.modelData.scroll(event.angleDelta.x, true);
                }
            }
        }
    }
}
