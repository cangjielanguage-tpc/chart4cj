/**
 * Created on 2024/6/7
 */
package core.bar

public class BarLineChartTouchListener<D, S, E> <: ChartTouchListener<D, S, E> where D <: BarLineScatterCandleBubbleData<S,
    E>, S <: IBarLineScatterCandleBubbleDataSet<E>, E <: EntryOhos {
    /**
     * the original touch-matrix from the chart
     */
    private var mMatrix: Matrix = Matrix()
    /**
     * matrix for saving the original matrix state
     */
    private var mSavedMatrix: Matrix = Matrix()
    /**
     * point where the touch action started
     */
    private var mTouchStartPoint: MPPointF = MPPointF.getInstance(0.0, 0.0)
    /**
     * center between two pointers (fingers on the display)
     */
    private var mTouchPointCenter: MPPointF = MPPointF.getInstance(0.0, 0.0)
    private var mSavedXDist: Float64 = 1.0
    private var mSavedYDist: Float64 = 1.0
    private var mSavedDist: Float64 = 1.0
    private var mClosestDataSetToTouch: ?IDataSet<EntryOhos> = None
    /**
     * used for tracking velocity of dragging
     */
    private var mDecelerationLastTime: Int64 = 0
    private var mDecelerationCurrentPoint: MPPointF = MPPointF.getInstance(0.0, 0.0)
    private var mDecelerationVelocity: MPPointF = MPPointF.getInstance(0.0, 0.0)
    /**
     * the distance of movement that will be counted as a drag
     */
    private var mDragTriggerDist: Float64 = 0.0
    /**
     * the minimum distance between the pointers that will trigger a zoom gesture
     */
    private var mMinScalePointerDistance: Float64 = 0.0

    private var mStartPointX: Float64 = 0.0
    private var mStartPointY: Float64 = 0.0
    private var mSingleTapThreshold: Int64 = 10

    private var mLongPressStatus: Bool = false
    private var isDragging: Bool = false

    var barChartModel: BarLineChartBaseModel<D, S, E>

    /**
     * Constructor with initialization parameters.
     *
     * @param chart               instance of the chart
     * @param touchMatrix         the touch-matrix of the chart
     * @param dragTriggerDistance the minimum movement distance that will be interpreted as a "drag" gesture in vp (3vp equals
     *                            to about 9 pixels on a 5.5" FHD screen)
     */
    public init(chart: BarLineChartBaseModel<D, S, E>, touchMatrix: Matrix, dragTriggerDistance: Float64) {
        super(chart)
        this.barChartModel = chart
        this.mMatrix = touchMatrix

        this.mDragTriggerDist = Utils.handleDataValues(dragTriggerDistance)

        this.mMinScalePointerDistance = Utils.handleDataValues(3.5)
    }

    public func onTouch(event: TouchEvent) {
        match (event.eventType) {
            case TouchType.Down => this.actionDown(true, event)
            case TouchType.Move => this.actionMove(true, event)
            case TouchType.Up => this.actionUp(true, event)
            case TouchType.Cancel => this.actionUp(true, event)
            case _ => ()
        }
    }

    public func actionDown(isTouchEvent: Bool, event: Any): Unit {
        if (!this.barChartModel.isDragEnabled() && (!this.barChartModel.isScaleXEnabled() &&
            !this.barChartModel.isScaleYEnabled())) {
            return
        }
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touchEvent = event as TouchEvent
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            }
            xCoordinate = touchEvent().touches[0].x
            yCoordinate = touchEvent().touches[0].y
        } else {
            let gestureEvent = event as GestureEvent
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            }
            xCoordinate = gestureEvent().fingerList[0].localX
            yCoordinate = gestureEvent().fingerList[0].localY
        }
        this.mStartPointX = xCoordinate
        this.mStartPointY = yCoordinate

        this.startAction(isTouchEvent, event)
        this.stopDeceleration()
        this.saveTouchStart(isTouchEvent, event)
    }

    public func actionPinchDown(isTouchEvent: Bool, event: Any): Unit {
        this.barChartModel.disableScroll()
        this.saveTouchStart(true, event)
        // get the distance between the pointers on the x-axis
        this.mSavedXDist = BarLineChartTouchListener<D, S, E>.getXDist(isTouchEvent, event)
        // get the distance between the pointers on the y-axis
        this.mSavedYDist = BarLineChartTouchListener<D, S, E>.getYDist(isTouchEvent, event)
        // get the total distance between the pointers
        this.mSavedDist = BarLineChartTouchListener<D, S, E>.spacing(isTouchEvent, event)
        if (this.mSavedDist > 10.0) {
            if (this.barChartModel.isPinchZoomEnabled()) {
                this.mTouchMode = 4 //ChartTouchListener.PINCH_ZOOM
            } else {
                if (this.barChartModel.isScaleXEnabled() != this.barChartModel.isScaleYEnabled()) {
                    this.mTouchMode = if (this.barChartModel.isScaleXEnabled()) {
                        2 //ChartTouchListener.X_ZOOM
                    } else {
                        3 // ChartTouchListener.Y_ZOOM
                    }
                } else {
                    this.mTouchMode = if (this.mSavedXDist > this.mSavedYDist) {
                        2 // ChartTouchListener.X_ZOOM
                    } else {
                        3 //ChartTouchListener.Y_ZOOM
                    }
                }
            }
            // determine the touch-pointer center
            BarLineChartTouchListener<D, S, E>.midPoint(this.mTouchPointCenter, isTouchEvent, event)
        }
    }

    public func actionMove(isTouchEvent: Bool, event: Any): Unit {
        var xCoordinate: Float64 = actionMoveisTouchEventFunc(isTouchEvent, event)[0]
        var yCoordinate: Float64 = actionMoveisTouchEventFunc(isTouchEvent, event)[1]

        if (!this.barChartModel.getViewPortHandler().isInBounds(xCoordinate, yCoordinate)) {
            this.barChartModel.highlightValueForObject(Option<Highlight>.None, true)
        }

        this.isDragging = false
        // long press cursor response capability
        if (this.barChartModel.getLongPressCursorEnabled()) {
            this.longPressCursorAction(isTouchEvent, event, xCoordinate, yCoordinate)
            return
        }

        if (this.mTouchMode == 1 /*ChartTouchListener.DRAG*/ ) {
            actionMoveTouchModeIs1(isTouchEvent, event, xCoordinate, yCoordinate)
        } else if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4) {
            this.barChartModel.disableScroll()
            if (this.barChartModel.isScaleXEnabled() || this.barChartModel.isScaleYEnabled()) {
                this.performZoom(isTouchEvent, event)
            }
        } else if (this.mTouchMode == 0 &&
            abs(
            ChartTouchListener<D, S, E>.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y)) > this.mDragTriggerDist && this.barChartModel.getViewPortHandler().isInBounds(
            xCoordinate, yCoordinate)) {
            actionMoveTouchModeIs0(isTouchEvent, event, xCoordinate, yCoordinate)
        }

        // perform the transformation, update the chart
        this.mMatrix = this.barChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            (this.barChartModel as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)(
                ),
            true
        )
    }

    private func actionMoveisTouchEventFunc(isTouchEvent: Bool, event: Any): (Float64, Float64) {
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return (xCoordinate, yCoordinate)
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
            return (xCoordinate, yCoordinate)
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return (xCoordinate, yCoordinate)
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
            return (xCoordinate, yCoordinate)
        }
    }

    private func actionMoveTouchModeIs1(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64): Unit {
        this.barChartModel.disableScroll()
        let x: Float64 = if (this.barChartModel.isDragXEnabled()) {
            xCoordinate - this.mTouchStartPoint.x
        } else {
            0.0
        }
        let y: Float64 = if (this.barChartModel.isDragYEnabled()) {
            yCoordinate - this.mTouchStartPoint.y
        } else {
            0.0
        }
        this.performDrag(isTouchEvent, event, x, y)
    }

    private func actionMoveTouchModeIs0(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64) {
        if (this.barChartModel.isDragEnabled()) {
            this.isDragging = true

            let shouldPan: Bool = !this.barChartModel.isFullyZoomedOut() || !this.barChartModel.hasNoDragOffset()
            if (shouldPan) {
                let distanceX: Float64 = abs(xCoordinate - this.mTouchStartPoint.x)
                let distanceY: Float64 = abs(yCoordinate - this.mTouchStartPoint.y)
                // Disable dragging in a direction that's disallowed
                if ((this.barChartModel.isDragXEnabled() || distanceY >= distanceX) && (this.barChartModel.
                    isDragYEnabled() || distanceY <= distanceX)) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.mTouchMode = 1
                }
            } else {
                if (this.barChartModel.isHighlightPerDragEnabled()) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.performHighlightDrag(isTouchEvent, event, true)
                }
            }
        }
    }

    private func touchMode0Or7(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64): Unit {
        if (this.barChartModel.isDragEnabled()) {
            this.isDragging = true

            let shouldPan: Bool = !this.barChartModel.isFullyZoomedOut() || !this.barChartModel.hasNoDragOffset()
            if (shouldPan && !this.mLongPressStatus) {
                let distanceX: Float64 = abs(xCoordinate - this.mTouchStartPoint.x)
                let distanceY: Float64 = abs(yCoordinate - this.mTouchStartPoint.y)
                // Disable dragging in a direction that's disallowed
                if ((this.barChartModel.isDragXEnabled() || distanceY >= distanceX) && (this.barChartModel.
                    isDragYEnabled() || distanceY <= distanceX)) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.mTouchMode = 1
                    this.performHighlightDrag(isTouchEvent, event, true)
                }
            } else if (this.mLongPressStatus) {
                if (this.barChartModel.isHighlightPerDragEnabled()) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.performHighlightDrag(isTouchEvent, event, true)
                }
            } else if (!this.mLongPressStatus) {
                // response event of sliding left or right
                this.barChartModel.getOnChartGestureListener()?.onChartTranslate(isTouchEvent, event,
                    xCoordinate - this.mStartPointX, yCoordinate - this.mStartPointY)
            }
        }
    }
    private func longPressCursorAction(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64) {
        if (this.mTouchMode == 1) {
            this.barChartModel.disableScroll()
            let x: Float64 = if (this.barChartModel.isDragXEnabled()) {
                xCoordinate - this.mTouchStartPoint.x
            } else {
                0.0
            }
            let y: Float64 = if (this.barChartModel.isDragYEnabled()) {
                yCoordinate - this.mTouchStartPoint.y
            } else {
                0.0
            }
            this.performDrag(isTouchEvent, event, x, y)
        } else if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4) {
            this.barChartModel.disableScroll()
            if (this.barChartModel.isScaleXEnabled() || this.barChartModel.isScaleYEnabled()) {
                this.performZoom(isTouchEvent, event)
                this.performHighlightDrag(isTouchEvent, event, true)
            }
        } else if ((this.mTouchMode == 0 || this.mTouchMode == 7)
            &&
            abs(
            ChartTouchListener<D, S, E>.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y)) > this.mDragTriggerDist) {
            touchMode0Or7(isTouchEvent, event, xCoordinate, yCoordinate)
        }

        // perform the transformation, update the chart
        this.mMatrix = this.barChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            (this.barChartModel as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)(
                ),
            true
        )
    }

    public func actionUp(isTouchEvent: Bool, event: Any): Unit {
        this.mLongPressStatus = false
        var gestureFingersCount: Int64 = 1
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
            gestureFingersCount = touch().touches.size
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
            gestureFingersCount = gesture().fingerList.size
        }

        if (abs(xCoordinate) > Float64(Utils.getMinimumFlingVelocity()) || abs(yCoordinate) > Float64(Utils.
                getMinimumFlingVelocity())) {
            if (this.mTouchMode == 1 /* ChartTouchListener.DRAG*/ && this.barChartModel.isDragDecelerationEnabled()) {
                this.stopDeceleration()

                this.mDecelerationLastTime = DateTime.now().second * 1000

                this.mDecelerationCurrentPoint.x = xCoordinate
                this.mDecelerationCurrentPoint.y = yCoordinate
            }
        }

        if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4 || this.mTouchMode == 5) {

            // Range might have changed, which means that Y-axis labels
            // could have changed in size, affecting Y-axis size.
            // So we need to recalculate offsets.
            this.barChartModel.calculateOffsets()
        }

        this.mTouchMode = 0
        this.barChartModel.enableScroll()

        this.endAction(isTouchEvent, event)

        if (gestureFingersCount >= 2) {
            this.mTouchMode = 5
        }
    }

    public func actionPinchUp(isTouchEvent: Bool, event: Any): Unit {
        this.mTouchMode = 5

        // perform the transformation, update the chart
        this.mMatrix = this.barChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            (this.barChartModel as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)(
                ),
            true
        )
    }

    public func actionCancel(isTouchEvent: Bool, event: Any): Unit {
        this.mTouchMode = 0
        this.endAction(isTouchEvent, event)
        // perform the transformation, update the chart
        this.mMatrix = this.barChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            (this.barChartModel as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)(
                ),
            true
        )
    }

    /**
     * ################ ################ ################ ################
     */
    /** BELOW CODE PERFORMS THE ACTUAL TOUCH ACTIONS */

    /**
     * Saves the current Matrix state and the touch-start point.
     *
     * @param event
     */
    private func saveTouchStart(isTouchEvent: Bool, event: Any) {
        this.mSavedMatrix.set(this.mMatrix)
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            this.mTouchStartPoint.x = touch().touches[0].x
            this.mTouchStartPoint.y = touch().touches[0].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            this.mTouchStartPoint.x = gesture().fingerList[0].globalX
            this.mTouchStartPoint.y = gesture().fingerList[0].globalY
        }

        this.mClosestDataSetToTouch = (this.barChartModel.getDataSetByTouchPoint(
            this.mTouchStartPoint.x,
            this.mTouchStartPoint.y
        ) as IBarLineScatterCandleBubbleDataSet<EntryOhos>)()
    }

    /**
     * Performs all necessary operations needed for dragging.
     *
     * @param event
     */
    private func performDrag(isTouchEvent: Bool, event: Any, distanceX: Float64, distanceY: Float64) {
        this.mLastGesture = ChartGesture.DRAG

        this.mMatrix.set(this.mSavedMatrix)

        let l: ?OnChartGestureListener = this.barChartModel.getOnChartGestureListener()

        var newDistanceY = distanceY
        // check if axis is inverted
        if (this.inverted()) {
            newDistanceY = -distanceY
        }

        this.mMatrix.postTranslate(distanceX, newDistanceY)

        if (let Some(listener) <- l) {
            listener.onChartTranslate(isTouchEvent, event, distanceX, distanceY)
        }
        this.barChartModel.invalidate()
    }

    private func performZoomTouchModeIs4(totalDist: Float64, h: ViewPortHandler, l: ?OnChartGestureListener,
        t: MPPointF, isTouchEvent: Bool, event: Any) {
        this.mLastGesture = ChartGesture.PINCH_ZOOM

        let scale: Float64 = totalDist / this.mSavedDist // total scale

        let isZoomingOut: Bool = (scale < 1.0)

        let canZoomMoreX: Bool = if (isZoomingOut) {
            h.canZoomOutMoreX()
        } else {
            h.canZoomInMoreX()
        }

        let canZoomMoreY: Bool = if (isZoomingOut) {
            h.canZoomOutMoreY()
        } else {
            h.canZoomInMoreY()
        }

        let scaleX: Float64 = if (this.barChartModel.isScaleXEnabled()) {
            scale
        } else {
            1.0
        }
        let scaleY: Float64 = if (this.barChartModel.isScaleYEnabled()) {
            scale
        } else {
            1.0
        }

        if (canZoomMoreY || canZoomMoreX) {
            this.mMatrix.set(this.mSavedMatrix)
            this.mMatrix.postScale(scaleX, scaleY, centerX: t.x, centerY: t.y)

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, event, scaleX, scaleY)
            }
        }
    }

    private func performZoomTouchModeIs2(h: ViewPortHandler, isTouchEvent: Bool, event: Any, t: MPPointF,
        l: ?OnChartGestureListener) {
        this.mLastGesture = ChartGesture.X_ZOOM

        let xDist: Float64 = BarLineChartTouchListener<D, S, E>.getXDist(isTouchEvent, event)
        let scaleX: Float64 = xDist / this.mSavedXDist // x-axis scale

        let isZoomingOut: Bool = (scaleX < 1.0)
        let canZoomMoreX: Bool = if (isZoomingOut) {
            h.canZoomOutMoreX()
        } else {
            h.canZoomInMoreX()
        }

        if (canZoomMoreX) {
            this.mMatrix.set(this.mSavedMatrix)
            this.mMatrix.postScale(scaleX, 1.0, centerX: t.x, centerY: t.y)

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, event, scaleX, 1.0)
            }
        }
    }

    private func performZoomTouchModeIs3(totalDist: Float64, h: ViewPortHandler, l: ?OnChartGestureListener,
        t: MPPointF, isTouchEvent: Bool, event: Any) {
        this.mLastGesture = ChartGesture.Y_ZOOM

        let yDist: Float64 = BarLineChartTouchListener<D, S, E>.getYDist(isTouchEvent, event)
        let scaleY: Float64 = yDist / this.mSavedYDist // y-axis scale

        let isZoomingOut: Bool = (scaleY < 1.0)
        let canZoomMoreY: Bool = if (isZoomingOut) {
            h.canZoomOutMoreY()
        } else {
            h.canZoomInMoreY()
        }

        if (canZoomMoreY) {
            this.mMatrix.set(this.mSavedMatrix)
            this.mMatrix.postScale(1.0, scaleY, centerX: t.x, centerY: t.y)

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, event, 1.0, scaleY)
            }
        }
    }
    /**
     * Performs the all operations necessary for pinch and axis zoom.
     *
     * @param event
     */
    private func performZoom(isTouchEvent: Bool, event: Any) {
        var gestureFingersCount: Int64 = 1
        if (isTouchEvent) {
            let touch = event as TouchEvent
            gestureFingersCount = touch().touches.size
        } else {
            let gesture = event as GestureEvent
            gestureFingersCount = gesture().fingerList.size
        }
        if (gestureFingersCount >= 2) { // two finger zoom

            let l: ?OnChartGestureListener = this.barChartModel.getOnChartGestureListener()

            // get the distance between the pointers of the touch event
            let totalDist: Float64 = BarLineChartTouchListener<D, S, E>.spacing(isTouchEvent, event)

            if (totalDist > this.mMinScalePointerDistance) {

                // get the translation
                let t: MPPointF = this.getTrans(this.mTouchPointCenter.x, this.mTouchPointCenter.y)
                let h: ViewPortHandler = this.barChartModel.getViewPortHandler()

                // take actions depending on the activated touch mode
                if (this.mTouchMode == 4 /* ChartTouchListener.PINCH_ZOOM*/ ) {
                    performZoomTouchModeIs4(totalDist, h, l, t, isTouchEvent, event)
                } else if (this.mTouchMode == 2 /*ChartTouchListener.X_ZOOM*/ && this.barChartModel.isScaleXEnabled()) {
                    performZoomTouchModeIs2(h, isTouchEvent, event, t, l)
                } else if (this.mTouchMode == 3 /* ChartTouchListener.Y_ZOOM*/ && this.barChartModel.isScaleYEnabled()) {
                    performZoomTouchModeIs3(totalDist, h, l, t, isTouchEvent, event)
                }

                MPPointF.recycleInstance(t)
            }
        }
    }

    /**
     * Highlights upon dragging, generates callbacks for the selection-listener.
     *
     * @param e
     */
    func performHighlightDrag(isTouchEvent: Bool, event: Any, isLongPressed: Bool) {
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
        }
        let h: ?Highlight = this.barChartModel.getHighlightByTouchPoint(xCoordinate, yCoordinate)

        if (!isLongPressed) {
            this.mLastHighlighted = h
        }
        this.barChartModel.highlightValueForObject(
            if (isLongPressed) {
                this.mLastHighlighted
            } else {
                h
            },
            true
        )
    }

    /**
     * ################ ################ ################ ################
     */
    /** DOING THE MATH BELOW -) */

    /**
     * Determines the center point between two pointer touch points.
     *
     * @param point
     * @param event
     */
    private static func midPoint(point: MPPointF, isTouchEvent: Bool, event: Any) {
        var x: Float64 = 0.0
        var y: Float64 = 0.0

        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            x = touch().touches[0].x + touch().touches[1].x
            y = touch().touches[0].y + touch().touches[1].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX + gesture().fingerList[1].localX
            y = gesture().fingerList[0].localY + gesture().fingerList[1].localY
        }
        point.x = (x / 2.0)
        point.y = (y / 2.0)
    }

    /**
     * returns the distance between two pointer touch points
     *
     * @param event
     * @return
     */
    private static func spacing(isTouchEvent: Bool, event: Any): Float64 {
        var x: Float64 = 0.0
        var y: Float64 = 0.0

        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return 0.0
            }
            x = touch().touches[0].x - touch().touches[1].x
            y = touch().touches[0].y - touch().touches[1].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return 0.0
            }
            x = gesture().fingerList[0].localX - gesture().fingerList[1].localX
            y = gesture().fingerList[0].localY - gesture().fingerList[1].localY
        }

        return sqrt(x * x + y * y)
    }

    /**
     * calculates the distance on the x-axis between two pointers (fingers on
     * the display)
     *
     * @param e
     * @return
     */
    private static func getXDist(isTouchEvent: Bool, e: Any): Float64 {
        var x: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return 0.0
            }
            x = abs(touch().touches[0].x - touch().touches[1].x)
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return 0.0
            }
            x = abs(gesture().fingerList[0].localX - gesture().fingerList[1].localX)
        }
        return x
    }

    /**
     * calculates the distance on the y-axis between two pointers (fingers on
     * the display)
     *
     * @param e
     * @return
     */
    private static func getYDist(isTouchEvent: Bool, e: Any): Float64 {
        var y: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return 0.0
            }
            y = abs(touch().touches[0].y - touch().touches[1].y)
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return 0.0
            }
            y = abs(gesture().fingerList[0].localY - gesture().fingerList[1].localY)
        }
        return y
    }

    /**
     * Returns a recyclable MPPointF instance.
     * returns the correct translation depending on the provided x and y touch
     * points
     *
     * @param x
     * @param y
     * @return
     */
    public func getTrans(x: Float64, y: Float64): MPPointF {
        let vph: ViewPortHandler = this.barChartModel.getViewPortHandler()

        var xTrans: Float64 = x - vph.offsetLeft()
        var yTrans: Float64 = 0.0

        // check if axis is inverted
        if (this.inverted()) {
            yTrans = -(y - vph.offsetTop())
        } else {
            yTrans = -(this.barChartModel.getHeight() - y - vph.offsetBottom())
        }

        return MPPointF.getInstance(xTrans, yTrans)
    }

    /**
     * Returns true if the current touch situation should be interpreted as inverted, false if not.
     *
     * @return
     */
    private func inverted(): Bool {
        return (this.mClosestDataSetToTouch.isNone() && this.barChartModel.isAnyAxisInverted()) || (this.
            mClosestDataSetToTouch.isSome()
            && this.barChartModel.isInverted(this.mClosestDataSetToTouch().getAxisDependency()))
    }

    /**
     * ################ ################ ################ ################
     */
    /** GETTERS AND GESTURE RECOGNITION BELOW */

    /**
     * returns the matrix object the listener holds
     *
     * @return
     */
    public func getMatrix(): Matrix {
        return this.mMatrix
    }

    /**
     * Sets the minimum distance that will be interpreted as a "drag" by the chart in vp.
     * Default: 3vp
     *
     * @param dragTriggerDistance
     */
    public func setDragTriggerDist(dragTriggerDistance: Float64) {
        this.mDragTriggerDist = Utils.handleDataValues(dragTriggerDistance)
    }

    public func onDoubleTap(isTouchEvent: Bool, e: Any): Unit {
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            x = touch().touches[0].x
            y = touch().touches[0].y
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }

        this.mLastGesture = ChartGesture.DOUBLE_TAP

        let l: ?OnChartGestureListener = this.barChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartDoubleTapped(isTouchEvent, e)
        }
        let chartData = this.barChartModel.getData()
        // check if double-tap zooming is enabled
        if (this.barChartModel.isDoubleTapToZoomEnabled() && chartData.isSome() && chartData().getEntryCount() > 0) {
            let trans: MPPointF = this.getTrans(x, y)

            let scaleX: Float64 = if (this.barChartModel.isScaleXEnabled()) {
                1.4
            } else {
                1.0
            }
            let scaleY: Float64 = if (this.barChartModel.isScaleYEnabled()) {
                1.4
            } else {
                1.0
            }

            this.barChartModel.zoom(scaleX, scaleY, trans.x, trans.y, Option<AxisDependency>.None)

            if (this.barChartModel.isLogEnabled()) {
                AppLog.info("BarlineChartTouch:" + "Double-Tap, Zooming In, x: ${trans.x}, y: ${trans.y}")
            }

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, e, scaleX, scaleY)
            }

            MPPointF.recycleInstance(trans)
        }
    }

    public func onLongPressed(isTouchEvent: Bool, e: Any) {
        this.startAction(isTouchEvent, e)

        this.mLongPressStatus = true
        this.mLastGesture = ChartGesture.LONG_PRESS

        let l: ?OnChartGestureListener = this.barChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartLongPressed(isTouchEvent, e)
        }

        if (!this.barChartModel.isHighlightPerLongPressEnabled()) {
            return
        }
        this.barChartModel.setLastGestureLongPress()
        this.mTouchMode = 7 /* ChartTouchListener.LONG_PRESS*/

        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            x = touch().touches[0].x
            y = touch().touches[0].y
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }
        let h: ?Highlight = this.barChartModel.getHighlightByTouchPoint(x, y)
        if (let Some(highlight) <- h) {
            this.performHighlight(highlight, Option<TouchEvent>.None)
        }
    }

    public func getXyByEvent(isTouchEvent: Bool, e: Any): (Float64, Float64) {
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return (0.0, 0.0)
            }
            x = touch().touches[0].x
            y = touch().touches[0].y
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return (0.0, 0.0)
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }
        return (x, y)
    }

    public func onLongPressUp(isTouchEvent: Bool, e: Any) {
        this.mLastGesture = ChartGesture.LONG_PRESS
        this.endAction(isTouchEvent, e)
    }

    public func onLongPressCancel(isTouchEvent: Bool, e: Any) {
        this.mLastGesture = ChartGesture.LONG_PRESS
        this.endAction(isTouchEvent, e)
    }

    public func onSingleTapUp(isTouchEvent: Bool, e: Any): Unit {
        this.actionDown(isTouchEvent, e)
        this.mLastGesture = ChartGesture.SINGLE_TAP

        let l: ?OnChartGestureListener = this.barChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartSingleTapped(isTouchEvent, e)
        }

        if (!this.barChartModel.isHighlightPerTapEnabled()) {
            return
        }
        this.barChartModel.setLastGestureSingleTap()
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            x = touch().touches[0].x
            y = touch().touches[0].y
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }
        let h: ?Highlight = this.barChartModel.getHighlightByTouchPoint(x, y)
        if (let Some(highlight) <- h) {
            this.performHighlight(highlight, Option<TouchEvent>.None)
        }

        this.actionUp(isTouchEvent, e)
    }

    public func onFling(isTouchEvent: Bool, e1: TouchEvent, e2: TouchEvent, velocityX: Float64, velocityY: Float64): Bool {
        this.mLastGesture = ChartGesture.FLING

        let l: ?OnChartGestureListener = this.barChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartFling(isTouchEvent, e1, e2, velocityX, velocityY)
        }

        return false
    }

    public func stopDeceleration() {
        this.mDecelerationVelocity.x = 0.0
        this.mDecelerationVelocity.y = 0.0
    }

    public func computeScroll() {
        if (this.mDecelerationVelocity.x == 0.0 && this.mDecelerationVelocity.y == 0.0) {
            return
        }

        let currentTime: Int64 = DateTime.now().second * 1000

        this.mDecelerationVelocity.x *= this.barChartModel.getDragDecelerationFrictionCoef()
        this.mDecelerationVelocity.y *= this.barChartModel.getDragDecelerationFrictionCoef()

        let timeInterval: Int64 = (currentTime - this.mDecelerationLastTime) / 1000

        let distanceX: Float64 = this.mDecelerationVelocity.x * Float64(timeInterval)
        let distanceY: Float64 = this.mDecelerationVelocity.y * Float64(timeInterval)

        this.mDecelerationCurrentPoint.x += distanceX
        this.mDecelerationCurrentPoint.y += distanceY

        this.mMatrix = this.barChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            (this.barChartModel as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)(
                ),
            false
        )

        this.mDecelerationLastTime = currentTime

        if (!(abs(this.mDecelerationVelocity.x) >= 0.01 || abs(this.mDecelerationVelocity.y) >= 0.01)) {
            this.barChartModel.calculateOffsets()
            this.stopDeceleration()
        }
    }
}
