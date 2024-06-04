/**
 * Created on 2024/5/11
 */
package core.pie

public enum ChartGesture <: ToString {
    | NONE
    | DRAG
    | X_ZOOM
    | Y_ZOOM
    | PINCH_ZOOM
    | ROTATE
    | SINGLE_TAP
    | DOUBLE_TAP
    | LONG_PRESS
    | FLING

    public func toString(): String {
        match (this) {
            case NONE => "NONE"
            case DRAG => "DRAG"
            case X_ZOOM => "X_ZOOM"
            case Y_ZOOM => "Y_ZOOM"
            case PINCH_ZOOM => "PINCH_ZOOM"
            case ROTATE => "ROTATE"
            case SINGLE_TAP => "SINGLE_TAP"
            case DOUBLE_TAP => "DOUBLE_TAP"
            case LONG_PRESS => "LONG_PRESS"
            case FLING => "FLING"
        }
    }
}

public abstract class ChartTouchListener<C, D, S, E> where C <: ChartModel<D, S, E>, D <: ChartData<S, E>,
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
    protected var mChart: C

    public init(chart: C) {
        this.mChart = chart
    }

    /**
     * Calls the OnChartGestureListener to do the start callback
     *
     * @param me
     */
    public func startAction(isTouchEvent: Bool, me: TouchEvent) {
        let l: ?OnChartGestureListener = this.mChart.getOnChartGestureListener();

        if (l.isSome()) {
            l().onChartGestureStartTouchEvent(isTouchEvent, me, this.mLastGesture)
        }
    }

    public func startAction(isTouchEvent: Bool, me: GestureEvent) {
        let l: ?OnChartGestureListener = this.mChart.getOnChartGestureListener();

        if (l.isSome()) {
            l().onChartGestureStartGestureEvent(isTouchEvent, me, this.mLastGesture)
        }
    }

    /**
     * Calls the OnChartGestureListener to do the end callback
     *
     * @param me
     */
    public func endAction(isTouchEvent: Bool, me: TouchEvent) {
        let l: ?OnChartGestureListener = this.mChart.getOnChartGestureListener();

        if (l.isSome()) {
            l().onChartGestureEndTouchEvent(isTouchEvent, me, this.mLastGesture);
        }
    }

    public func endAction(isTouchEvent: Bool, me: GestureEvent) {
        let l: ?OnChartGestureListener = this.mChart.getOnChartGestureListener();

        if (l.isSome()) {
            l().onChartGestureEndGestureEvent(isTouchEvent, me, this.mLastGesture);
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
            this.mChart.highlightValue(Option<Highlight>.None, true);
            this.mLastHighlighted = None
        } else {
            this.mChart.highlightValue(h, true);
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

    public func onSingleTapUp(isTouchEvent: Bool, event: TouchEvent): Unit
    public func onSingleTapUp(isTouchEvent: Bool, event: GestureEvent): Unit

    public func onDoubleTap(isTouchEvent: Bool, event: TouchEvent): Unit
    public func onDoubleTap(isTouchEvent: Bool, event: GestureEvent): Unit

    //public func onLongPressed(isTouchEvent: Bool, event: Event): Unit

    //public func onLongPressUp(isTouchEvent: Bool, event: Event): Unit

    //public func onLongPressCancel(isTouchEvent: Bool, event: Event): Unit

    public func actionDown(isTouchEvent: Bool, touchEvent: TouchEvent): Unit
    public func actionDown(isTouchEvent: Bool, gestureEvent: GestureEvent): Unit

    public func actionMove(isTouchEvent: Bool, touchEvent: TouchEvent): Unit
    public func actionMove(isTouchEvent: Bool, gestureEvent: GestureEvent): Unit

    public func actionUp(isTouchEvent: Bool, touchEvent: TouchEvent): Unit
    public func actionUp(isTouchEvent: Bool, gestureEvent: GestureEvent): Unit

    public func actionCancel(isTouchEvent: Bool, event: TouchEvent): Unit
    public func actionCancel(isTouchEvent: Bool, event: GestureEvent): Unit

    public func actionPinchDown(isTouchEvent: Bool, event: TouchEvent): Unit
    public func actionPinchDown(isTouchEvent: Bool, event: GestureEvent): Unit

    public func actionPinchUp(isTouchEvent: Bool, event: TouchEvent): Unit
    public func actionPinchUp(isTouchEvent: Bool, event: GestureEvent): Unit
}
