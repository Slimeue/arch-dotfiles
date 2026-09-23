pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.modules.bar.components
import qs.modules.bar.components.workspaces

// The bar's contents: a single column, driven by the entry list in
// config/Config.qml.
//
// Nothing here is positioned by hand. The order of `Config.bar.entries` is the
// order on screen, and "spacer" is an expanding gap -- which is what pushes the
// clock and power button to the bottom without any anchoring.
//
// This file owns layout only. It knows nothing about windows, exclusive zones
// or screens; BarWindow handles those. That split is what lets the same column
// be dropped into a different container later.
ColumnLayout {
    id: root

    required property ShellScreen screen
    // Passed down to the tray so its menus have a surface to anchor to. It is
    // the one widget that cannot be screen-agnostic.
    required property var window

    spacing: Appearance.spacing.medium

    Repeater {
        model: Config.bar.entries.filter(e => e.enabled)

        // Every entry is wrapped so the layout can treat them uniformly:
        // centred horizontally, sized to their content, and -- for the spacer --
        // stretched. Without a wrapper each widget would have to restate its
        // own Layout attached properties.
        Item {
            id: wrapper

            required property var modelData

            readonly property string entryId: wrapper.modelData.id
            readonly property bool isSpacer: wrapper.entryId === "spacer"

            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: wrapper.isSpacer

            implicitWidth: content.item?.implicitWidth ?? 0
            implicitHeight: wrapper.isSpacer ? 0 : (content.item?.implicitHeight ?? 0)

            Loader {
                id: content

                anchors.centerIn: parent
                active: !wrapper.isSpacer

                sourceComponent: {
                    switch (wrapper.entryId) {
                    case "logo":
                        return logoEntry;
                    case "workspaces":
                        return workspacesEntry;
                    case "activeWindow":
                        return activeWindowEntry;
                    case "media":
                        return mediaEntry;
                    case "tray":
                        return trayEntry;
                    case "statusIcons":
                        return statusIconsEntry;
                    case "clock":
                        return clockEntry;
                    case "power":
                        return powerEntry;
                    default:
                        return null;
                    }
                }
            }
        }
    }

    // One Component per entry kind. Declared rather than instantiated, so an
    // entry switched off in config costs nothing at runtime.
    Component {
        id: logoEntry

        OsIcon {}
    }

    Component {
        id: workspacesEntry

        Workspaces {
            screen: root.screen
        }
    }

    Component {
        id: activeWindowEntry

        ActiveWindow {}
    }

    Component {
        id: mediaEntry

        MediaMini {}
    }

    Component {
        id: trayEntry

        Tray {
            window: root.window
        }
    }

    Component {
        id: statusIconsEntry

        StatusIcons {}
    }

    Component {
        id: clockEntry

        Clock {}
    }

    Component {
        id: powerEntry

        Power {}
    }
}
