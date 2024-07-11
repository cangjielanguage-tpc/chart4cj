/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

public class PieRadarChartTouchListener< D, S, E> <: ChartTouchListener<D, S, E> where D <: ChartData<S,
    E>, S <: IDataSet<E>, E <: EntryOhos {
    private var mTouchStartPoint: MPPointF = MPPointF.getInstance(0.0, 0.0)
    /**
     * the angle where the dragging started
     */
    private var mStartAngle: Float64 = 0.0
    private var _velocitySamples: ArrayList<AngularVelocitySample> = ArrayList<AngularVelocitySample>()
    private var mDecelerationLastTime: Int64 = 0
    private var mDecelerationAngularVelocity: Float64 = 0.0
    var pieChart: PieRadarChartBaseModel<D, S, E>

    public init(chart: PieRadarChartBaseModel<D, S, E>) {
        super(chart)
        this.pieChart = chart
    }

    public func onSingleTapUp(isTouchEvent: Bool, e: Any) {
        this.actionDown(isTouchEvent, e)
        this.mLastGesture = ChartGesture.SINGLE_TAP

        let l: ?OnChartGestureListener = this.pieChart.getOnChartGestureListener()

        if (l.isSome()) {
            l().onChartSingleTapped(isTouchEvent, e)
        }

        if (!this.pieChart.isHighlightPerTapEnabled()) {
            return
        }
        var x: Float64 = 0.0
        var y: Float64 = 0.0
        if (isTouchEvent) {
            let touch = e as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return;
            }
            x = touch().touches[0].x
            y = touch().touches[0].y
        } else {
            let gesture = e as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return;
            }
            x = gesture().fingerList[0].localX
            y = gesture().fingerList[0].localY
        }
        let h: Highlight = this.pieChart.getHighlightByTouchPoint(x, y)()
        this.performHighlight(h, Option<TouchEvent>.None)

        this.actionUp(isTouchEvent, e)
    }

    public func actionDown(isTouchEvent: Bool, event: Any) {
        if (this.pieChart.isRotationEnabled()) {
            return
        }
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return;
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return;
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
        }

        this.startAction(isTouchEvent, event)

        this.stopDeceleration()

        this.resetVelocity()

        if (this.pieChart.isDragDecelerationEnabled()) {
            this.sampleVelocity(xCoordinate, yCoordinate)
        }

        this.setGestureStartAngle(xCoordinate, yCoordinate)
        this.mTouchStartPoint.x = xCoordinate
        this.mTouchStartPoint.y = yCoordinate
    }

    public func actionMove(isTouchEvent: Bool, event: Any) {
        if (!(this.pieChart as PieRadarChartBaseModel<D, S, E>)().isRotationEnabled()) {
            return
        }
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return;
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return;
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
        }
        if (this.pieChart.isDragDecelerationEnabled()) {
            this.sampleVelocity(xCoordinate, yCoordinate)
        }

        if (this.mTouchMode == 0 &&
            PieRadarChartTouchListener<D, S, E>.distance(xCoordinate, this.mTouchStartPoint.x, yCoordinate,
            this.mTouchStartPoint.y) > Utils.handleDataValues(8.0)) {
            this.mLastGesture = ChartGesture.ROTATE
            this.mTouchMode = 6
            this.pieChart.disableScroll()
        } else if (this.mTouchMode == 6) {
            this.updateGestureRotation(xCoordinate, yCoordinate)
            this.pieChart.invalidate()
        }

        this.endAction(isTouchEvent, event)
    }

    public func actionUp(isTouchEvent: Bool, event: Any) {
        var xCoordinate: Float64 = 0.0
        var yCoordinate: Float64 = 0.0
        if (isTouchEvent) {
            let touch = event as TouchEvent
            if (touch.isNone() || touch().touches.size == 0) {
                return;
            }
            xCoordinate = touch().touches[0].x
            yCoordinate = touch().touches[0].y
        } else {
            let gesture = event as GestureEvent
            if (gesture.isNone() || gesture().fingerList.size == 0) {
                return;
            }
            xCoordinate = gesture().fingerList[0].localX
            yCoordinate = gesture().fingerList[0].localY
        }
        if (this.pieChart.isDragDecelerationEnabled()) {
            this.stopDeceleration()

            this.sampleVelocity(xCoordinate, yCoordinate)

            this.mDecelerationAngularVelocity = this.calculateVelocity()

            if (this.mDecelerationAngularVelocity != 0.0) {
                this.mDecelerationLastTime = (DateTime.nowUTC().second * 1000)

                this.pieChart.invalidate()
            }
        }

        this.pieChart.enableScroll()
        this.mTouchMode = 0

        this.endAction(isTouchEvent, event)
    }

    public func actionCancel(isTouchEvent: Bool, event: Any) {
        this.mTouchMode = 0
        this.endAction(isTouchEvent, event)
    }

    public func actionPinchDown(isTouchEvent: Bool, event: Any) {
        throw UnsupportedException("Method not implemented.")
    }

    public func actionPinchUp(isTouchEvent: Bool, event: Any) {
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

        this._velocitySamples.append(
            AngularVelocitySample(
                currentTime,
                (this.pieChart as PieRadarChartBaseModel<D, S, E>)().getAngleForPoint(touchLocationX, touchLocationY)
            )
        )

        var count = this._velocitySamples.size
        // Remove samples older than our sample time - 1 seconds
        var i: Int64 = 0
        while (i < count - 2) {
            if (currentTime - this._velocitySamples.get(i)().time > 1000) {
                this._velocitySamples.remove(0)
                i--
                count--
            } else {
                break
            }
            i++
        }
    }

    public func setGestureStartAngle(x: Float64, y: Float64): Unit {
        this.mStartAngle = this.pieChart.getAngleForPoint(x, y) - this.pieChart.getRawRotationAngle()
    }

    public func updateGestureRotation(x: Float64, y: Float64): Unit {
        this.pieChart.setRotationAngle(this.pieChart.getAngleForPoint(x, y) - this.mStartAngle)
    }

    public func computeScroll(): Unit {
        if (this.mDecelerationAngularVelocity == 0.0) {
            return // There's no deceleration in progress
        }

        let currentTime = DateTime.nowUTC().second * 1000

        this.mDecelerationAngularVelocity *= this.pieChart.getDragDecelerationFrictionCoef()

        let timeInterval = (currentTime - this.mDecelerationLastTime) / 1000

        this.pieChart.setRotationAngle(
            this.pieChart.getRotationAngle() + this.mDecelerationAngularVelocity * Float64(timeInterval))

        this.mDecelerationLastTime = currentTime

        if (abs(this.mDecelerationAngularVelocity) >= 0.001) {
        } else {
            this.stopDeceleration()
        }
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

        // Calculate clockwise/ccw by choosing two values that should be closest to each other,
        // so if the angles are two far from each other we know they are inverted "for sure"
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
    public func onDoubleTap(isTouchEvent: Bool, event: Any): Unit {
        throw Exception("Method not implemented.")
    }

    public func onLongPressed(isTouchEvent: Bool, event: Any) {
        throw Exception("Method not implemented.")
    }

    public func onLongPressUp(isTouchEvent: Bool, event: Any) {
        throw Exception("Method not implemented.")
    }

    public func onLongPressCancel(isTouchEvent: Bool, event: Any) {
        throw Exception("Method not implemented.")
    }
}

class AngularVelocitySample {
    public var time: Int64 = 0
    public var angle: Float64 = 0.0

    init(time: Int64, angle: Float64) {
        this.time = time
        this.angle = angle
    }
}
