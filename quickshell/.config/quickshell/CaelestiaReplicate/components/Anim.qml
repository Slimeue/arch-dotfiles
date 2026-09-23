import QtQuick
import qs.config

// The shell's default number animation.
//
// Declaring `Behavior on x { Anim {} }` everywhere -- instead of spelling out a
// duration and easing each time -- is what makes separate widgets feel like one
// moving object. Override `duration` or `curve` per use where a specific
// motion needs it; the defaults are Material 3's emphasized curve.
NumberAnimation {
    property var curve: Appearance.anim.curves.emphasized

    duration: Appearance.anim.durations.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: curve
}
