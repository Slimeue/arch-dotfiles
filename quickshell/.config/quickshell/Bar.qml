pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

// One transparent panel per screen, owning the exclusive zone.
//
// The widgets inside -- Workspaces, MediaControls, WindowTitle, Tray, Clock --
// are plain content: none of them knows what it is sitting in. This file is
// the only place that decides chrome, so flipping Style.singleBar swaps
// separate pills for one continuous bar without touching a widget.
Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Style.barHeight
            color: "transparent"

            Loader {
                anchors.fill: parent
                sourceComponent: Style.singleBar ? singleLayout : islandLayout
            }

            // ---------------------------------------------------------------
            // Separate pills, grouped left / centre / right.
            // ---------------------------------------------------------------
            Component {
                id: islandLayout

                Item {
                    anchors.fill: parent

                    RowLayout {
                        id: leftGroup
                        spacing: Style.groupSpacing
                        anchors {
                            left: parent.left
                            leftMargin: Style.screenMargin
                            verticalCenter: parent.verticalCenter
                        }

                        Island {
                            padding: 4   // pills carry their own padding
                            Workspaces {
                                screen: bar.modelData
                            }
                        }

                        Island {
                            MediaControls {}
                        }
                    }

                    Island {
                        anchors.centerIn: parent

                        WindowTitle {
                            // Holds a constant width so the bar never reflows,
                            // but still yields if the side groups crowd it.
                            //
                            // Measured against `bar`, never `parent` -- the
                            // parent chain runs back into the enclosing Island,
                            // whose own width is derived from this value.
                            contentWidth: Math.min(Style.activeWindowWidth, Math.max(0, bar.width / 2 - Math.max(leftGroup.width, rightGroup.width) - Style.screenMargin * 2) * 2)
                        }
                    }

                    RowLayout {
                        id: rightGroup
                        spacing: Style.groupSpacing
                        anchors {
                            right: parent.right
                            rightMargin: Style.screenMargin
                            verticalCenter: parent.verticalCenter
                        }

                        Island {
                            padding: 8
                            Tray {
                                window: bar
                            }
                        }

                        Island {
                            Clock {}
                        }
                    }
                }
            }

            // ---------------------------------------------------------------
            // One continuous bar holding the same widgets.
            // ---------------------------------------------------------------
            Component {
                id: singleLayout

                Island {
                    anchors.fill: parent
                    // anchors.leftMargin: Style.screenMargin
                    // anchors.rightMargin: Style.screenMargin
                    // anchors.topMargin: (Style.barHeight - Style.islandHeight) / 2
                    anchors.bottomMargin: (Style.barHeight - Style.islandHeight) / 2

                    spacing: Style.islandSpacing * 2

                    Workspaces {
                        screen: bar.modelData
                    }
                    MediaControls {}

                    // Spacers either side keep the title centred in the bar
                    // rather than centred in whatever space is left.
                    Item {
                        Layout.fillWidth: true
                    }
                    WindowTitle {}
                    Item {
                        Layout.fillWidth: true
                    }

                    Tray {
                        window: bar
                    }
                    Clock {}
                }
            }
        }
    }
}
