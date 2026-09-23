pragma Singleton

import QtQuick
import Quickshell

// One clock for the entire shell, regardless of how many monitors are
// attached. Islands bind to these strings rather than each ticking.
Singleton {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property string time: Qt.formatDateTime(clock.date, "hh:mm AP")
    readonly property string date: Qt.formatDateTime(clock.date, "ddd d")

    // The expanded form, matching waybar's clock `format-alt`.
    readonly property string long: Qt.formatDateTime(clock.date, "ddd, dd MMM  HH:mm")
}
