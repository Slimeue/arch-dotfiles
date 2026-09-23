import QtQuick
import qs.components
import qs.config
import qs.services

// The pill that marks the focused workspace.
//
// The trick worth copying from caelestia: the top edge and the bottom edge are
// animated *separately*, with different durations depending on travel
// direction. The leading edge arrives first and the trailing edge lags, so the
// pill stretches as it moves and snaps back once it lands. Animating y and
// height together would just slide a rigid box.
StyledRect {
    id: root

    // The Workspace cell to sit on. Null when the focused workspace is not in
    // the visible group -- the indicator then holds its last position rather
    // than collapsing to the top.
    property Item activeWs

    // Top and bottom of the pill in the column's coordinates. These are what
    // the two animations drive; y and height are derived from them.
    property real start
    property real end

    function runAnim(): void {
        if (!activeWs)
            return;

        const newStart = activeWs.y;
        const newEnd = newStart + activeWs.height;
        const goingUp = newStart < start;

        const lead = Appearance.anim.durations.expressiveDefaultSpatial;
        const trail = lead * (Config.bar.workspaces.activeTrail ? 1.5 : 1);

        startAnim.stop();
        endAnim.stop();

        startAnim.to = newStart;
        endAnim.to = newEnd;

        // Moving up, the top edge leads and the bottom trails; moving down,
        // the reverse. That asymmetry is the whole effect.
        startAnim.duration = goingUp ? lead : trail;
        endAnim.duration = goingUp ? trail : lead;

        startAnim.start();
        endAnim.start();
    }

    onActiveWsChanged: root.runAnim()
    Component.onCompleted: root.runAnim()

    y: root.start
    implicitHeight: Math.max(0, root.end - root.start)

    color: Colours.primary
    radius: Appearance.rounding.full

    Anim on start {
        id: startAnim

        curve: Appearance.anim.curves.expressiveDefaultSpatial
    }

    Anim on end {
        id: endAnim

        curve: Appearance.anim.curves.expressiveDefaultSpatial
    }

    // The cell can move without being replaced -- the column reflows when the
    // workspace list changes length -- so follow its position too, not just
    // which cell is active.
    Connections {
        target: root.activeWs ?? null

        function onYChanged(): void {
            root.runAnim();
        }
    }
}
