pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

// The battery, or the absence of one.
//
// UPower always offers a display device even on a desktop, so `isPresent` --
// not the existence of the object -- is what decides whether the bar draws a
// battery icon at all. On a desktop the whole widget collapses to nothing.
Singleton {
    id: root

    readonly property UPowerDevice device: UPower.displayDevice

    readonly property bool available: (root.device?.isPresent ?? false) && (root.device?.isLaptopBattery ?? false)
    readonly property int percent: Math.round(root.device?.percentage ?? 0)
    readonly property bool charging: root.device?.state === UPowerDeviceState.Charging || root.device?.state === UPowerDeviceState.PendingCharge
    readonly property bool full: root.device?.state === UPowerDeviceState.FullyCharged

    // Below this the icon turns error-coloured. Matches the point most laptops
    // start warning.
    readonly property bool low: root.available && !root.charging && root.percent <= 20

    // Seconds until empty or full, whichever applies; 0 when UPower cannot say.
    readonly property int secondsRemaining: root.charging ? (root.device?.timeToFull ?? 0) : (root.device?.timeToEmpty ?? 0)
}
