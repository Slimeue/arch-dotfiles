pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

// Network state reduced to the three things a bar icon needs: are we online,
// over what, and how well.
//
// Quickshell.Networking exposes a device list; walking it in a widget would
// mean every widget re-deriving "the interesting device". That derivation
// happens once, here.
Singleton {
    id: root

    readonly property var devices: Networking.devices?.values ?? []

    // Wired wins over wireless when both are up -- if an ethernet cable is in,
    // that is the connection you are actually using.
    readonly property var wired: root.devices.find(d => d.type === DeviceType.Wired && d.connected) ?? null
    readonly property var wifi: root.devices.find(d => d.type === DeviceType.Wifi) ?? null

    readonly property bool wifiConnected: root.wifi?.connected ?? false
    readonly property bool connected: !!root.wired || root.wifiConnected

    readonly property string kind: root.wired ? "wired" : root.wifiConnected ? "wifi" : "none"

    // Name of the active connection, for a tooltip or popout.
    readonly property string ssid: {
        if (root.wired)
            return root.wired.name;
        const net = root.wifi?.networks?.values?.find(n => n.connected);
        return net?.name ?? "";
    }

    // 0..100. Wired has no meaningful strength, so it reports full.
    readonly property int strength: {
        if (root.wired)
            return 100;
        const net = root.wifi?.networks?.values?.find(n => n.connected);
        return Math.round(net?.signalStrength ?? 0);
    }
}
