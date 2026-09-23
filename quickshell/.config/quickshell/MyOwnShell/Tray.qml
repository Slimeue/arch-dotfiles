pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray

// StatusNotifierItem tray. Draws nothing while no app is registered, so on a
// quiet session it costs no space.
RowLayout {
    id: root

    // The window menus anchor to. Popups are real surfaces and need one.
    required property var window

    spacing: 10

    Repeater {
        model: SystemTray.items

        Item {
            id: entry
            required property SystemTrayItem modelData

            implicitWidth: 18
            implicitHeight: 18

            IconImage {
                anchors.fill: parent
                source: entry.modelData.icon
                // Dim until hovered, so the tray reads as secondary to the
                // workspaces and clock rather than competing with them.
                opacity: hover.hovered ? 1.0 : 0.75

                Behavior on opacity {
                    NumberAnimation { duration: Style.animDuration }
                }
            }

            HoverHandler { id: hover }

            function openMenu() {
                const p = entry.mapToItem(null, 0, entry.height);
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
                    if (entry.modelData.hasMenu) entry.openMenu();
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
