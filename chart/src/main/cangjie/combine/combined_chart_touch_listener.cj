/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine
import ohos.hilog.Hilog

public class CombinedChartTouchListener<: ChartTouchListener<CombinedData, IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos> {
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
    private var mClosestDataSetToTouch: ?IBarLineScatterCandleBubbleDataSet<EntryOhos> = None
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

    private var downTime: Int64 = 0
    private var downPointX: Float64 = -1.0
    private var downPointY: Float64 = -1.0
    private var maxSwipePointX: Float64 = -1.0
    private var maxSwipePointY: Float64 = -1.0
    private var animatorIsPlaying: Bool = false
    private var animatorResult: ?AnimatorResult = Option<AnimatorResult>.None

    var combinedChartModel: CombinedChartModel

    /**
     * Constructor with initialization parameters.
     *
     * @param chart               instance of the chart
     * @param touchMatrix         the touch-matrix of the chart
     * @param dragTriggerDistance the minimum movement distance that will be interpreted as a "drag" gesture in vp (3vp equals
     *                            to about 9 pixels on a 5.5" FHD screen)
     */
    public init(chart: CombinedChartModel, touchMatrix: Matrix, dragTriggerDistance: Float64) {
        super(chart)
        this.combinedChartModel = chart
        this.mMatrix = touchMatrix

        this.mDragTriggerDist = Utils.handleDataValues(dragTriggerDistance)

        this.mMinScalePointerDistance = Utils.handleDataValues(3.5)
    }

    public func onTouch(event: TouchEvent) {
        match (event.eventType) {
            case TouchType.Down => this.actionDown(true, event, Option<GestureEvent>.None)
            case TouchType.Move => this.actionMove(true, event, Option<GestureEvent>.None)
            case TouchType.Up => this.actionUp(true, event, Option<GestureEvent>.None)
            case TouchType.Cancel => this.actionUp(true, event, Option<GestureEvent>.None)
            case _ => ()
        }
    }

    public func actionDown(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        if (!this.combinedChartModel.isDragEnabled() && (!this.combinedChartModel.isScaleXEnabled() &&
            !this.combinedChartModel.isScaleYEnabled())) {
            return
        }
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            if (this.animatorResult.isSome() && this.animatorIsPlaying) {
                this.animatorResult().pause()
                this.animatorIsPlaying = false
            }
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                xCoordinate = touchEvent().touches[0].x
                yCoordinate = touchEvent().touches[0].y
            }

