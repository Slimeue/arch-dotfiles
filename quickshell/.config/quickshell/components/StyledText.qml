import QtQuick
import qs.config
import qs.services

// Text with the shell's font and foreground already applied.
//
// The point is subtractive: widgets stop restating family, size and colour on
// every label, so the three lines that remain are the ones that say something.
Text {
    color: Colours.onSurface
    font.family: Appearance.font.family
    font.pixelSize: Appearance.font.size.normal

    Behavior on color {
        CAnim {}
    }
}
