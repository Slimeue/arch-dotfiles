import QtQuick
import qs.components

// Rectangle that animates its own colour changes.
//
// Every surface in the bar is one of these, so when matugen writes a new
// palette the whole shell cross-fades to it instead of snapping. Plain
// Rectangle is still correct for anything that must not animate.
Rectangle {
    color: "transparent"

    Behavior on color {
        CAnim {}
    }
}