            // down initial value
            this.downTime = DateTime.now().nanosecond
            this.downPointX = xCoordinate
            this.downPointY = yCoordinate

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
            }

        }
        this.mStartPointX = xCoordinate
        this.mStartPointY = yCoordinate

        this.startAction(isTouchEvent, touchEvent, gestureEvent)
        this.stopDeceleration()
        this.saveTouchStart(isTouchEvent, touchEvent, gestureEvent)
    }

    public func actionPinchDown(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        this.combinedChartModel.disableScroll()
        this.saveTouchStart(true, touchEvent, gestureEvent)
        // get the distance between the pointers on the x-axis
        this.mSavedXDist = CombinedChartTouchListener.getXDist(isTouchEvent, touchEvent, gestureEvent)
        // get the distance between the pointers on the y-axis
        this.mSavedYDist = CombinedChartTouchListener.getYDist(isTouchEvent, touchEvent, gestureEvent)
        // get the total distance between the pointers
        this.mSavedDist = CombinedChartTouchListener.spacing(isTouchEvent, touchEvent, gestureEvent)
        if (this.mSavedDist > 10.0) {
            if (this.combinedChartModel.isPinchZoomEnabled()) {
                this.mTouchMode = 4 //ChartTouchListener.PINCH_ZOOM
            } else {
                if (this.combinedChartModel.isScaleXEnabled() != this.combinedChartModel.isScaleYEnabled()) {
                    this.mTouchMode = if (this.combinedChartModel.isScaleXEnabled()) {
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
            CombinedChartTouchListener.midPoint(this.mTouchPointCenter, isTouchEvent, touchEvent, gestureEvent)
        }
    }

    public func actionMove(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()
        if(let Some(listener) <- l) {
            if (this.combinedChartModel.getLongPressCursorEnabled()) {
                if (this.mLongPressStatus) {
                    listener.onChartMove(isTouchEvent, touchEvent, gestureEvent)
                }
            } else {
                listener.onChartMove(isTouchEvent, touchEvent, gestureEvent)
            }
        }

        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                xCoordinate = touchEvent().touches[0].x
                yCoordinate = touchEvent().touches[0].y
            }
            if (this.combinedChartModel.getLongPressCursorEnabled() && !this.mLongPressStatus) {
                this.calculateLongPress(touchEvent())
              }
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
            }
        }
        this.isDragging = false

        // long press cursor response capability
        if (this.combinedChartModel.getLongPressCursorEnabled()) {
            this.longPressCursorAction(isTouchEvent, touchEvent, gestureEvent, xCoordinate, yCoordinate)
            return
        }

         if (!this.combinedChartModel.getViewPortHandler().isInBounds(xCoordinate, yCoordinate)) {
            this.combinedChartModel.highlightValueForObject(Option<Highlight>.None, true)
        }

        if (this.mTouchMode == 1 /*ChartTouchListener.DRAG*/ ) {
            actionMoveTouchModeIs1(isTouchEvent, touchEvent, gestureEvent, xCoordinate, yCoordinate)
        } else if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4) {
            this.combinedChartModel.disableScroll()
            if (this.combinedChartModel.isScaleXEnabled() || this.combinedChartModel.isScaleYEnabled() && this.combinedChartModel.isPinchZoomEnabled()) {
                this.performZoom(isTouchEvent, touchEvent, gestureEvent)
            }
           // this.mMatrix = this.combinedChartModel.getViewPortHandler().refresh(this.mMatrix, this.combinedChartModel, true)
        } else if (this.mTouchMode == 0 &&
            abs(
            CombinedChartTouchListener.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y)) > this.mDragTriggerDist && this.combinedChartModel.getViewPortHandler().isInBounds(
            xCoordinate, yCoordinate)) {
            actionMoveTouchModeIs0(isTouchEvent, touchEvent, gestureEvent, xCoordinate, yCoordinate)
        }

        // perform the transformation, update the chart
        this.mMatrix = this.combinedChartModel.getViewPortHandler().refresh(this.mMatrix,this.combinedChartModel,true)
    }


    private func actionMoveTouchModeIs1(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, xCoordinate: Float64, yCoordinate: Float64): Unit {
        this.combinedChartModel.disableScroll()
        let x: Float64 = if (this.combinedChartModel.isDragXEnabled()) {
            xCoordinate - this.mTouchStartPoint.x
        } else {
            0.0
        }
        let y: Float64 = if (this.combinedChartModel.isDragYEnabled()) {
            yCoordinate - this.mTouchStartPoint.y
        } else {
            0.0
        }
        this.performDrag(isTouchEvent, touchEvent, gestureEvent, x, y)
    }

    private func actionMoveTouchModeIs0(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, xCoordinate: Float64, yCoordinate: Float64) {
        if (this.combinedChartModel.isDragEnabled()) {
            this.isDragging = true

            let shouldPan: Bool = !this.combinedChartModel.isFullyZoomedOut() || !this.combinedChartModel.hasNoDragOffset()
            if (shouldPan) {
                let distanceX: Float64 = abs(xCoordinate - this.mTouchStartPoint.x)
                let distanceY: Float64 = abs(yCoordinate - this.mTouchStartPoint.y)
                // Disable dragging in a direction that's disallowed
                if ((this.combinedChartModel.isDragXEnabled() || distanceY >= distanceX) && (this.combinedChartModel.
                    isDragYEnabled() || distanceY <= distanceX)) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.mTouchMode = 1
                }
            } else {
                if (this.combinedChartModel.isHighlightPerDragEnabled()) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.performHighlightDrag(isTouchEvent, touchEvent, gestureEvent, false)
                }
            }
        }
    }

    private func touchMode0Or71(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, xCoordinate: Float64, yCoordinate: Float64): Unit {
        if (this.combinedChartModel.isDragEnabled()) {
            this.isDragging = true

            let shouldPan: Bool = !this.combinedChartModel.isFullyZoomedOut() || !this.combinedChartModel.hasNoDragOffset()

            if (shouldPan && !this.mLongPressStatus) {
                let distanceX: Float64 = abs(xCoordinate - this.mTouchStartPoint.x)
                let distanceY: Float64 = abs(yCoordinate - this.mTouchStartPoint.y)
                // Disable dragging in a direction that's disallowed
                if ((this.combinedChartModel.isDragXEnabled() || distanceY >= distanceX) && (this.combinedChartModel.
                    isDragYEnabled() || distanceY <= distanceX)) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.mTouchMode = 1
                    this.combinedChartModel.highlightValueForObject(Option<Highlight>.None, true)
                }
            } else if (this.mLongPressStatus) {
                if (this.combinedChartModel.isHighlightPerDragEnabled()) {
                    this.mLastGesture = ChartGesture.DRAG
                    this.performHighlightDrag(isTouchEvent, touchEvent, gestureEvent, false)
                }
            } else if (!this.mLongPressStatus) {
                // response event of sliding left or right
                this.combinedChartModel.getOnChartGestureListener()?.onChartTranslate(isTouchEvent, touchEvent, gestureEvent,
                    xCoordinate - this.mStartPointX, yCoordinate - this.mStartPointY)
            }
        }
    }
    private func longPressCursorAction(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, xCoordinate: Float64, yCoordinate: Float64) {
        if (this.mTouchMode == 1) {
            this.combinedChartModel.disableScroll()
            let x: Float64 = if (this.combinedChartModel.isDragXEnabled()) {
                xCoordinate - this.mTouchStartPoint.x
            } else {
                0.0
            }
            let y: Float64 = if (this.combinedChartModel.isDragYEnabled()) {
                yCoordinate - this.mTouchStartPoint.y
            } else {
                0.0
            }
            if (!this.combinedChartModel.getSwipeEnabled()) {
                this.combinedChartModel.highlightValueForObject(Option<Highlight>.None, true)
            }
            this.performDrag(isTouchEvent, touchEvent, gestureEvent, x, y)
        } else if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4) {
            this.combinedChartModel.disableScroll()
            if (this.combinedChartModel.isScaleXEnabled() || this.combinedChartModel.isScaleYEnabled()) {
                this.performZoom(isTouchEvent, touchEvent, gestureEvent)
                this.combinedChartModel.highlightValueForObject(Option<Highlight>.None, true)
                this.performHighlightDrag(isTouchEvent, touchEvent, gestureEvent, false)
            }
        } else if ((this.mTouchMode == 0 || this.mTouchMode == 7)&&abs(CombinedChartTouchListener.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y)) > this.mDragTriggerDist) {
                touchMode0Or71(isTouchEvent, touchEvent, gestureEvent, xCoordinate, yCoordinate)
        }

        // perform the transformation, update the chart
        this.mMatrix = this.combinedChartModel.getViewPortHandler().refresh(this.mMatrix,this.combinedChartModel,true)
    }

    private func calculateLongPress(event: TouchEvent): Unit {
        let curTime: Int64 = DateTime.now().nanosecond
        if (this.downTime > 0 && this.downPointX != -1.0 && (curTime - this.downTime) >= this.combinedChartModel.getLongPressDuration()) {
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
                this.resetSwipeParam()
                let h: ?Highlight = this.combinedChartModel.getHighlightByTouchPoint(curPointX, curPointY)
                if (let Some(highlight) <- h) {
                    this.performHighlight(highlight, Option<TouchEvent>.None)
                }
            }
        }
    }

    private func calculateSwipe(event: TouchEvent, isTouchEvent: Bool): Unit {
        this.mLongPressStatus = false
        let curPointX: Float64 = event.touches[0].x
        let curPointY: Float64 = event.touches[0].y
        if (this.downPointX != -1.0 && abs(curPointX - this.downPointX) <= 10.0) {
            let h: ?Highlight = this.combinedChartModel.getHighlightByTouchPoint(curPointX, curPointY)
            if (let Some(highlight) <- h) {
                this.performHighlight(highlight, Option<TouchEvent>.None)
            }
            let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()
            l?.onChartMove(isTouchEvent, event, Option<GestureEvent>.None)
        } else if (this.downPointX != -1.0 && abs(curPointX - this.downPointX) >= 50.0) {
            let x: Float64 = if(this.combinedChartModel.isDragXEnabled()) { curPointX - this.mTouchStartPoint.x}else {0.0 }
            let y: Float64 = if(this.combinedChartModel.isDragYEnabled()) {curPointY - this.mTouchStartPoint.y }else { 0.0}
            this.combinedChartModel.highlightValueForObject(Option<Highlight>.None, true)
            if (this.combinedChartModel.getSwipeEnabled()) {
                this.performSwipe(true, event, Option<GestureEvent>.None, x, y)
            }
        }
        this.resetSwipeParam()
    }

    private func resetSwipeParam(): Unit {
        this.downTime = 0
        this.downPointX = -1.0
        this.downPointY = -1.0
        this.maxSwipePointX = -1.0
        this.maxSwipePointY = -1.0
    }


    public func actionUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        var gestureFingersCount: Int64 = 1
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                xCoordinate = touchEvent().touches[0].x
                yCoordinate = touchEvent().touches[0].y
                gestureFingersCount = touchEvent().touches.size
            }

            if (this.combinedChartModel.getLongPressCursorEnabled()) {
                this.calculateSwipe(touchEvent(), isTouchEvent)
            }
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
                gestureFingersCount = gestureEvent().fingerList.size
            }

        }

        if (abs(xCoordinate) > Float64(Utils.getMinimumFlingVelocity()) || abs(yCoordinate) > Float64(Utils.
                getMinimumFlingVelocity())) {
            if (this.mTouchMode == 1 /* ChartTouchListener.DRAG*/ && this.combinedChartModel.isDragDecelerationEnabled()) {
                this.stopDeceleration()

                this.mDecelerationLastTime = DateTime.now().nanosecond

                this.mDecelerationCurrentPoint.x = xCoordinate
                this.mDecelerationCurrentPoint.y = yCoordinate
            }
        }

        if (this.mTouchMode == 2 || this.mTouchMode == 3 || this.mTouchMode == 4 || this.mTouchMode == 5) {
            this.combinedChartModel.calculateOffsets()
        }

        this.mTouchMode = 0
        this.combinedChartModel.enableScroll()

        this.endAction(isTouchEvent, touchEvent, gestureEvent)

        if (gestureFingersCount >= 2) {
            this.mTouchMode = 5
        }
        this.saveTouchStart(isTouchEvent, touchEvent, gestureEvent)
    }

    public func actionPinchUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        this.mTouchMode = 5

        // perform the transformation, update the chart
        this.mMatrix = this.combinedChartModel.getViewPortHandler().refresh(this.mMatrix, this.combinedChartModel, true)
    }

    public func actionCancel(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        this.mTouchMode = 0
        this.endAction(isTouchEvent, touchEvent, gestureEvent)
        // perform the transformation, update the chart
        this.mMatrix = this.combinedChartModel.getViewPortHandler().refresh(this.mMatrix,this.combinedChartModel,true)
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
    private func saveTouchStart(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.mSavedMatrix.set(this.mMatrix)
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                this.mTouchStartPoint.x = touchEvent().touches[0].x
                this.mTouchStartPoint.y = touchEvent().touches[0].y
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                this.mTouchStartPoint.x = gestureEvent().fingerList[0].globalX
                this.mTouchStartPoint.y = gestureEvent().fingerList[0].globalY
            }

        }

        this.mClosestDataSetToTouch = this.combinedChartModel.getCombinedDataSetByTouchPoint(this.mTouchStartPoint.x,this.mTouchStartPoint.y)
    }

    private func performSwipe(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, distanceX: Float64, distanceY: Float64) {
        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()
        if (let Some(listener) <- l) {
            listener.onChartTranslate(isTouchEvent, touchEvent, gestureEvent, distanceX, distanceY)
        }
    }

    /**
     * Performs all necessary operations needed for dragging.
     *
     * @param event
     */
    private func performDrag(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, distanceX: Float64, distanceY: Float64) {
        this.mLastGesture = ChartGesture.DRAG

        this.mMatrix.set(this.mSavedMatrix)

        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()

        var newDistanceY = distanceY
        // check if axis is inverted
        if (this.inverted()) {
            newDistanceY = -distanceY
        }

        if (let Some(listener) <- l) {
            listener.onChartTranslate(isTouchEvent, touchEvent, gestureEvent, distanceX, distanceY)
        }
        this.mMatrix.postTranslate(distanceX, newDistanceY)
        //this.combinedChartModel.invalidate()
    }

    private func performZoomTouchModeIs4(totalDist: Float64, h: ViewPortHandler, l: ?OnChartGestureListener,
        t: MPPointF, isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
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

        let scaleX: Float64 = if (this.combinedChartModel.isScaleXEnabled()) {
            scale
        } else {
            1.0
        }
        let scaleY: Float64 = if (this.combinedChartModel.isScaleYEnabled()) {
            scale
        } else {
            1.0
        }

        if (canZoomMoreY || canZoomMoreX) {
            this.mMatrix.set(this.mSavedMatrix)
            this.mMatrix.postScale(scaleX, scaleY, centerX: t.x, centerY: t.y)

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, touchEvent, gestureEvent, scaleX, scaleY)
            }
        }
    }

    private func performZoomTouchModeIs2(h: ViewPortHandler, isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, t: MPPointF,
        l: ?OnChartGestureListener) {
        this.mLastGesture = ChartGesture.X_ZOOM

        let xDist: Float64 = CombinedChartTouchListener.getXDist(isTouchEvent, touchEvent, gestureEvent)
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
                listener.onChartScale(isTouchEvent, touchEvent, gestureEvent, scaleX, 1.0)
            }
        }
    }

    private func performZoomTouchModeIs3(totalDist: Float64, h: ViewPortHandler, l: ?OnChartGestureListener,
        t: MPPointF, isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.mLastGesture = ChartGesture.Y_ZOOM

        let yDist: Float64 = CombinedChartTouchListener.getYDist(isTouchEvent, touchEvent, gestureEvent)
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
                listener.onChartScale(isTouchEvent, touchEvent, gestureEvent, 1.0, scaleY)
            }
        }
    }
    /**
     * Performs the all operations necessary for pinch and axis zoom.
     *
     * @param event
     */
    private func performZoom(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        var gestureFingersCount: Int64 = 1
        if (isTouchEvent) {
            gestureFingersCount = touchEvent().touches.size
        } else {
            gestureFingersCount = gestureEvent().fingerList.size
        }
        if (gestureFingersCount >= 2) { // two finger zoom

            let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()

            // get the distance between the pointers of the touch event
            let totalDist: Float64 = CombinedChartTouchListener.spacing(isTouchEvent, touchEvent, gestureEvent)

            if (totalDist > this.mMinScalePointerDistance) {

                // get the translation
                let t: MPPointF = this.getTrans(this.mTouchPointCenter.x, this.mTouchPointCenter.y)
                let h: ViewPortHandler = this.combinedChartModel.getViewPortHandler()

                // take actions depending on the activated touch mode
                if (this.mTouchMode == 4 /* ChartTouchListener.PINCH_ZOOM*/ ) {
                    performZoomTouchModeIs4(totalDist, h, l, t, isTouchEvent, touchEvent, gestureEvent)
                } else if (this.mTouchMode == 2 /*ChartTouchListener.X_ZOOM*/ && this.combinedChartModel.isScaleXEnabled()) {
                    performZoomTouchModeIs2(h, isTouchEvent, touchEvent, gestureEvent, t, l)
                } else if (this.mTouchMode == 3 /* ChartTouchListener.Y_ZOOM*/ && this.combinedChartModel.isScaleYEnabled()) {
                    performZoomTouchModeIs3(totalDist, h, l, t, isTouchEvent, touchEvent, gestureEvent)
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
    func performHighlightDrag(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, isLongPressed: Bool) {
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                xCoordinate = touchEvent().touches[0].x
                yCoordinate = touchEvent().touches[0].y
            }
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
            }
        }
        let h: ?Highlight = this.combinedChartModel.getHighlightByTouchPoint(xCoordinate, yCoordinate)
        if(h.isSome() && this.mLastHighlighted.isSome() && !h().equalTo(this.mLastHighlighted())) {
            if (!isLongPressed) {
                this.mLastHighlighted = h
            }
            this.combinedChartModel.highlightValueForObject(
                if (isLongPressed) {
                    this.mLastHighlighted
                } else {
                    h
                },
                true
            )
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
    private static func midPoint(point: MPPointF, isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        var x: Float64 = 0.0
        var y: Float64 = 0.0

        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                x = touchEvent().touches[0].x + touchEvent().touches[1].x
                y = touchEvent().touches[0].y + touchEvent().touches[1].y
            }
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                x = gestureEvent().fingerList[0].localX + gestureEvent().fingerList[1].localX
                y = gestureEvent().fingerList[0].localY + gestureEvent().fingerList[1].localY
            }

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
    private static func spacing(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Float64 {
        var x: Float64 = 0.0
        var y: Float64 = 0.0

        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return 0.0
            } else {
                x = touchEvent().touches[0].x - touchEvent().touches[1].x
                y = touchEvent().touches[0].y - touchEvent().touches[1].y
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return 0.0
            } else {
                x = gestureEvent().fingerList[0].localX - gestureEvent().fingerList[1].localX
                y = gestureEvent().fingerList[0].localY - gestureEvent().fingerList[1].localY
            }

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
    private static func getXDist(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Float64 {
        var x: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return 0.0
            } else {
                x = abs(touchEvent().touches[0].x - touchEvent().touches[1].x)
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return 0.0
            } else {
                x = abs(gestureEvent().fingerList[0].localX - gestureEvent().fingerList[1].localX)
            }

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
    private static func getYDist(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Float64 {
        var y: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return 0.0
            } else {
                y = abs(touchEvent().touches[0].y - touchEvent().touches[1].y)
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return 0.0
            } else {
                y = abs(gestureEvent().fingerList[0].localY - gestureEvent().fingerList[1].localY)
            }

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
        let vph: ViewPortHandler = this.combinedChartModel.getViewPortHandler()

        var xTrans: Float64 = x - vph.offsetLeft()
        var yTrans: Float64 = 0.0

        // check if axis is inverted
        if (this.inverted()) {
            yTrans = -(y - vph.offsetTop())
        } else {
            yTrans = -(this.combinedChartModel.getHeight() - y - vph.offsetBottom())
        }

        return MPPointF.getInstance(xTrans, yTrans)
    }

    /**
     * Returns true if the current touch situation should be interpreted as inverted, false if not.
     *
     * @return
     */
    private func inverted(): Bool {
        return (this.mClosestDataSetToTouch.isNone() && this.combinedChartModel.isAnyAxisInverted()) || (this.
            mClosestDataSetToTouch.isSome()
            && this.combinedChartModel.isInverted(this.mClosestDataSetToTouch().getAxisDependency()))
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

    public func onDoubleTap(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                x = touchEvent().touches[0].x
                y = touchEvent().touches[0].y
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                x = gestureEvent().fingerList[0].localX
                y = gestureEvent().fingerList[0].localY
            }

        }

        this.mLastGesture = ChartGesture.DOUBLE_TAP

        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartDoubleTapped(isTouchEvent, touchEvent, gestureEvent)
        }
        let chartData = this.combinedChartModel.getCombinedData()
        // check if double-tap zooming is enabled
        if (this.combinedChartModel.isDoubleTapToZoomEnabled() && chartData.isSome() && chartData().getEntryCount() > 0) {
            let trans: MPPointF = this.getTrans(x, y)

            let scaleX: Float64 = if (this.combinedChartModel.isScaleXEnabled()) {
                1.4
            } else {
                1.0
            }
            let scaleY: Float64 = if (this.combinedChartModel.isScaleYEnabled()) {
                1.4
            } else {
                1.0
            }

            this.combinedChartModel.zoom(scaleX, scaleY, trans.x, trans.y, Option<AxisDependency>.None)

            if (this.combinedChartModel.isLogEnabled()) {
                AppLog.info("combinedlineChartTouch:" + "Double-Tap, Zooming In, x: ${trans.x}, y: ${trans.y}")
            }

            if (let Some(listener) <- l) {
                listener.onChartScale(isTouchEvent, touchEvent, gestureEvent, scaleX, scaleY)
            }

            MPPointF.recycleInstance(trans)
        }
    }

    public func onLongPressed(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.startAction(isTouchEvent, touchEvent, gestureEvent)

        this.mLastGesture = ChartGesture.LONG_PRESS

        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartLongPressed(isTouchEvent, touchEvent, gestureEvent)
        }

        if (!this.combinedChartModel.isHighlightPerLongPressEnabled()) {
            return
        }
        this.combinedChartModel.setLastGestureLongPress()
        this.mTouchMode = 7 /* ChartTouchListener.LONG_PRESS*/

        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                x = touchEvent().touches[0].x
                y = touchEvent().touches[0].y
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            }
            x = gestureEvent().fingerList[0].localX
            y = gestureEvent().fingerList[0].localY
        }
        let h: ?Highlight = this.combinedChartModel.getHighlightByTouchPoint(x, y)
        if (let Some(highlight) <- h) {
            if (!this.combinedChartModel.getLongPressCursorEnabled()) {
                this.performHighlight(highlight, Option<TouchEvent>.None)
            }

        }
    }

    public func getXyByEvent(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): (Float64, Float64) {
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return (0.0, 0.0)
            } else {
                x = touchEvent().touches[0].x
                y = touchEvent().touches[0].y
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return (0.0, 0.0)
            }
            x = gestureEvent().fingerList[0].localX
            y = gestureEvent().fingerList[0].localY
        }
        return (x, y)
    }

    public func onLongPressUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.mLastGesture = ChartGesture.LONG_PRESS
        this.endAction(isTouchEvent, touchEvent, gestureEvent)
    }

    public func onLongPressCancel(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.mLastGesture = ChartGesture.LONG_PRESS
        this.endAction(isTouchEvent, touchEvent, gestureEvent)
    }

    public func onSingleTapUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        this.actionDown(isTouchEvent, touchEvent, gestureEvent)
        this.mLastGesture = ChartGesture.SINGLE_TAP

        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartSingleTapped(isTouchEvent, touchEvent, gestureEvent)
        }

        if (!this.combinedChartModel.isHighlightPerTapEnabled()) {
            return
        }
        this.combinedChartModel.setLastGestureSingleTap()
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            } else {
                x = touchEvent().touches[0].x
                y = touchEvent().touches[0].y
            }

        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            }
            x = gestureEvent().fingerList[0].localX
            y = gestureEvent().fingerList[0].localY
        }

        let h: ?Highlight = this.combinedChartModel.getHighlightByTouchPoint(x, y)

        if (let Some(highlight) <- h) {
            if (!this.combinedChartModel.getLongPressCursorEnabled()) {
                this.performHighlight(highlight, Option<TouchEvent>.None)
            }

        }

        this.actionUp(isTouchEvent, touchEvent, gestureEvent)
    }

    public func onFling(isTouchEvent: Bool, e1: TouchEvent, e2: TouchEvent, velocityX: Float64, velocityY: Float64): Bool {
        this.mLastGesture = ChartGesture.FLING

        let l: ?OnChartGestureListener = this.combinedChartModel.getOnChartGestureListener()

        if (let Some(listener) <- l) {
            listener.onChartFling(isTouchEvent, e1, Option<GestureEvent>.None, e2, velocityX, velocityY)
        }

        return false
    }

    public func stopDeceleration() {
        this.mDecelerationVelocity.x = 0.0
        this.mDecelerationVelocity.y = 0.0
    }

    public func computeScroll(event: GestureEvent) {
        var angle = event.angle
        angle = (angle * Float64.getPI()) / 180.0
        var speedX = event.speed * cos(angle)
        var speedY = event.speed * sin(angle)
        if (speedX == 0.0 && speedY == 0.0) {
            return
        }

        speedX *= this.combinedChartModel.getDragDecelerationFrictionCoef() / 30.0
        speedY *= this.combinedChartModel.getDragDecelerationFrictionCoef() / 30.0

        let dragDistanceX: Float64 =  if(this.combinedChartModel.isDragXEnabled()) { speedX} else {0.0 }
        let dragDistanceY: Float64 = if(this.combinedChartModel.isDragYEnabled()) {speedY }else { 0.0}

        let options: AnimatorOptions = AnimatorOptions(
            duration: 1000,
            easing: 'ease-out',
            delay: 0,
            fill: AnimatorFill.Forwards,
            direction: AnimatorDirection.Normal,
            iterations: 1,
            begin: 0.0,
            end: 1.0
        )

        if (let Some(animatorResult) <- this.animatorResult) {
            this.animatorIsPlaying = false
            animatorResult.reset(options)
        } else {
            this.animatorResult = AnimatorResult(options)
        }

        this.animatorResult().onframe = {value: Float64 =>
            let x = (dragDistanceX * value)
            let y = (dragDistanceY * value)
            this.performDrag(false, Option<TouchEvent>.None , event, x, y)
            this.mMatrix = this.combinedChartModel.getViewPortHandler().refresh(this.mMatrix, this.combinedChartModel, true)
        }

        this.animatorResult().onfinish = { =>
            this.animatorIsPlaying = false
        }
        this.animatorResult().play()
        this.animatorIsPlaying = true
    }
}
