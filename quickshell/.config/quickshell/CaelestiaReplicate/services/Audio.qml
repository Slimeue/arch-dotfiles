pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Default output sink, as a volume number and a mute flag.
//
// PipeWire hands out node objects that are inert until something binds them --
// read `audio.volume` off an unbound node and you get a stale zero forever.
// PwObjectTracker below is that binding, and it is the entire reason this
// service exists rather than widgets touching Pipewire directly.
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: root.sink?.audio?.volume ?? 0
    readonly property bool muted: root.sink?.audio?.muted ?? false

    readonly property int percent: Math.round(root.volume * 100)

    PwObjectTracker {
        objects: [root.sink]
    }

    function setVolume(v: real): void {
        if (root.sink?.audio)
            root.sink.audio.volume = Math.max(0, Math.min(1, v));
    }

    function incrementVolume(step: real): void {
        root.setVolume(root.volume + (step || 0.05));
    }

    function decrementVolume(step: real): void {
        root.setVolume(root.volume - (step || 0.05));
    }

    function toggleMute(): void {
        if (root.sink?.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }
}
