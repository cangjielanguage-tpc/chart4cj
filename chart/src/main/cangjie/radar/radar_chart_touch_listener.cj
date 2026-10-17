/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class RadarChartTouchListener <: ChartTouchListener<RadarData, IRadarDataSet, RadarEntry> {
    private var mTouchStartPoint: MPPointF = MPPointF.getInstance(0.0, 0.0)
    /**
     * the angle where the dragging started
     */
    private var mStartAngle: Float64 = 0.0
    private var _velocitySamples: ArrayList<AngularVelocitySample> = ArrayList<AngularVelocitySample>()
    private var mDecelerationLastTime: Int64 = 0
    private var mDecelerationAngularVelocity: Float64 = 0.0
    private var animatorIsPlaying: Bool = false
    private var animatorResult: ?AnimatorResult  = Option<AnimatorResult>.None
    private var prevAngle: Float64 = 0.0
    var radarChartModel: RadarChartModel

    public init(chart: RadarChartModel) {
        super(chart)
        this.radarChartModel = chart
    }

    public func onSingleTapUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.actionDown(isTouchEvent, touchEvent, gestureEvent)
        this.radarChartModel.setLastGestureSingleTap()

        let l: ?OnChartGestureListener = this.radarChartModel.getOnChartGestureListener()

        if (l.isSome()) {
            l().onChartSingleTapped(isTouchEvent, touchEvent, gestureEvent)
        }

        if (!this.radarChartModel.isHighlightPerTapEnabled()) {
            return
        }
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            }
            x = touchEvent().touches[0].x
            y = touchEvent().touches[0].y
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                x = gestureEvent().fingerList[0].localX
                y = gestureEvent().fingerList[0].localY
            }
        }
        let highlight: ?Highlight = this.radarChartModel.getHighlightByTouchPoint(x, y)
        if(let Some(h) <- highlight) {
            this.performHighlight(h, Option<TouchEvent>.None)
        }

        this.actionUp(isTouchEvent, touchEvent, gestureEvent)
    }

    public func actionDown(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        if (this.radarChartModel.isRotationEnabled()) {
            return
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

        }else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
            }
        }

        this.startAction(isTouchEvent, touchEvent, gestureEvent)

        this.stopDeceleration()

        this.resetVelocity()

        if (this.radarChartModel.isDragDecelerationEnabled()) {
            this.sampleVelocity(xCoordinate, yCoordinate)
        }

        this.setGestureStartAngle(xCoordinate, yCoordinate)
        this.mTouchStartPoint.x = xCoordinate
        this.mTouchStartPoint.y = yCoordinate

        this.prevAngle = this.calculateAngle(xCoordinate, yCoordinate)
    }

    public func actionMove(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        if (!this.radarChartModel.isRotationEnabled()) {
            return
        }
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            }
            xCoordinate = touchEvent().touches[0].x
            yCoordinate = touchEvent().touches[0].y
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
            }
        }
        if (this.radarChartModel.isDragDecelerationEnabled()) {
            this.sampleVelocity(xCoordinate, yCoordinate)
        }

        if (this.mTouchMode == 0 && RadarChartTouchListener.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y) > Utils.handleDataValues(8.0)) {
            this.mLastGesture = ChartGesture.ROTATE
            this.mTouchMode = 6
            this.radarChartModel.disableScroll()
        } else if (this.mTouchMode == 6) {
            this.updateGestureRotation(xCoordinate, yCoordinate)
            this.radarChartModel.invalidate()
        }

        this.endAction(isTouchEvent, touchEvent, gestureEvent)
    }

    public func actionUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            if (touchEvent.isNone() || touchEvent().touches.size == 0) {
                return
            }
            xCoordinate = touchEvent().touches[0].x
            yCoordinate = touchEvent().touches[0].y
        } else {
            if (gestureEvent.isNone() || gestureEvent().fingerList.size == 0) {
                return
            } else {
                xCoordinate = gestureEvent().fingerList[0].localX
                yCoordinate = gestureEvent().fingerList[0].localY
            }
        }
        if (this.radarChartModel.isDragDecelerationEnabled()) {
            this.stopDeceleration()

            this.sampleVelocity(xCoordinate, yCoordinate)

            this.mDecelerationAngularVelocity = this.calculateVelocity()

            if (this.mDecelerationAngularVelocity != 0.0) {
                this.mDecelerationLastTime = (DateTime.nowUTC().second * 1000)

                this.radarChartModel.invalidate()
            }
        }

        this.radarChartModel.enableScroll()
        this.mTouchMode = 0

        this.endAction(isTouchEvent, touchEvent, gestureEvent)
    }

    public func actionCancel(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        this.mTouchMode = 0
        this.endAction(isTouchEvent, touchEvent, gestureEvent)
    }

    public func actionPinchDown(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        throw UnsupportedException("Method not implemented.")
    }

    public func actionPinchUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        throw UnsupportedException("Method not implemented.")
    }

    public func stopDeceleration() {
        this.mDecelerationAngularVelocity = 0.0
    }

    private func resetVelocity() {
        this._velocitySamples.clear()
    }

    private func sampleVelocity(touchLocationX: Float64, touchLocationY: Float64): Unit {
        let currentTime: Int64 = DateTime.nowUTC().second

        this._velocitySamples.add(
            AngularVelocitySample(currentTime,this.radarChartModel.getAngleForPoint(touchLocationX, touchLocationY))
        )

        var count = this._velocitySamples.size
        // Remove samples older than our sample time - 1 seconds
        var i: Int64 = 0
        while (i < count - 2) {
            if (currentTime - this._velocitySamples.get(i)().time > 1000) {
                this._velocitySamples.remove(at: 0)
                i--
                count--
            } else {
                break
            }
            i++
        }
    }

    public func setGestureStartAngle(x: Float64, y: Float64): Unit {
        this.mStartAngle = this.radarChartModel.getAngleForPoint(x, y) - this.radarChartModel.getRawRotationAngle()
    }

    public func updateGestureRotation(x: Float64, y: Float64): Unit {
        this.radarChartModel.setRotationAngle(this.radarChartModel.getAngleForPoint(x, y) - this.mStartAngle)
    }

    public func computeScroll(event: GestureEvent): Unit {
        let xCoordinate: Float64 = event.fingerList[0].localX
        let yCoordinate: Float64 = event.fingerList[0].localY
        let currentAngle: Float64 = this.radarChartModel.getRotationAngle()
        var angleDiff: Float64 = this.calculateAngle(xCoordinate, yCoordinate) - this.prevAngle
        if (angleDiff < -180.0) {
          angleDiff += 360.0
        }
        if (angleDiff > 180.0) {
          angleDiff -= 360.0
        }
        let end = if(angleDiff > 0.0) { currentAngle + (event.speed / 30.0)} else {  currentAngle - (event.speed / 30.0)}

        let options: AnimatorOptions = AnimatorOptions(
            duration: 1000,
            easing: 'ease-out',
            delay: 0,
            fill: AnimatorFill.Forwards,
            direction: AnimatorDirection.Normal,
            iterations: 1,
            begin: currentAngle,
            end: end
        )

        if (let Some(animatorResult) <- this.animatorResult) {
            this.animatorIsPlaying = false
            animatorResult.reset(options)
        } else {
            this.animatorResult = AnimatorResult(options)
        }

        this.animatorResult().onframe = {value: Float64 =>
            this.radarChartModel.setRotationAngle(value)
            this.radarChartModel.invalidate()
        }

        this.animatorResult().onfinish = { =>
            this.animatorIsPlaying = false
        }
        this.animatorResult().play()
        this.animatorIsPlaying = true
    }

    private func calculateAngle(x: Float64, y: Float64): Float64 {
    // 计算触摸点相对于圆心的角度（0-360度）
        let angleRadians = atan2(y - this.radarChartModel.getHeight() / 2.0, x - this.radarChartModel.getWidth() / 2.0)
        var angleDegrees = angleRadians * (180.0 / Float64.getPI())
        if (angleDegrees < 0.0) {
            angleDegrees += 360.0 // 将负角度转换为0-360度范围
        }
        return angleDegrees
    }

    private func calculateVelocity(): Float64 {
        if (this._velocitySamples.isEmpty()) {
            return 0.0
        }

        let firstSample: AngularVelocitySample = this._velocitySamples.get(0)()
        let lastSample: AngularVelocitySample = this._velocitySamples.get(this._velocitySamples.size - 1)()

        // Look for a sample that's closest to the latest sample, but not the same, so we can deduce the direction
        var beforeLastSample: AngularVelocitySample = firstSample
        for (i in (this._velocitySamples.size - 1)..0) {
            beforeLastSample = this._velocitySamples.get(i)()
            if (beforeLastSample.angle != lastSample.angle) {
                break
            }
        }

        // Calculate the sampling time
        var timeDelta: Float64 = Float64(lastSample.time - firstSample.time) / 1000.0
        if (timeDelta == 0.0) {
            timeDelta = 0.1
        }

        var clockwise: Bool = lastSample.angle >= beforeLastSample.angle
        if (abs(lastSample.angle - beforeLastSample.angle) > 270.0) {
            clockwise = !clockwise
        }

        // Now if the "gesture" is over a too big of an angle - then we know the angles are inverted, and we need to move them closer to each other from both sides of the 360.0 wrapping point
        if (lastSample.angle - firstSample.angle > 180.0) {
            firstSample.angle += 360.0
        } else if (firstSample.angle - lastSample.angle > 180.0) {
            lastSample.angle += 360.0
        }

        // The velocity
        var velocity: Float64 = abs((lastSample.angle - firstSample.angle) / timeDelta)

        // Direction?
        if (!clockwise) {
            velocity = -velocity
        }

        return velocity
    }
    public func onDoubleTap(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit {
        throw Exception("Method not implemented.")
    }

    public func onLongPressed(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        throw Exception("Method not implemented.")
    }

    public func onLongPressUp(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        throw Exception("Method not implemented.")
    }

    public func onLongPressCancel(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) {
        throw Exception("Method not implemented.")
    }
}
