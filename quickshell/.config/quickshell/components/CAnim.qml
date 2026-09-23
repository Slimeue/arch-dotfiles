import QtQuick
import qs.config

// Colour counterpart to Anim.
//
// Recolouring reads faster than movement, so this is deliberately quicker than
// Anim and uses the effects curve rather than the spatial one. The wallpaper
// palette changing mid-session is the main thing this smooths over.
ColorAnimation {
    property var curve: Appearance.anim.curves.expressiveDefaultEffects

    duration: Appearance.anim.durations.expressiveDefaultEffects
    easing.type: Easing.BezierSpline
    easing.bezierCurve: curve
}
