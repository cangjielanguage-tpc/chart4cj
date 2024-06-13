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
    func onChartGestureStart(isTouchEvent: Bool, me: Any, lastPerformedGesture: ChartGesture): Unit

    /**
     * Callbacks when a touch-gesture has ended on the chart (ACTION_UP, ACTION_CANCEL)
     *
     * @param me
     * @param lastPerformedGesture
     */
    func onChartGestureEnd(isTouchEvent: Bool, me: Any, lastPerformedGesture: ChartGesture): Unit
    /**
     * Callbacks when the chart is longpressed.
     *
     * @param me
     */
    func onChartLongPressed(isTouchEvent: Bool, me: Any): Unit

    /**
     * Callbacks when the chart is double-tapped.
     *
     * @param me
     */
    func onChartDoubleTapped(isTouchEvent: Bool, me: Any): Unit

    /**
     * Callbacks when the chart is single-tapped.
     *
     * @param me
     */
    func onChartSingleTapped(isTouchEvent: Bool, me: Any): Unit

    /**
     * Callbacks then a fling gesture is made on the chart.
     *
     * @param me1
     * @param me2
     * @param velocityX
     * @param velocityY
     */
    func onChartFling(isTouchEvent: Bool, me1: Any, me2: TouchEvent, velocityX: Float64, velocityY: Float64): Unit

    /**
     * Callbacks when the chart is scaled / zoomed via pinch zoom / double-tap gesture.
     *
     * @param me
     * @param scaleX scalefactor on the x-axis
     * @param scaleY scalefactor on the y-axis
     */
    func onChartScale(isTouchEvent: Bool, me: Any, scaleX: Float64, scaleY: Float64): Unit

    /**
     * Callbacks when the chart is moved / translated via drag gesture.
     *
     * @param me
     * @param dX translation distance on the x-axis
     * @param dY translation distance on the y-axis
     */
    func onChartTranslate(isTouchEvent: Bool, me: Any, dX: Float64, dY: Float64): Unit
}
