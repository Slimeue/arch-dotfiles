pragma Singleton

import QtQuick
import Quickshell

// Every glyph the shell draws, in one table.
//
// Caelestia uses Google's Material Symbols font and writes icons as words
// ("power_settings_new"). That font is not installed here, so these are the
// Material Design glyphs bundled inside JetBrainsMono Nerd Font -- the same
// icon set, reached by codepoint instead of by name.
//
// TRAP, and the reason this file exists at all: `\uXXXX` in JavaScript consumes
// exactly FOUR hex digits. Nerd Fonts' Material Design block lives above U+FFFF
// at five digits, so "0" does not mean U+F0200 -- it means U+F020
// followed by the literal character "0". That renders a plausible-looking wrong
// icon rather than an error, which is the worst way for a bug to behave.
//
// Always use the braced form, "\u{f0200}", for anything past four digits.
//
// Keeping the table here means switching to Material Symbols later is one file:
// replace the values with their word names and change Appearance.font.family.
// Nothing else in the shell refers to a codepoint.
Singleton {
    id: root

    readonly property string logo: ""              // Arch, 4 digits
    readonly property string power: "\u{f0425}"
    readonly property string calendar: "\u{f0e17}"
    readonly property string window: "\u{f0614}"
    readonly property string desktop: "\u{f0379}"
    readonly property string capsLock: "\u{f0632}"
    readonly property string ethernet: "\u{f0200}"

    readonly property string mediaPrev: "\u{f04ae}"
    readonly property string mediaNext: "\u{f04ad}"
    readonly property string mediaPlay: "\u{f040a}"
    readonly property string mediaPause: "\u{f03e4}"

    // Wi-Fi arcs, none through four bars. Index by signal strength.
    readonly property var wifiBars: ["\u{f092b}", "\u{f091f}", "\u{f0922}", "\u{f0925}", "\u{f0928}"]
    readonly property string wifiOff: "\u{f092d}"

    // Speaker: muted, then low through high.
    readonly property string volumeMuted: "\u{f0581}"
    readonly property var volumeLevels: ["\u{f075f}", "\u{f057f}", "\u{f0580}", "\u{f057e}"]

    readonly property string batteryCharging: "\u{f0084}"
    readonly property string batteryAlert: "\u{f0083}"
    // Eleven steps, empty to full: index = round(percent / 10). These are the
    // upright battery glyphs, which suit a vertical bar better than the
    // sideways Font Awesome ones.
    readonly property var batteryLevels: ["\u{f008e}", "\u{f007a}", "\u{f007b}", "\u{f007c}", "\u{f007d}", "\u{f007e}", "\u{f007f}", "\u{f0080}", "\u{f0081}", "\u{f0082}", "\u{f0079}"]

    function wifi(strength: int): string {
        // 0 means connected with no measurable signal, which still deserves the
        // empty-arcs glyph rather than the crossed-out one -- that means "off".
        const i = Math.max(0, Math.min(4, Math.round((strength / 100) * 4)));
        return root.wifiBars[i];
    }

    function volume(percent: int, muted: bool): string {
        if (muted || percent <= 0)
            return root.volumeMuted;
        const i = Math.max(0, Math.min(3, Math.ceil((percent / 100) * 3)));
        return root.volumeLevels[i];
    }

    function battery(percent: int, charging: bool): string {
        if (charging)
            return root.batteryCharging;
        const i = Math.max(0, Math.min(10, Math.round(percent / 10)));
        return root.batteryLevels[i];
    }
}
