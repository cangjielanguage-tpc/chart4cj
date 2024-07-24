/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public abstract class ChartTouchListener<D, S, E> where  D <: ChartData<S, E>,
    S <: IDataSet<E>, E <: EntryOhos {
    /**
     * the last touch gesture that has been performed
     **/
    public var mLastGesture: ChartGesture = ChartGesture.NONE
    // states
    protected static var NONE: Int64 = 0
    protected static var DRAG: Int64 = 1
    protected static var X_ZOOM: Int64 = 2
    protected static var Y_ZOOM: Int64 = 3
    protected static var PINCH_ZOOM: Int64 = 4
    protected static var POST_ZOOM: Int64 = 5
    protected static var ROTATE: Int64 = 6
    protected static var LONG_PRESS: Int64 = 7
    /**
     * integer field that holds the current touch-state
     */
    protected var mTouchMode: Int64 = NONE
    /**
     * the last highlighted object (via touch)
     */
    protected var mLastHighlighted: ?Highlight = None
    /**
     * the chart the listener represents
     */
    protected var mChart: ChartModel<D, S, E>

    public init(chart: ChartModel<D, S, E> ) {
        this.mChart = chart
    }

    /**
     * Calls the OnChartGestureListener to do the start callback
     *
     * @param me
     */
    public func startAction(isTouchEvent: Bool, me: Any) {
        let l: ?OnChartGestureListener = this.mChart.getOnChartGestureListener();

        if (let Some(listener) <- l) {
            listener.onChartGestureStart(isTouchEvent, me, this.mLastGesture)
        }
    }

    /**
     * Calls the OnChartGestureListener to do the end callback
     *
     * @param me
     */
    public func endAction(isTouchEvent: Bool, me: Any) {
        let l: ?OnChartGestureListener = this.mChart.getOnChartGestureListener();

        if (let Some(listener) <- l) {
            listener.onChartGestureStart(isTouchEvent, me, this.mLastGesture);
        }
    }

    /**
     * Sets the last value that was highlighted via touch.
     *
     * @param high
     */
    public func setLastHighlighted(high: ?Highlight) {
        this.mLastHighlighted = high
    }

    /**
     * returns the touch mode the listener is currently in
     *
     * @return
     */
    public func getTouchMode(): Int64 {
        return this.mTouchMode;
    }

    /**
     * Returns the last gesture that has been performed on the chart.
     *
     * @return
     */
    public func getLastGesture(): ?ChartGesture {
        return this.mLastGesture;
    }

    /**
     * Perform a highlight operation.
     *
     * @param e
     */
    protected func performHighlight(h: Highlight, e: ?TouchEvent) {
        if (Utils.isHighLightEquals(h, this.mLastHighlighted)) {
            // this.mChart.highlightValue(0,undefined,undefined, undefined,true);
            this.mChart.highlightValueForObject(Option<Highlight>.None, true);
            this.mLastHighlighted = None
        } else {
            this.mChart.highlightValueForObject(h, true);
            this.mLastHighlighted = h
        }
    }

    /**
     * returns the distance between two points
     *
     * @param eventX
     * @param startX
     * @param eventY
     * @param startY
     * @return
     */
    protected static func distance(eventX: Float64, startX: Float64, eventY: Float64, startY: Float64): Float64 {
        let dx: Float64 = eventX - startX;
        let dy: Float64 = eventY - startY;
        return sqrt(dx * dx + dy * dy);
    }

    //public func onTouch(event: TouchEvent): Unit

    public func onSingleTapUp(isTouchEvent: Bool, event: Any): Unit

    public func onDoubleTap(isTouchEvent: Bool, event: Any): Unit

    public func onLongPressed(isTouchEvent: Bool, event: Any): Unit

    public func onLongPressUp(isTouchEvent: Bool, event: Any): Unit

    public func onLongPressCancel(isTouchEvent: Bool, event: Any): Unit

    public func actionDown(isTouchEvent: Bool, touchEvent: Any): Unit

    public func actionMove(isTouchEvent: Bool, touchEvent: Any): Unit

    public func actionUp(isTouchEvent: Bool, touchEvent: Any): Unit

    public func actionCancel(isTouchEvent: Bool, event: Any): Unit

    public func actionPinchDown(isTouchEvent: Bool, event: Any): Unit

    public func actionPinchUp(isTouchEvent: Bool, event: Any): Unit
}
