pragma Singleton

import QtQuick
import Quickshell
import qs.config

// One clock for the entire shell, however many monitors are attached. Widgets
// bind to these strings rather than each ticking a timer of their own.
//
// The bar's clock is vertical, so hours and minutes are exposed as separate
// strings -- a single "hh:mm" would have to be split at the point of use, in
// every place that uses it.
Singleton {
    id: root

    // Seconds precision even when the clock does not show seconds: the minute
    // rolls over on the second, rather than up to 59s late.
    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    readonly property date date: clock.date

    readonly property string hourStr: root.format(Config.bar.clock.twelveHour ? "hh" : "HH")
    readonly property string minuteStr: root.format("mm")
    readonly property string secondStr: root.format("ss")
    readonly property string amPmStr: root.format("AP").toLowerCase()

    // Day name and day number, stacked above the time in the bar.
    readonly property string dayName: root.format("ddd")
    readonly property string dayNum: root.format("d")

    // Horizontal forms, for tooltips and anything that is not the bar.
    readonly property string time: root.format(Config.bar.clock.twelveHour ? "hh:mm AP" : "HH:mm")
    readonly property string longDate: root.format("dddd, d MMMM")

    function format(fmt: string): string {
        return Qt.formatDateTime(clock.date, fmt);
    }
}
