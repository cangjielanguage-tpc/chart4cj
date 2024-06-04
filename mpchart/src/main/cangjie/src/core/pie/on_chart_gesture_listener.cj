/**
 * Created on 2024/5/11
 */
package core.pie

public interface OnChartGestureListener {

    /**
     * Callbacks when a touch-gesture has started on the chart (ACTION_DOWN)
     *
     * @param me
     * @param lastPerformedGesture
     */
    //onChartGestureStart: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, lastPerformedGesture: ChartGesture) => void

    prop onChartGestureStartTouchEvent: (Bool, TouchEvent, ChartGesture) -> Unit
    prop onChartGestureStartGestureEvent: (Bool, GestureEvent, ChartGesture) -> Unit

    /**
     * Callbacks when a touch-gesture has ended on the chart (ACTION_UP, ACTION_CANCEL)
     *
     * @param me
     * @param lastPerformedGesture
     */
    //func onChartGestureEnd: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, lastPerformedGesture: ChartGesture) => void

    prop onChartGestureEndTouchEvent: (Bool, TouchEvent, ChartGesture) -> Unit
    prop onChartGestureEndGestureEvent: (Bool, GestureEvent, ChartGesture) -> Unit
    /**
     * Callbacks when the chart is longpressed.
     *
     * @param me
     */
    //func onChartLongPressed: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => void

    prop onChartLongPressedTouchEvent: (Bool, TouchEvent) -> Unit
    prop onChartLongPressedGestureEvent: (Bool, GestureEvent) -> Unit

    /**
     * Callbacks when the chart is double-tapped.
     *
     * @param me
     */
    //func onChartDoubleTapped: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => void

    prop onChartDoubleTappedTouchEvent: (Bool, TouchEvent) -> Unit
    prop onChartDoubleTappedGestureEvent: (Bool, GestureEvent) -> Unit

    /**
     * Callbacks when the chart is single-tapped.
     *
     * @param me
     */
    //func onChartSingleTapped: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => void

    prop onChartSingleTappedTouchEvent: (Bool, TouchEvent) -> Unit
    prop onChartSingleTappedGestureEvent: (Bool, GestureEvent) -> Unit
    /**
     * Callbacks then a fling gesture is made on the chart.
     *
     * @param me1
     * @param me2
     * @param velocityX
     * @param velocityY
     */
    //func onChartFling: (isTouchEvent: boolean, me1: TouchEvent | GestureEvent, me2: TouchEvent, velocityX: number, velocityY: number) => void

    prop onChartFlingTouchEvent: (Bool, TouchEvent, TouchEvent, Float64, Float64) -> Unit
    prop onChartFlingGestureEvent: (Bool, GestureEvent, TouchEvent, Float64, Float64) -> Unit

    /**
     * Callbacks when the chart is scaled / zoomed via pinch zoom / double-tap gesture.
     *
     * @param me
     * @param scaleX scalefactor on the x-axis
     * @param scaleY scalefactor on the y-axis
     */
    //onChartScale: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, scaleX: number, scaleY: number) => void
    prop onChartScaleTouchEvent: (Bool, TouchEvent, Float64, Float64) -> Unit
    prop onChartScaleGestureEvent: (Bool, GestureEvent, Float64, Float64) -> Unit

    /**
     * Callbacks when the chart is moved / translated via drag gesture.
     *
     * @param me
     * @param dX translation distance on the x-axis
     * @param dY translation distance on the y-axis
     */
    // func onChartTranslate: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, dX: number, dY: number) => void
    prop onChartTranslateTouchEvent: (Bool, TouchEvent, Float64, Float64) -> Unit
    prop onChartTranslateGestureEvent: (Bool, GestureEvent, Float64, Float64) -> Unit
}
