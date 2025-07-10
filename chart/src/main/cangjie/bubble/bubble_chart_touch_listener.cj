/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bubble
import ohos.system_date_time.SystemDateTime

public class BubbleChartTouchListener <: ChartTouchListener<BubbleData, IBubbleDataSet, BubblesEntry> {
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
    private var mClosestDataSetToTouch: ?IBubbleDataSet = None
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

    var bubbleChartModel: BubbleChartModel
    private var animatorIsPlaying: Bool = false
    var downTime: Int64 = 0
    var downPointX: Float64 = -1.0
    var downPointY: Float64 = -1.0
    var maxSwipePointX: Float64 = -1.0
    var maxSwipePointY: Float64 = -1.0
    private var animatorResult: ?AnimatorResult = Option<AnimatorResult>.None


    /**
     * Constructor with initialization parameters.
     *
     * @param chart               instance of the chart
     * @param touchMatrix         the touch-matrix of the chart
     * @param dragTriggerDistance the minimum movement distance that will be interpreted as a "drag" gesture in vp (3vp equals
     *                            to about 9 pixels on a 5.5" FHD screen)
     */
    public init(chart: BubbleChartModel, touchMatrix: Matrix, dragTriggerDistance: Float64) {
        super(chart)
        this.bubbleChartModel = chart
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
        if (!this.bubbleChartModel.isDragEnabled() && (!this.bubbleChartModel.isScaleXEnabled() &&
            !this.bubbleChartModel.isScaleYEnabled())) {
            return
        }
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (this.animatorResult.isSome() && this.animatorIsPlaying) {
            this.animatorResult().pause()
            this.animatorIsPlaying = false
        }
        if (isTouchEvent) {
            let touchEvent = event as TouchEvent
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            }
            xCoordinate = touchEvent().touches[0].x
            yCoordinate = touchEvent().touches[0].y
            this.downTime = SystemDateTime.getCurrentTime()
            this.downPointX = xCoordinate
            this.downPointY = yCoordinate
        } else {
 //TODO
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
        this.bubbleChartModel.disableScroll()
        this.saveTouchStart(true, event)
        // get the distance between the pointers on the x-axis
        this.mSavedXDist = BubbleChartTouchListener.getXDist(isTouchEvent, event)
        // get the distance between the pointers on the y-axis
        this.mSavedYDist = BubbleChartTouchListener.getYDist(isTouchEvent, event)
        // get the total distance between the pointers
        this.mSavedDist = BubbleChartTouchListener.spacing(isTouchEvent, event)
        if (this.mSavedDist > 10.0) {
            if (this.bubbleChartModel.isPinchZoomEnabled()) {
                this.mTouchMode = 4 //ChartTouchListener.PINCH_ZOOM
            } else {
                if (this.bubbleChartModel.isScaleXEnabled() != this.bubbleChartModel.isScaleYEnabled()) {
                    this.mTouchMode = if (this.bubbleChartModel.isScaleXEnabled()) {
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
            BubbleChartTouchListener.midPoint(this.mTouchPointCenter, isTouchEvent, event)
        }
    }

    public func actionMove(isTouchEvent: Bool, event: Any): Unit {
        let l:? OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()
        if (let Some(listener) <- l) {
        	if (this.bubbleChartModel.getLongPressCursorEnabled()) {
                if (this.mLongPressStatus) {
                    listener.onChartMove(isTouchEvent, event)
                }
        	} else {
                	listener.onChartMove(isTouchEvent, event)
                }
        }

        var xCoordinate: Float64 =  0.0
        var yCoordinate: Float64 = 0.0

        if (isTouchEvent) {
        	let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
            if (this.bubbleChartModel.getLongPressCursorEnabled() && this.mLongPressStatus) {
        	    this.calculateLongPress(touch())
            }
        } else {
        	let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
        }

        this.isDragging = false
        // long press cursor response capability
        if (this.bubbleChartModel.getLongPressCursorEnabled()) {
            this.longPressCursorAction(isTouchEvent, event, xCoordinate, yCoordinate)
            return
        }
        if (!this.bubbleChartModel.getViewPortHandler().isInBounds(xCoordinate, yCoordinate)) {
        	this.bubbleChartModel.highlightValueForObject(Option<Highlight>.None, true)
        }


        if (this.mTouchMode == 1 /*ChartTouchListener.DRAG*/ ) {
            actionMoveTouchModeIs1(isTouchEvent, event, xCoordinate, yCoordinate)
            this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(this.mMatrix, this.bubbleChartModel, true)
        } else if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4) {
            this.bubbleChartModel.disableScroll()
            if (this.bubbleChartModel.isScaleXEnabled() || this.bubbleChartModel.isScaleYEnabled() && this.bubbleChartModel.isPinchZoomEnabled()) {
                this.performZoom(isTouchEvent, event)
            }
            this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(this.mMatrix, this.bubbleChartModel, true)
        } else if (this.mTouchMode == 0 &&
            abs(
            BubbleChartTouchListener.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y)) > this.mDragTriggerDist && this.bubbleChartModel.getViewPortHandler().isInBounds(
            xCoordinate, yCoordinate)) {
            actionMoveTouchModeIs0(isTouchEvent, event, xCoordinate, yCoordinate)
        }

        // perform the transformation, update the chart
        this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            (this.bubbleChartModel as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)(
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
            if (this.bubbleChartModel.getLongPressCursorEnabled() && !this.mLongPressStatus) {
                this.calculateLongPress(touch())
            }
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
    protected static func distance(eventX: Float64, startX: Float64, eventY: Float64, startY: Float64 ){
        let dx: Float64 = eventX - startX
        let dy: Float64 = eventY - startY
        return sqrt(dx*dx + dy * dy)
    }

    private func calculateLongPress(event: TouchEvent) {
        let curTime: Int64 = SystemDateTime.getCurrentTime()
        if (this.downTime > 0 && this.downPointX != -1.0 && (curTime - this.downTime) >= Int64(this.bubbleChartModel.getLongPressDuration())) {
        	let curPointX: Float64 = event.touches[0].x
        	let curPointY: Float64 = event.touches[0].y
        	let rangePointX: Float64 = abs(curPointX - this.downPointX)
        	let rangePointY: Float64 = abs(curPointY - this.downPointY)
            if (rangePointX > this.maxSwipePointX) {
                this.maxSwipePointX = rangePointX
            }
            if (rangePointY > this.maxSwipePointY) {
                this.maxSwipePointY = rangePointY
            }
            if (this.maxSwipePointX <= 1.0 && this.maxSwipePointY <= 1.0) {
                this.mLongPressStatus = true
                this.resetSwipeParm()
                let h: ?Highlight = this.bubbleChartModel.getHighlightByTouchPoint(curPointX, curPointY)
                if (let Some(high) <- h) {
                    this.performHighlight(high, Option<TouchEvent>.None)
                }
            }
        }
    }
    private func resetSwipeParm() {
        this.downTime = 0
        this.downPointX = -1.0
        this.downPointY = -1.0
        this.maxSwipePointX = -1.0
        this.maxSwipePointY = -1.0
    }
    private func actionMoveTouchModeIs1(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64): Unit {
        this.bubbleChartModel.disableScroll()
        let x: Float64 = if (this.bubbleChartModel.isDragXEnabled()) {
            xCoordinate - this.mTouchStartPoint.x
        } else {
            0.0
        }
        let y: Float64 = if (this.bubbleChartModel.isDragYEnabled()) {
            yCoordinate - this.mTouchStartPoint.y
        } else {
            0.0
        }
        this.performDrag(isTouchEvent, event, x, y)
    }

    private func actionMoveTouchModeIs0(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64) {
        if (this.bubbleChartModel.isDragEnabled()) {
            this.isDragging = true

            let shouldPan: Bool = !this.bubbleChartModel.isFullyZoomedOut() || !this.bubbleChartModel.hasNoDragOffset()
            if (shouldPan) {
                let distanceX: Float64 = abs(xCoordinate - this.mTouchStartPoint.x)
                let distanceY: Float64 = abs(yCoordinate - this.mTouchStartPoint.y)
                // Disable dragging in a direction that's disallowed
                if ((this.bubbleChartModel.isDragXEnabled() || distanceY >= distanceX) && (this.bubbleChartModel.
                    isDragYEnabled() || distanceY <= distanceX)) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.mTouchMode = 1
                }
            } else {
                if (this.bubbleChartModel.isHighlightPerDragEnabled()) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.performHighlightDrag(isTouchEvent, event, false)
                }
            }
        }
    }

    private func touchMode0Or7(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64): Unit {
        if (this.bubbleChartModel.isDragEnabled()) {
            this.isDragging = true

            let shouldPan: Bool = !this.bubbleChartModel.isFullyZoomedOut() || !this.bubbleChartModel.hasNoDragOffset()
            if (shouldPan && !this.mLongPressStatus) {
                let distanceX: Float64 = abs(xCoordinate - this.mTouchStartPoint.x)
                let distanceY: Float64 = abs(yCoordinate - this.mTouchStartPoint.y)
                // Disable dragging in a direction that's disallowed
                if ((this.bubbleChartModel.isDragXEnabled() || distanceY >= distanceX) && (this.bubbleChartModel.
                    isDragYEnabled() || distanceY <= distanceX)) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.mTouchMode = 1
                    this.performHighlightDrag(isTouchEvent, event, false)
                }
            } else if (this.mLongPressStatus) {
                if (this.bubbleChartModel.isHighlightPerDragEnabled()) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.performHighlightDrag(isTouchEvent, event, false)
                }
            } else if (!this.mLongPressStatus) {
                // response event of sliding left or right
                this.bubbleChartModel.getOnChartGestureListener()?.onChartTranslate(isTouchEvent, event,
                    xCoordinate - this.mStartPointX, yCoordinate - this.mStartPointY)
            }
        }
    }
    private func longPressCursorAction(isTouchEvent: Bool, event: Any, xCoordinate: Float64, yCoordinate: Float64) {
        if (this.mTouchMode == 1) {
            this.bubbleChartModel.disableScroll()
            let x: Float64 = if (this.bubbleChartModel.isDragXEnabled()) {
                xCoordinate - this.mTouchStartPoint.x
            } else {
                0.0
            }
            let y: Float64 = if (this.bubbleChartModel.isDragYEnabled()) {
                yCoordinate - this.mTouchStartPoint.y
            } else {
                0.0
            }
            this.performDrag(isTouchEvent, event, x, y)
        } else if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4) {
            this.bubbleChartModel.disableScroll()
            if ((this.bubbleChartModel.isScaleXEnabled() || this.bubbleChartModel.isScaleYEnabled()) && this.bubbleChartModel.isPinchZoomEnabled()) {
                this.performZoom(isTouchEvent, event)
                this.performHighlightDrag(isTouchEvent, event, false)
            }
        } else if ((this.mTouchMode == 0 || this.mTouchMode == 7)
            &&
            abs(
            BubbleChartTouchListener.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y)) > this.mDragTriggerDist) {
            touchMode0Or7(isTouchEvent, event, xCoordinate, yCoordinate)
        }

        // perform the transformation, update the chart
        this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            this.bubbleChartModel,
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
            if (this.bubbleChartModel.getLongPressCursorEnabled()) {
                this.calculateSwipe(touch(), isTouchEvent)
            }
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
            if (this.mTouchMode == 1 /* ChartTouchListener.DRAG*/ && this.bubbleChartModel.isDragDecelerationEnabled()) {
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
            this.bubbleChartModel.calculateOffsets()
        }

        this.mTouchMode = 0
        this.bubbleChartModel.enableScroll()

        this.endAction(isTouchEvent, event)

        if (gestureFingersCount >= 2) {
            this.mTouchMode = 5
        }
        this.saveTouchStart(isTouchEvent, event)
    }

    public func actionPinchUp(isTouchEvent: Bool, event: Any): Unit {
        this.mTouchMode = 5

        // perform the transformation, update the chart
        this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            this.bubbleChartModel,
            true
        )
    }

    public func actionCancel(isTouchEvent: Bool, event: Any): Unit {
        this.mTouchMode = 0
        this.endAction(isTouchEvent, event)
        // perform the transformation, update the chart
        this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(
            this.mMatrix,
            this.bubbleChartModel,
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

        this.mClosestDataSetToTouch = this.bubbleChartModel.getBubbleDataSetByTouchPoint(this.mTouchStartPoint.x, this.mTouchStartPoint.y)
    }

    /**
     * Performs all necessary operations needed for dragging.
     *
     * @param event
     */
    private func performDrag(isTouchEvent: Bool, event: Any, distanceX: Float64, distanceY: Float64) {
        this.mLastGesture = ChartGesture.DRAG

        this.mMatrix.set(this.mSavedMatrix)

        let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()

        var newDistanceY = distanceY
        // check if axis is inverted
        if (this.inverted()) {
            newDistanceY = -distanceY
        }

        this.mMatrix.postTranslate(distanceX, newDistanceY)

        if (let Some(listener) <- l) {
            listener.onChartTranslate(isTouchEvent, event, distanceX, distanceY)
        }
        this.bubbleChartModel.invalidate()
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

        let scaleX: Float64 = if (this.bubbleChartModel.isScaleXEnabled()) {
            scale
        } else {
            1.0
        }
        let scaleY: Float64 = if (this.bubbleChartModel.isScaleYEnabled()) {
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

        let xDist: Float64 = BubbleChartTouchListener.getXDist(isTouchEvent, event)
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

        let yDist: Float64 = BubbleChartTouchListener.getYDist(isTouchEvent, event)
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

            let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()

            // get the distance between the pointers of the touch event
            let totalDist: Float64 = BubbleChartTouchListener.spacing(isTouchEvent, event)

            if (totalDist > this.mMinScalePointerDistance) {

                // get the translation
                let t: MPPointF = this.getTrans(this.mTouchPointCenter.x, this.mTouchPointCenter.y)
                let h: ViewPortHandler = this.bubbleChartModel.getViewPortHandler()

                // take actions depending on the activated touch mode
                if (this.mTouchMode == 4 /* ChartTouchListener.PINCH_ZOOM*/ ) {
                    performZoomTouchModeIs4(totalDist, h, l, t, isTouchEvent, event)
                } else if (this.mTouchMode == 2 /*ChartTouchListener.X_ZOOM*/ && this.bubbleChartModel.isScaleXEnabled()) {
                    performZoomTouchModeIs2(h, isTouchEvent, event, t, l)
                } else if (this.mTouchMode == 3 /* ChartTouchListener.Y_ZOOM*/ && this.bubbleChartModel.isScaleYEnabled()) {
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
        let h: ?Highlight = this.bubbleChartModel.getHighlightByTouchPoint(xCoordinate, yCoordinate)
        if (!h.isNone()) {
        	if (mLastHighlighted.isNone()) {
        		this.mLastHighlighted = h
                this.bubbleChartModel.highlightValueForObject(mLastHighlighted, true)
        	} else if (!mLastHighlighted().equalTo(h())) {
                if (!isLongPressed) {
                    this.mLastHighlighted = h
                }
                this.bubbleChartModel.highlightValueForObject(
                    if (isLongPressed) {
                        this.mLastHighlighted
                    } else {
                        h
                    },
                    true
                )
        	} else {

        	}
        }
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
 //TODO
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
 //TODO
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
 //TODO
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
 //TODO
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
        let vph: ViewPortHandler = this.bubbleChartModel.getViewPortHandler()

        var xTrans: Float64 = x - vph.offsetLeft()
        var yTrans: Float64 = 0.0

        // check if axis is inverted
        if (this.inverted()) {
            yTrans = -(y - vph.offsetTop())
        } else {
            yTrans = -(this.bubbleChartModel.getHeight() - y - vph.offsetBottom())
        }

        return MPPointF.getInstance(xTrans, yTrans)
    }

    /**
     * Returns true if the current touch situation should be interpreted as inverted, false if not.
     *
     * @return
     */
    private func inverted(): Bool {
        return (this.mClosestDataSetToTouch.isNone() && this.bubbleChartModel.isAnyAxisInverted()) || (this.
            mClosestDataSetToTouch.isSome()
            && this.bubbleChartModel.isInverted(this.mClosestDataSetToTouch().getAxisDependency()))
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
 //TODO
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }

        this.mLastGesture = ChartGesture.DOUBLE_TAP

        let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartDoubleTapped(isTouchEvent, e)
        }
        let chartData = this.bubbleChartModel.getBubbleData()
        // check if double-tap zooming is enabled
        if (this.bubbleChartModel.isDoubleTapToZoomEnabled() && (chartData().getEntryCount() > 0)) {
            let trans: MPPointF = this.getTrans(x, y)

            let scaleX: Float64 = if (this.bubbleChartModel.isScaleXEnabled()) {
                1.4
            } else {
                1.0
            }
            let scaleY: Float64 = if (this.bubbleChartModel.isScaleYEnabled()) {
                1.4
            } else {
                1.0
            }

            this.bubbleChartModel.zoom(scaleX, scaleY, trans.x, trans.y, Option<AxisDependency>.None)

            if (this.bubbleChartModel.isLogEnabled()) {
                AppLog.info("BubblelineChartTouch:" + "Double-Tap, Zooming In, x: ${trans.x}, y: ${trans.y}")
            }

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, e, scaleX, scaleY)
            }

            MPPointF.recycleInstance(trans)
        }
    }

    public func onLongPressed(isTouchEvent: Bool, e: Any) {
        this.startAction(isTouchEvent, e)

//        this.mLongPressStatus = true
        this.mLastGesture = ChartGesture.LONG_PRESS

        let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartLongPressed(isTouchEvent, e)
        }

        if (!this.bubbleChartModel.isHighlightPerLongPressEnabled()) {
            return
        }
        this.bubbleChartModel.setLastGestureLongPress()
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
 //TODO
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }
        let h: ?Highlight = this.bubbleChartModel.getHighlightByTouchPoint(x, y)
        if (let Some(highlight) <- h) {
            if (!this.bubbleChartModel.getLongPressCursorEnabled()) {
            	this.performHighlight(highlight, Option<TouchEvent>.None)
            }
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
 //TODO
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

        let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartSingleTapped(isTouchEvent, e)
        }

        if (!this.bubbleChartModel.isHighlightPerTapEnabled()) {
            return
        }
        this.bubbleChartModel.setLastGestureSingleTap()
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
 //TODO
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }
        let h: ?Highlight = this.bubbleChartModel.getHighlightByTouchPoint(x, y)
        if (let Some(highlight) <- h) {
            if (!this.bubbleChartModel.getLongPressCursorEnabled()) {
                this.performHighlight(highlight, Option<TouchEvent>.None)
            }
        }

        this.actionUp(isTouchEvent, e)
    }

    public func onFling(isTouchEvent: Bool, e1: TouchEvent, e2: TouchEvent, velocityX: Float64, velocityY: Float64): Bool {
        this.mLastGesture = ChartGesture.FLING

        let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartFling(isTouchEvent, e1, e2, velocityX, velocityY)
        }

        return false
    }

    public func stopDeceleration() {
        this.mDecelerationVelocity.x = 0.0
        this.mDecelerationVelocity.y = 0.0
    }

    public func computeScroll(event: GestureEvent) {
        var angle = event.angle;
        angle = (angle * Float64.getPI()) / 180.0;
        var speedX = event.speed * cos(angle);
        var speedY = event.speed * sin(angle);
        if (speedX == 0.0 && speedY == 0.0) {
            return;
        }

        speedX *= this.bubbleChartModel.getDragDecelerationFrictionCoef() / 30.0;
        speedY *= this.bubbleChartModel.getDragDecelerationFrictionCoef() / 30.0;

        let dragDistanceX: Float64 =  if(this.bubbleChartModel.isDragXEnabled()) { speedX} else {0.0 }
        let dragDistanceY: Float64 = if(this.bubbleChartModel.isDragYEnabled()) {speedY }else { 0.0}

        let options: AnimatorOptions = AnimatorOptions(
            duration: 1000,
            easing: 'ease-out',
            delay: 0,
            fill: AnimatorFill.Forwards,
            direction: AnimatorDirection.Normal,
            iterations: 1,
            begin: 0.0,
            end: 1.0
        );

        if (let Some(animatorResult) <- this.animatorResult) {
            this.animatorIsPlaying = false;
            animatorResult.reset(options);
        } else {
            this.animatorResult = AnimatorResult(options);
        }

        this.animatorResult().onframe = {value: Float64 =>
            let x = (dragDistanceX * value);
            let y = (dragDistanceY * value);
            this.performDrag(false, event, x, y);
            this.mMatrix = this.bubbleChartModel.getViewPortHandler().refresh(this.mMatrix, this.bubbleChartModel, true);
        }

        this.animatorResult().onfinish = { =>
            this.animatorIsPlaying = false;
        }
        this.animatorResult().play();
        this.animatorIsPlaying = true;
    }

    private func calculateSwipe(event: TouchEvent, isTouchEvent: Bool) {
        this.mLongPressStatus = false
        let curPointX: Float64 = event.touches[0].x;
        let curPointY: Float64 = event.touches[0].y;
        if (this.downPointX != -1.0 && abs(curPointX - this.downPointX) <= 10.0) {
            let h: ?Highlight = this.bubbleChartModel.getHighlightByTouchPoint(curPointX, curPointY);
            if (let Some(highlight) <- h) {
                this.performHighlight(highlight, Option<TouchEvent>.None);
            }
            let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener();
            if (let Some(listener) <- l) {
            	listener.onChartMove(isTouchEvent, event);
            }
        } else if (this.downPointX != -1.0 && abs(curPointX - this.downPointX) >= 50.0) {
            let x: Float64 = if(this.bubbleChartModel.isDragXEnabled()) { curPointX - this.mTouchStartPoint.x}else {0.0 }
            let y: Float64 = if(this.bubbleChartModel.isDragYEnabled()) {curPointY - this.mTouchStartPoint.y }else { 0.0}
            this.bubbleChartModel.highlightValueForObject(Option<Highlight>.None, true);
            if (this.bubbleChartModel.getSwipeEnabled()) {
                this.performSwipe(true, event, x, y);
            }
        }
    }
    private func performSwipe(isTouchEvent: Bool, event: Any, distanceX: Float64, distanceY: Float64) {
        let l: ?OnChartGestureListener = this.bubbleChartModel.getOnChartGestureListener();
        if (let Some(listener) <- l) {
            listener.onChartTranslate(isTouchEvent, event, distanceX, distanceY);
        }
    }
}
