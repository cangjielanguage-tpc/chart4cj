/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public class PieChartRenderer <: DataRenderer {
    protected var mChart: PieChartModel
    /**
     * paint for the hole in the center of the pie chart and the transparent
     * circle
     */
    protected var mHolePaint: ChartPaint
    protected var mTransparentCirclePaint: ChartPaint
    protected var mValueLinePaint: ChartPaint
    /**
     * paint object for the text that can be displayed in the center of the
     * chart`
     */
    private var mCenterTextPaint: TextPaint
    /**
     * paint object used for drwing the slice-text
     */
    private var mEntryLabelsPaint: ChartPaint
    private var mCenterTextLayout: String = ""
    /*StaticLayout*/
    private var mCenterTextLastValue: String = ""
    /*CharSequence*/
    private var mCenterTextLastBounds: MyRect = MyRect()
    private var mRectBuffer: Array<MyRect> = [MyRect(), MyRect(), MyRect()]
    /**
     * Bitmap for drawing the center hole
     */
    protected var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    protected var mBitmapCanvas: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings)

    public init(chart: PieChartModel, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart
        this.mHolePaint = ChartPaint()
        this.mHolePaint.setColor(Color.WHITE)
        this.mHolePaint.setStyle(Style.FILL)
        this.mTransparentCirclePaint = ChartPaint()
        this.mTransparentCirclePaint.setColor(Color.WHITE)
        this.mTransparentCirclePaint.setStyle(Style.FILL)
        this.mTransparentCirclePaint.setGlobalAlpha(105.0 / 255.0)
        this.mCenterTextPaint = TextPaint()
        this.mCenterTextPaint.setColor(Color.BLACK)
        this.mCenterTextPaint.setTextSize(Utils.handleDataValues(12.0))

        this.mValuePaint.setTextSize(Utils.handleDataValues(13.0))
        this.mValuePaint.setColor(Color.WHITE)
        this.mValuePaint.setTextAlign(TextAlignStyle.Center)
        this.mEntryLabelsPaint = ChartPaint()
        this.mEntryLabelsPaint.setColor(Color.WHITE)
        this.mEntryLabelsPaint.setTextAlign(TextAlignStyle.Center)
        this.mEntryLabelsPaint.setTextSize(Utils.handleDataValues(13.0))
        this.mValueLinePaint = ChartPaint()
        this.mValueLinePaint.setStyle(Style.STROKE)
    }

    public func getPaintHole() {
        return this.mHolePaint
    }

    public func getPaintTransparentCircle(): ChartPaint {
        return this.mTransparentCirclePaint
    }

    public func getPaintCenterText(): TextPaint {
        return this.mCenterTextPaint
    }

    public func getPaintEntryLabels(): ChartPaint {
        return this.mEntryLabelsPaint
    }
    public func initBuffers(): Unit {}

    public func drawData(c: CanvasRenderingContext2D): Unit {
        //c.clearRect(0.0, 0.0, c.width, c.height)
        //CanvasRenderingContext2D 未实现属性 width heigth
        c.clearRect(0.0, 0.0, 500.0, 500.0)

        let pieData: ?PieData = this.mChart.getPieData()

        if (pieData.isSome()) {
            let dataSets = pieData().getDataSets()
            for (i in 0..dataSets.size) {
                let set = dataSets.get(i)()
                if (set.isVisible() && set.getEntryCount() > 0) {
                    this.drawDataSet(c, set)
                }
            }
        }
    }

    private var mPathBuffer: Path2D = Path2D()
    private var mInnerRectBuffer: MyRect = MyRect()

    protected func calculateMinimumRadiusForSpacedSlice(
        center: MPPointF,
        radius: Float64,
        angle: Float64,
        arcStartPointX: Float64,
        arcStartPointY: Float64,
        startAngle: Float64,
        sweepAngle: Float64
    ): Float64 {
        let angleMiddle: Float64 = startAngle + sweepAngle / 2.0

        // Other point of the arc
        let arcEndPointX: Float64 = center.x + radius * /*(float)*/
            cos((startAngle + sweepAngle) * Utils.FDEG2RAD)
        let arcEndPointY: Float64 = center.y + radius * /*(float)*/
            sin((startAngle + sweepAngle) * Utils.FDEG2RAD)

        // Middle point on the arc
        let arcMidPointX: Float64 = center.x + radius * /*(float)*/
            cos(angleMiddle * Utils.FDEG2RAD)
        let arcMidPointY: Float64 = center.y + radius * /*(float)*/
            sin(angleMiddle * Utils.FDEG2RAD)

        // This is the base of the contained triangle
        let basePointsDistance: Float64 = sqrt(pow(arcEndPointX - arcStartPointX, 2) + pow(
            arcEndPointY - arcStartPointY,
            2
        ))

        // After reducing space from both sides of the "slice",
        //   the angle of the contained triangle should stay the same.
        // So let's find out the height of that triangle.
        let containedTriangleHeight: Float64 = /*(float)*/
            (basePointsDistance / 2.0 * tan((180.0 - angle) / 2.0 * Utils.DEG2RAD))

        // Now we subtract that from the radius
        var spacedRadius: Float64 = radius - containedTriangleHeight

        // And now subtract the height of the arc that's between the triangle and the outer circle
        spacedRadius -= sqrt(
            pow(arcMidPointX - (arcEndPointX + arcStartPointX) / 2.0, 2) + pow(
            arcMidPointY - (arcEndPointY + arcStartPointY) / 2.0, 2))

        return spacedRadius
    }

    /**
     * Calculates the sliceSpace to use based on visible values and their size compared to the set sliceSpace.
     *
     * @param dataSet
     * @return
     */
    protected func getSliceSpace(dataSet: IPieDataSet): Float64 {
        let chartData: ?PieData = this.mChart.getPieData()

        if (chartData.isNone() || this.mViewPortHandler.isNone()) {
            return -1.0
        }

        if (!dataSet.isAutomaticallyDisableSliceSpacingEnabled()) {
            return dataSet.getSliceSpace()
        }

        let spaceSizeRatio: Float64 = dataSet.getSliceSpace() / this.mViewPortHandler().getSmallestContentExtension()
        let minValueRatio: Float64 = dataSet.getYMin() / chartData().getYValueSum() * 2.0

        let sliceSpace: Float64 = if (spaceSizeRatio > minValueRatio) {
            0.0
        } else {
            dataSet.getSliceSpace()
        }

        return sliceSpace
    }

    protected func drawDataSet(c: CanvasRenderingContext2D, dataSet: IPieDataSet): Unit {
        if (this.mAnimator.isNone()) {
            return
        }

        var angle: Float64 = 0.0 // 当前绘制的扇形起始角度
        let rotationAngle: Float64 = this.mChart.getRotationAngle() // 饼图旋转的角度

        let phaseX: Float64 = this.mAnimator().getPhaseX() // X轴动画阶段
        let phaseY: Float64 = this.mAnimator().getPhaseY() // Y轴动画阶段

        let circleBox: MyRect = this.mChart.getCircleBox() // 饼图边框

        let entryCount: Int64 = dataSet.getEntryCount() // 数据集中的数据点数量
        let drawAngles: Array<Float64> = this.mChart.getDrawAngles() // 饼图每个扇形的绘制角度
        let center: MPPointF = this.mChart.getCenterCircleBox() // 饼图中心点坐标
        let radius: Float64 = this.mChart.getRadius() // 饼图半径
        let drawInnerArc: Bool = this.mChart.isDrawHoleEnabled() && !this.mChart.isDrawSlicesUnderHoleEnabled() // 是否绘制内圆环
        let userInnerRadius: Float64 = if (drawInnerArc) {
            radius * (this.mChart.getHoleRadius() / 100.0)
        } else {
            0.0
        } // 用户指定的内圆环半径
        let roundedRadius: Float64 = (radius - (radius * this.mChart.getHoleRadius() / 100.0)) / 2.0 // 圆角扇形的圆角半径
        let roundedCircleBox: MyRect = MyRect() // 圆角扇形的边框
        let drawRoundedSlices: Bool = drawInnerArc && this.mChart.isDrawRoundedSlicesEnabled() // 是否绘制圆角扇形

        var visibleAngleCount: Int64 = 0 //可见的扇形数量
        for (j in 0..entryCount) {
            // draw only if the value is greater than zero 仅在数值大于零时绘制
            if ((abs(dataSet.getEntryForIndex(j)().getY()) > Utils.FLOAT_EPSILON)) {
                visibleAngleCount++
            }
        }

        let sliceSpace: Float64 = if (visibleAngleCount <= 1) {
            0.0
        } else {
            this.getSliceSpace(dataSet)
        } // 扇形之间的间隔

        for (j in 0..entryCount) {
            let sliceAngle: Float64 = drawAngles[j] // 当前扇形的绘制角度
            var innerRadius: Float64 = userInnerRadius // 内圆环半径

            let e: EntryOhos = dataSet.getEntryForIndex(j)() // 数据集中的数据点

            // draw only if the value is greater than zero (仅在数值大于零时绘制)
            if (!(abs(e.getY()) > Utils.FLOAT_EPSILON)) {
                angle += sliceAngle * phaseX
                continue
            }

            // Don't draw if it's highlighted, unless the chart uses rounded slices (如果启用了高亮且图表需要高亮当前扇形，并且不绘制圆角扇形，则不进行绘制)
            if (dataSet.isHighlightEnabled() && this.mChart.needsHighlight(Float64(j)) && !drawRoundedSlices) {
                angle += sliceAngle * phaseX
                continue
            }

            // 是否考虑扇形间的间隔
            let accountForSliceSpacing: Bool = sliceSpace > 0.0 && sliceAngle <= 180.0

            this.mRenderPaint.setColor(Color(dataSet.getColor(j))) // 设置画笔颜色

            // 计算外部扇形的起始角度和扫过的角度
            let sliceSpaceAngleOuter: Float64 = sliceSpaceAngleOuterFunc(visibleAngleCount, sliceSpace, radius)

            let startAngleOuter: Float64 = rotationAngle + (angle + sliceSpaceAngleOuter / 2.0) * phaseY
            var sweepAngleOuter: Float64 = (sliceAngle - sliceSpaceAngleOuter) * phaseY
            if (sweepAngleOuter < 0.0) {
                sweepAngleOuter = 0.0
            }

            // this.mPathBuffer.reset() //重置路径
            this.mPathBuffer = Path2D()

            if (drawRoundedSlices) {
                let x: Float64 = center.x + (radius - roundedRadius) * /*(float)*/
                    cos(startAngleOuter * Utils.FDEG2RAD)
                let y: Float64 = center.y + (radius - roundedRadius) * /*(float)*/
                    sin(startAngleOuter * Utils.FDEG2RAD)
                roundedCircleBox.set(x - roundedRadius, y - roundedRadius, x + roundedRadius, y + roundedRadius)
            }

            let arcStartPointX: Float64 = center.x + radius * /*(float)*/
                cos(startAngleOuter * Utils.FDEG2RAD)
            let arcStartPointY: Float64 = center.y + radius * /*(float)*/
                sin(startAngleOuter * Utils.FDEG2RAD)

            if (sweepAngleOuter >= 360.0 && Float64(Int64(sweepAngleOuter) % 360) <= Utils.FLOAT_EPSILON) {
                // ohos is doing "mod 360"
                this.mPathBuffer.arc(center.x, center.y, radius, 0.0, 2.0 * Float64.PI)
            // this.mPathBuffer.addCircle(center.x, center.y, radius, Path.Direction.CW)
            } else {
                // 绘制圆角扇形的路径
                if (drawRoundedSlices) {
                    this.arcTo(this.mPathBuffer, roundedCircleBox, startAngleOuter + 180.0, -180.0)
                }
                // 绘制普通扇形的路径
                this.arcTo(this.mPathBuffer, circleBox, startAngleOuter, sweepAngleOuter)
            }

            // API < 21 does not receive floats in addArc, but a RectF
            this.mInnerRectBuffer.set(
                center.x - innerRadius,
                center.y - innerRadius,
                center.x + innerRadius,
                center.y + innerRadius
            )

            if (drawInnerArc && (innerRadius > 0.0 || accountForSliceSpacing)) {
                drawInnerArcFunc(accountForSliceSpacing, center, radius, sliceAngle, phaseY, arcStartPointX,
                    arcStartPointY, startAngleOuter, sweepAngleOuter, innerRadius, visibleAngleCount, sliceSpace,
                    drawRoundedSlices, rotationAngle, angle, roundedRadius, roundedCircleBox)
            } else {
                drawOutterArcFunc(sweepAngleOuter, accountForSliceSpacing, startAngleOuter, center, radius, sliceAngle,
                    phaseY, sliceSpace, arcStartPointX, arcStartPointY)
            }

            this.mPathBuffer.closePath() // 封闭路径

            // 绘制路径
            Utils.resetContext2DStyle(c, this.mRenderPaint)
            c.stroke(this.mPathBuffer)
            //这里未实现c.fill(this.mPathBuffer) 可能有问题
            //c.fill(this.mPathBuffer)
            //            c.fill()

            angle += sliceAngle * phaseX // 更新角度
        }

        MPPointF.recycleInstance(center) // 释放中心点实例
    }

    private func sliceSpaceAngleOuterFunc(visibleAngleCount: Int64, sliceSpace: Float64, radius: Float64): Float64 {
        if (visibleAngleCount == 1) {
            return 0.0
        } else {
            return sliceSpace / (Utils.FDEG2RAD * radius)
        }
    }

    private func drawInnerArcFunc(accountForSliceSpacing: Bool, center: MPPointF, radius: Float64, sliceAngle: Float64,
        phaseY: Float64, arcStartPointX: Float64, arcStartPointY: Float64, startAngleOuter: Float64,
        sweepAngleOuter: Float64, innerRadiuss: Float64, visibleAngleCount: Int64, sliceSpace: Float64,
        drawRoundedSlices: Bool, rotationAngle: Float64, angle: Float64, roundedRadius: Float64,
        roundedCircleBox: MyRect) {
        var innerRadius: Float64 = innerRadiuss
        if (accountForSliceSpacing) {
            var minSpacedRadius: Float64 = this.calculateMinimumRadiusForSpacedSlice(center, radius, sliceAngle * phaseY,
                arcStartPointX, arcStartPointY, startAngleOuter, sweepAngleOuter)

            if (minSpacedRadius < 0.0) {
                minSpacedRadius = -minSpacedRadius
            }

            innerRadius = max(innerRadius, minSpacedRadius)
        }

        let sliceSpaceAngleInner: Float64 = if (visibleAngleCount == 1 || innerRadius == 0.0) {
            0.0
        } else {
            sliceSpace / (Utils.FDEG2RAD * innerRadius)
        }

        let startAngleInner: Float64 = rotationAngle + (angle + sliceSpaceAngleInner / 2.0) * phaseY
        var sweepAngleInner: Float64 = (sliceAngle - sliceSpaceAngleInner) * phaseY
        if (sweepAngleInner < 0.0) {
            sweepAngleInner = 0.0
        }
        let endAngleInner: Float64 = startAngleInner + sweepAngleInner

        if (sweepAngleOuter >= 360.0 && Float64(Int64(sweepAngleOuter) % 360) <= Utils.FLOAT_EPSILON) {
            // ohos is doing "mod 360"
            this.mPathBuffer.arc(center.x, center.y, innerRadius, 0.0, 2.0 * Float64.PI, anticlockwise: true)
        } else {
            if (drawRoundedSlices) {
                let x: Float64 = center.x + (radius - roundedRadius) * /*(float)*/
                    cos(endAngleInner * Utils.FDEG2RAD)
                let y: Float64 = center.y + (radius - roundedRadius) * /*(float) */
                    sin(endAngleInner * Utils.FDEG2RAD)
                roundedCircleBox.set(x - roundedRadius, y - roundedRadius, x + roundedRadius, y + roundedRadius)
                // this.mPathBuffer.arcTo(roundedCircleBox.left, roundedCircleBox.top,roundedCircleBox.right,roundedCircleBox.bottom,endAngleInner/*, 180*/)
                this.arcTo(this.mPathBuffer, roundedCircleBox, endAngleInner, 180.0)
            } else {
                this.mPathBuffer.lineTo(
                    center.x + innerRadius * cos(endAngleInner * Utils.FDEG2RAD),
                    center.y + innerRadius * sin(endAngleInner * Utils.FDEG2RAD)
                )
            }

            this.arcTo(
                this.mPathBuffer,
                this.mInnerRectBuffer,
                endAngleInner,
                -sweepAngleInner
            )
        }
    }

    private func drawOutterArcFunc(sweepAngleOuter: Float64, accountForSliceSpacing: Bool, startAngleOuter: Float64,
        center: MPPointF, radius: Float64, sliceAngle: Float64, phaseY: Float64, sliceSpace: Float64,
        arcStartPointX: Float64, arcStartPointY: Float64) {
        if (Float64(Int64(sweepAngleOuter) % 360) > Utils.FLOAT_EPSILON) {
            if (accountForSliceSpacing) {

                // 计算扇形中心的角度
                let angleMiddle: Float64 = startAngleOuter + sweepAngleOuter / 2.0

                // 计算间隔偏移
                let sliceSpaceOffset: Float64 = this.calculateMinimumRadiusForSpacedSlice(
                    center,
                    radius,
                    sliceAngle * phaseY,
                    arcStartPointX,
                    arcStartPointY,
                    startAngleOuter,
                    sweepAngleOuter
                )

                let arcEndPointX: Float64 = center.x + sliceSpaceOffset * /*(float)*/
                    cos(angleMiddle * Utils.FDEG2RAD)
                let arcEndPointY: Float64 = center.y + sliceSpaceOffset * /*(float)*/
                    sin(angleMiddle * Utils.FDEG2RAD)

                this.mPathBuffer.lineTo(
                    arcEndPointX,
                    arcEndPointY
                )
            } else {
                this.mPathBuffer.lineTo(
                    center.x,
                    center.y
                )
            }
        }
    }

    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool = false): Unit {
        if (this.mAnimator.isNone()) {
            return
        }

        let center: MPPointF = this.mChart.getCenterCircleBox()

        // get whole the radius
        let radius: Float64 = this.mChart.getRadius()
        var rotationAngle: Float64 = this.mChart.getRotationAngle()
        let drawAngles: Array<Float64> = this.mChart.getDrawAngles()
        let absoluteAngles: Array<Float64> = this.mChart.getAbsoluteAngles()

        let phaseX: Float64 = this.mAnimator().getPhaseX()
        let phaseY: Float64 = this.mAnimator().getPhaseY()

        let roundedRadius: Float64 = (radius - (radius * this.mChart.getHoleRadius() / 100.0)) / 2.0
        let holeRadiusPercent: Float64 = this.mChart.getHoleRadius() / 100.0
        var labelRadiusOffset: Float64 = radius / 10.0 * 3.6

        if (this.mChart.isDrawHoleEnabled()) {
            labelRadiusOffset = (radius - (radius * holeRadiusPercent)) / 2.0

            if (!this.mChart.isDrawSlicesUnderHoleEnabled() && this.mChart.isDrawRoundedSlicesEnabled()) {
                // Add curved circle slice and spacing to rotation angle, so that it sits nicely inside
                rotationAngle += roundedRadius * 360.0 / (Float64.PI * 2.0 * radius)
            }
        }

        let labelRadius: Float64 = radius - labelRadiusOffset

        let data: ?PieData = this.mChart.getPieData()
        if (data.isNone()) {
            return
        }
        let dataSets: ArrayList<IPieDataSet> = data().getDataSets()

        let yValueSum: Float64 = data().getYValueSum()

        let drawEntryLabels: Bool = this.mChart.isDrawEntryLabelsEnabled()

        var angle: Float64
        var xIndex: Int64 = 0

        c.save()

        let offset: Float64 = Utils.handleDataValues(0.0)

        for (i in 0..dataSets.size) {
            let dataSet: IPieDataSet = dataSets.get(i)()

            let drawValues: Bool = dataSet.isDrawValuesEnabled()

            if (!drawValues && !drawEntryLabels) {
                continue
            }

            let xValuePosition: ValuePosition = dataSet.getXValuePosition()
            let yValuePosition: ValuePosition = dataSet.getYValuePosition()

            // apply the text-styling defined by the DataSet
            //            this.applyValueTextStyle((dataSet as IDataSet<EntryOhos>)())

            //            let lineHeight: Float64 = Utils.calcTextHeight(this.mValuePaint, "Q") + Utils.handleDataValues(4.0)
            let lineHeight: Float64 = 20.0
            let formatter: ?IValueFormatter = dataSet.getValueFormatter()

            let entryCount: Int64 = dataSet.getEntryCount()

            let isUseValueColorForLineEnabled: Bool = dataSet.isUseValueColorForLineEnabled()
            let valueLineColor: UInt32 = dataSet.getValueLineColor()

            this.mValueLinePaint.setStrokeWidth(Utils.handleDataValues(dataSet.getValueLineWidth()))

            let sliceSpace: Float64 = this.getSliceSpace(dataSet)

            let iconsOffset: MPPointF = MPPointF.getInstance(dataSet.getIconsOffset())
            iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
            iconsOffset.y = Utils.handleDataValues(iconsOffset.y)

            for (j in 0..entryCount) {
                let entry: ?PiEntry = dataSet.getEntryForIndex(j)
                if (entry.isNone()) {
                    continue
                }

                if (xIndex == 0) {
                    angle = 0.0
                } else {
                    angle = absoluteAngles[xIndex - 1] * phaseX
                }

                let sliceAngle: Float64 = drawAngles[xIndex]
                let sliceSpaceMiddleAngle: Float64 = sliceSpace / (Utils.FDEG2RAD * labelRadius)

                // offset needed to center the drawn text in the slice
                let angleOffset: Float64 = (sliceAngle - sliceSpaceMiddleAngle / 2.0) / 2.0

                angle = angle + angleOffset

                let transformedAngle: Float64 = rotationAngle + angle * phaseY

                let value: Float64 = if (this.mChart.isUsePercentValuesEnabled()) {
                    entry().getY() / yValueSum * 100.0
                } else {
                    entry().getY()
                }

                let entryLabel: String = entry().getLabel()

                let sliceXBase: Float64 = cos(transformedAngle * Utils.FDEG2RAD)
                let sliceYBase: Float64 = sin(transformedAngle * Utils.FDEG2RAD)

                let drawXOutside: Bool = drawEntryLabels && xValuePosition == ValuePosition.OUTSIDE_SLICE
                let drawYOutside: Bool = drawValues && yValuePosition == ValuePosition.OUTSIDE_SLICE
                let drawXInside: Bool = drawEntryLabels && xValuePosition == ValuePosition.INSIDE_SLICE
                let drawYInside: Bool = drawValues && yValuePosition == ValuePosition.INSIDE_SLICE

                if (drawXOutside || drawYOutside) {
                    let valueLineLength1: Float64 = dataSet.getValueLinePart1Length()
                    let valueLineLength2: Float64 = dataSet.getValueLinePart2Length()
                    let valueLinePart1OffsetPercentage: Float64 = dataSet.getValueLinePart1OffsetPercentage() / 100.0

                    var pt2x: Float64 = 0.0
                    var pt2y: Float64 = 0.0
                    var labelPtx: Float64 = 0.0
                    var labelPty: Float64 = 0.0

                    var line1Radius: Float64 = 0.0

                    if (this.mChart.isDrawHoleEnabled()) {
                        line1Radius = (radius - (radius * holeRadiusPercent)) * valueLinePart1OffsetPercentage + (radius *
                            holeRadiusPercent)
                    } else {
                        line1Radius = radius * valueLinePart1OffsetPercentage
                    }

                    let polyline2Width: Float64 = if (dataSet.isValueLineVariableLength()) {
                        labelRadius * valueLineLength2 * /*(float)*/
                            abs(sin(transformedAngle * Utils.FDEG2RAD))
                    } else {
                        labelRadius * valueLineLength2
                    }

                    let pt0x: Float64 = line1Radius * sliceXBase + center.x
                    let pt0y: Float64 = line1Radius * sliceYBase + center.y

                    let pt1x: Float64 = labelRadius * (1.0 + valueLineLength1) * sliceXBase + center.x
                    let pt1y: Float64 = labelRadius * (1.0 + valueLineLength1) * sliceYBase + center.y

                    if (Int64(transformedAngle) % 360 >= 90 && Int64(transformedAngle) % 360 <= 270) {
                        pt2x = pt1x - polyline2Width
                        pt2y = pt1y

                        this.mValuePaint.setTextAlign(TextAlignStyle.Right)

                        if (drawXOutside) {
                            this.mEntryLabelsPaint.setTextAlign(TextAlignStyle.Right)
                        }

                        labelPtx = pt2x - offset
                        labelPty = pt2y
                    } else {
                        pt2x = pt1x + polyline2Width
                        pt2y = pt1y
                        this.mValuePaint.setTextAlign(TextAlignStyle.Left)

                        if (drawXOutside) {
                            this.mEntryLabelsPaint.setTextAlign(TextAlignStyle.Left)
                        }

                        labelPtx = pt2x + offset
                        labelPty = pt2y
                    }

                    var lineColor: UInt32 = ColorTemplate.COLOR_NONE

                    if (isUseValueColorForLineEnabled) {
                        lineColor = dataSet.getColor(j)
                    } else if (valueLineColor != ColorTemplate.COLOR_NONE) {
                        lineColor = valueLineColor
                    }

                    if (lineColor != ColorTemplate.COLOR_NONE) {
                        this.mValueLinePaint.setColor(Color(lineColor))
                        Utils.resetContext2DStyle(c, this.mValueLinePaint)
                        c.beginPath()
                        c.moveTo(pt0x, pt0y)
                        c.lineTo(pt1x, pt1y)
                        c.lineTo(pt2x, pt2y)
                        c.stroke()
                        c.closePath()
                    }

                    // draw everything, depending on settings
                    if (drawXOutside && drawYOutside && formatter.isSome()) {
                        this.drawValue(
                            c,
                            formatter(),
                            value,
                            entry(),
                            0,
                            labelPtx,
                            labelPty,
                            Color(dataSet.getValueTextColor(j))
                        )

                        if (j < data().getEntryCount()) {
                            this.drawEntryLabel(c, entryLabel, labelPtx, labelPty + lineHeight)
                        }
                    } else if (drawXOutside) {
                        if (j < data().getEntryCount()) {
                            this.drawEntryLabel(c, entryLabel, labelPtx, labelPty + lineHeight / 2.0)
                        }
                    } else if (drawYOutside && formatter.isSome()) {
                        this.drawValue(c, formatter(), value, entry(), 0, labelPtx, labelPty + lineHeight / 2.0,
                            Color(dataSet.getValueTextColor(j)))
                    }
                }

                if (drawXInside || drawYInside) {
                    // calculate the text position
                    let x: Float64 = labelRadius * sliceXBase + center.x
                    let y: Float64 = labelRadius * sliceYBase + center.y

                    this.mValuePaint.setTextAlign(TextAlignStyle.Center)

                    // draw everything, depending on settings
                    if (drawXInside && drawYInside && formatter.isSome()) {
                        this.drawValue(c, formatter(), value, entry(), 0, x, y, Color(dataSet.getValueTextColor(j)))

                        if (j < data().getEntryCount()) {
                            this.drawEntryLabel(c, entryLabel, x, y + lineHeight)
                        }
                    } else if (drawXInside) {
                        if (j < data().getEntryCount()) {
                            this.drawEntryLabel(c, entryLabel, x, y + lineHeight / 2.0)
                        }
                    } else if (drawYInside && formatter.isSome()) {
                        this.drawValue(c, formatter(), value, entry(), 0, x, y + lineHeight / 2.0,
                            Color(dataSet.getValueTextColor(j)))
                    }
                }

                if (entry().getIcon().isSome() && dataSet.isDrawIconsEnabled()) {
                    let icon: ?ChartPixelMap = entry().getIcon()
                    let x: Float64 = (labelRadius + iconsOffset.y) * sliceXBase + center.x
                    var y: Float64 = (labelRadius + iconsOffset.y) * sliceYBase + center.y
                    y += iconsOffset.x

                    if (icon.isSome()) {
                        Utils.drawImage(
                            c,
                            icon(),
                            floor(x),
                            floor(y)
                        )
                    }
                }

                xIndex++
            }

            MPPointF.recycleInstance(iconsOffset)
        }
        MPPointF.recycleInstance(center)
        c.restore()
    }

    /**
     * Draws an entry label at the specified position.
     *
     * @param c
     * @param label
     * @param x
     * @param y
     */
    protected func drawEntryLabel(c: CanvasRenderingContext2D, label: String, x: Float64, y: Float64): Unit {
        // c.drawText(label, x, y, this.mEntryLabelsPaint)
        Utils.resetContext2DStyle(c, this.mEntryLabelsPaint)
        c.beginPath()
        c.strokeText(label, x, y)
        c.closePath()
    }

    public func drawExtras(c: CanvasRenderingContext2D): Unit {
        this.drawHole(c)
        this.drawCenterText(c)
    }

    private var mHoleCirclePath: Path2D = Path2D()

    /**
     * draws the hole in the center of the chart and the transparent circle /
     * hole
     */
    protected func drawHole(c: CanvasRenderingContext2D): Unit {
        if (this.mChart.isDrawHoleEnabled()) {
            let radius: Float64 = this.mChart.getRadius()
            let holeRadius: Float64 = radius * (this.mChart.getHoleRadius() / 100.0)
            let center: MPPointF = this.mChart.getCenterCircleBox()
            Utils.resetContext2DStyle(c, this.mHolePaint)
            c.beginPath()
            c.arc(center.x, center.y, holeRadius, 0.0, 2.0 * Float64.PI)
            c.fill()
            c.closePath()

            // only draw the circle if it can be seen (not covered by the hole)
            // if (MyColor.alpha(Number(this.mTransparentCirclePaint.getColor())) > 0 &&
            //   this.mChart.getTransparentCircleRadius() > this.mChart.getHoleRadius()) {

            let alpha: ?Float64 = this.mTransparentCirclePaint.getGlobalAlpha()

            let secondHoleRadius: Float64 = radius * (this.mChart.getTransparentCircleRadius() / 100.0)
            if (this.mAnimator.isNone()) {
                return
            }
            if (let Some(globalAlpha) <- alpha) {
                this.mTransparentCirclePaint.setGlobalAlpha(
                    (globalAlpha * this.mAnimator().getPhaseX() * this.mAnimator().getPhaseY()))
            }

            c.save()
            Utils.resetContext2DStyle(c, this.mTransparentCirclePaint)

            c.beginPath()
            c.arc(center.x, center.y, secondHoleRadius, 0.0, 2.0 * Float64.PI, anticlockwise: true)
            c.arc(center.x, center.y, holeRadius, 0.0, 2.0 * Float64.PI, anticlockwise: false)
            c.fill()
            c.closePath()
            c.restore()

            // reset alpha
            if (let Some(globalAlpha) <- alpha) {
                this.mTransparentCirclePaint.setGlobalAlpha(globalAlpha)
            }

            MPPointF.recycleInstance(center)
        }
    }

    protected var mDrawCenterTextPathBuffer: Path2D = Path2D()

    /**
     * draws the description text in the center of the pie chart makes most
     * sense when center-hole is enabled
     */
    protected func drawCenterText(c: CanvasRenderingContext2D): Unit {
        let centerText: String = this.mChart.getCenterText()
        if (this.mChart.isDrawCenterTextEnabled()) {
            let center: MPPointF = this.mChart.getCenterCircleBox()
            let offset: MPPointF = this.mChart.getCenterTextOffset()

            let x: Float64 = center.x + offset.x
            let y: Float64 = center.y + offset.y

            let innerRadius: Float64 = if (this.mChart.isDrawHoleEnabled() &&
                !this.mChart.isDrawSlicesUnderHoleEnabled()) {
                this.mChart.getRadius() * (this.mChart.getHoleRadius() / 100.0)
            } else {
                this.mChart.getRadius()
            }

            let holeRect: MyRect = this.mRectBuffer[0]
            holeRect.left = x - innerRadius
            holeRect.top = y - innerRadius
            holeRect.right = x + innerRadius
            holeRect.bottom = y + innerRadius
            let boundingRect: MyRect = this.mRectBuffer[1]
            boundingRect.set(holeRect.left, holeRect.top, holeRect.right, holeRect.bottom)

            let radiusPercent: Float64 = this.mChart.getCenterTextRadiusPercent() / 100.0
            if (radiusPercent > 0.0) {
                boundingRect.inset(
                    (boundingRect.width() - boundingRect.width() * radiusPercent) / 2.0,
                    (boundingRect.height() - boundingRect.height() * radiusPercent) / 2.0,
                    (boundingRect.width() - boundingRect.width() * radiusPercent) / 2.0,
                    (boundingRect.height() - boundingRect.height() * radiusPercent) / 2.0
                )
            }

            if (centerText != this.mCenterTextLastValue || !boundingRect.equals(this.mCenterTextLastBounds)) {

                // Next time we won't recalculate StaticLayout...
                this.mCenterTextLastBounds.set(boundingRect.left, boundingRect.top, boundingRect.right,
                    boundingRect.bottom)
                this.mCenterTextLastValue = centerText
            }

            let textHeight: Float64 = Utils.calcTextHeight(this.mCenterTextPaint, centerText)
            let textWidth: Float64 = Utils.calcTextWidth(this.mCenterTextPaint, centerText)
            c.save()
            Utils.resetContext2DStyle(c, this.mCenterTextPaint)

            c.fillText(centerText, x - textWidth / 2.0, y)
            c.restore()
            MPPointF.recycleInstance(center)
            MPPointF.recycleInstance(offset)
        }
    }

    protected var mDrawHighlightedRectF: MyRect = MyRect()

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>): Unit {

        /* Skip entirely if using rounded circle slices, because it doesn't make sense to highlight
         * in this way.
         */
        let drawInnerArc: Bool = this.mChart.isDrawHoleEnabled() && !this.mChart.isDrawSlicesUnderHoleEnabled()
        if (drawInnerArc && this.mChart.isDrawRoundedSlicesEnabled()) {
            return
        }

        if (this.mAnimator.isNone()) {
            return
        }
        let phaseX: Float64 = this.mAnimator().getPhaseX()
        let phaseY: Float64 = this.mAnimator().getPhaseY()

        var angle: Float64
        let rotationAngle: Float64 = this.mChart.getRotationAngle()

        let drawAngles: Array<Float64> = this.mChart.getDrawAngles()
        let absoluteAngles: Array<Float64> = this.mChart.getAbsoluteAngles()
        let center: MPPointF = this.mChart.getCenterCircleBox()
        let radius: Float64 = this.mChart.getRadius()
        let userInnerRadius: Float64 = if (drawInnerArc) {
            radius * (this.mChart.getHoleRadius() / 100.0)
        } else {
            0.0
        }

        let highlightedCircleBox: MyRect = this.mDrawHighlightedRectF
        highlightedCircleBox.set(0.0, 0.0, 0.0, 0.0)

        for (i in 0..indices.size) {

            // get the index to highlight
            let index: Int64 = Int64(indices[i].getX())

            if (index >= drawAngles.size) {
                continue
            }

            let chartData: ?PieData = this.mChart.getPieData()
            if (chartData.isNone()) {
                continue
            }

            let set: ?IPieDataSet = if (let Some(chartData: PieData) <- chartData) {
                chartData.getDataSetByIndex(indices[i].getDataSetIndex())
            } else {
                None
            }

            if (set.isNone() || set().isHighlightEnabled()) {
                continue
            }

            let entryCount: Int64 = set().getEntryCount()
            var visibleAngleCount: Int64 = 0
            for (j in 0..entryCount) {
                // draw only if the value is greater than zero
                if ((abs(set().getEntryForIndex(j)().getY()) > Utils.FLOAT_EPSILON)) {
                    visibleAngleCount++
                }
            }

            if (index == 0) {
                angle = 0.0
            } else {
                angle = absoluteAngles[index - 1] * phaseX
            }

            let sliceSpace: Float64 = if (visibleAngleCount <= 1) {
                0.0
            } else {
                set().getSliceSpace()
            }

            let sliceAngle: Float64 = drawAngles[index]
            var innerRadius: Float64 = userInnerRadius

            let shift: Float64 = set().getSelectionShift()
            let highlightedRadius: Float64 = radius + shift
            highlightedCircleBox.set(this.mChart.getCircleBox().left, this.mChart.getCircleBox().top,
                this.mChart.getCircleBox().right, this.mChart.getCircleBox().bottom)
            highlightedCircleBox.inset(-shift, -shift, -shift, -shift)

            let accountForSliceSpacing: Bool = sliceSpace > 0.0 && sliceAngle <= 180.0

            var highlightColor: UInt32 = set().getHighlightColor()
            if (highlightColor == 0) {
                highlightColor = set().getColor(index)
            }

            this.mRenderPaint.setColor(Color(highlightColor))

            let sliceSpaceAngleOuter: Float64 = if (visibleAngleCount == 1) {
                0.0
            } else {
                sliceSpace / (Utils.FDEG2RAD * radius)
            }

            let sliceSpaceAngleShifted: Float64 = if (visibleAngleCount == 1) {
                0.0
            } else {
                sliceSpace / (Utils.FDEG2RAD * highlightedRadius)
            }

            let startAngleOuter: Float64 = rotationAngle + (angle + sliceSpaceAngleOuter / 2.0) * phaseY
            var sweepAngleOuter: Float64 = (sliceAngle - sliceSpaceAngleOuter) * phaseY
            if (sweepAngleOuter < 0.0) {
                sweepAngleOuter = 0.0
            }

            let startAngleShifted: Float64 = rotationAngle + (angle + sliceSpaceAngleShifted / 2.0) * phaseY
            var sweepAngleShifted: Float64 = (sliceAngle - sliceSpaceAngleShifted) * phaseY
            if (sweepAngleShifted < 0.0) {
                sweepAngleShifted = 0.0
            }

            // this.mPathBuffer.reset()
            this.mPathBuffer = Path2D()

            if (sweepAngleOuter >= 360.0 && Int64(sweepAngleOuter) % 360 <= Int64(Utils.FLOAT_EPSILON)) {
                // ohos is doing "mod 360"
                // this.mPathBuffer.addCircle(center.x, center.y, highlightedRadius, Path.Direction.CW)
                this.mHoleCirclePath.arc(center.x, center.y, highlightedRadius, 0.0, 2.0 * Float64.PI)
            } else {
                this.mPathBuffer.moveTo(
                    center.x + highlightedRadius * /*(float)*/
                        cos(startAngleShifted * Utils.FDEG2RAD),
                    center.y + highlightedRadius * /*(float)*/
                        sin(startAngleShifted * Utils.FDEG2RAD)
                )

                this.arcTo(this.mPathBuffer, highlightedCircleBox, startAngleShifted, sweepAngleShifted)
            }

            var sliceSpaceRadius = 0.0
            if (accountForSliceSpacing) {
                sliceSpaceRadius = this.calculateMinimumRadiusForSpacedSlice(center, radius, sliceAngle * phaseY,
                    center.x + radius * /*(float)*/
                        cos(startAngleOuter * Utils.FDEG2RAD),
                    center.y + radius * /*(float)*/
                        sin(startAngleOuter * Utils.FDEG2RAD), startAngleOuter, sweepAngleOuter)
            }

            // API < 21 does not receive floats in addArc, but a RectF
            this.mInnerRectBuffer.set(
                center.x - innerRadius,
                center.y - innerRadius,
                center.x + innerRadius,
                center.y + innerRadius
            )

            if (drawInnerArc && (innerRadius > 0.0 || accountForSliceSpacing)) {
                if (accountForSliceSpacing) {
                    var minSpacedRadius = sliceSpaceRadius

                    if (minSpacedRadius < 0.0) {
                        minSpacedRadius = -minSpacedRadius
                    }

                    innerRadius = max(innerRadius, minSpacedRadius)
                }

                let sliceSpaceAngleInner: Float64 = if (visibleAngleCount == 1 || innerRadius == 0.0) {
                    0.0
                } else {
                    sliceSpace / (Utils.FDEG2RAD * innerRadius)
                }

                let startAngleInner: Float64 = rotationAngle + (angle + sliceSpaceAngleInner / 2.0) * phaseY
                var sweepAngleInner: Float64 = (sliceAngle - sliceSpaceAngleInner) * phaseY
                if (sweepAngleInner < 0.0) {
                    sweepAngleInner = 0.0
                }
                let endAngleInner: Float64 = startAngleInner + sweepAngleInner

                if (sweepAngleOuter >= 360.0 && Int64(sweepAngleOuter) % 360 <= Int64(Utils.FLOAT_EPSILON)) {
                    // ohos is doing "mod 360"
                    // this.mPathBuffer.addCircle(center.x, center.y, innerRadius, Path.Direction.CCW)
                    this.mHoleCirclePath.arc(center.x, center.y, innerRadius, 0.0, 2.0 * Float64.PI)
                } else {
                    this.mPathBuffer.lineTo(
                        center.x + innerRadius * /*(float)*/
                            cos(endAngleInner * Utils.FDEG2RAD),
                        center.y + innerRadius * /*(float)*/
                            sin(endAngleInner * Utils.FDEG2RAD)
                    )

                    this.arcTo(this.mPathBuffer, this.mInnerRectBuffer, endAngleInner, -sweepAngleInner)
                }
            } else {
                if (Int64(sweepAngleOuter) % 360 > Int64(Utils.FLOAT_EPSILON)) {
                    if (accountForSliceSpacing) {
                        let angleMiddle: Float64 = startAngleOuter + sweepAngleOuter / 2.0

                        let arcEndPointX: Float64 = center.x + sliceSpaceRadius * /*(float)*/
                            cos(angleMiddle * Utils.FDEG2RAD)
                        let arcEndPointY: Float64 = center.y + sliceSpaceRadius * /*(float)*/
                            sin(angleMiddle * Utils.FDEG2RAD)

                        this.mPathBuffer.lineTo(
                            arcEndPointX,
                            arcEndPointY
                        )
                    } else {
                        this.mPathBuffer.lineTo(
                            center.x,
                            center.y
                        )
                    }
                }
            }

            this.mPathBuffer.closePath()
            //TODO  this.mBitmapCanvas.drawPath(this.mPathBuffer, this.mRenderPaint)
            Utils.resetContext2DStyle(c, this.mRenderPaint)
            c.beginPath()
            //TODO c.stroke(this.mPathBuffer) c.fill(this.mPathBuffer) 未实现
            c.fill()
            c.closePath()
        }
        MPPointF.recycleInstance(center)
    }

    /**
     * This gives all pie-slices a rounded edge.
     *
     * @param c
     */
    protected func drawRoundedSlices(c: CanvasRenderingContext2D): Unit {
        if (!this.mChart.isDrawRoundedSlicesEnabled() || this.mAnimator.isNone() || this.mChart.getPieData().isNone()) {
            return
        }

        let dataSet: IPieDataSet = this.mChart.getPieData()().getDataSet()

        if (!dataSet.isVisible()) {
            return
        }

        let phaseX: Float64 = this.mAnimator().getPhaseX()
        let phaseY: Float64 = this.mAnimator().getPhaseY()

        let center: MPPointF = this.mChart.getCenterCircleBox()
        let r: Float64 = this.mChart.getRadius()

        // calculate the radius of the "slice-circle"
        let circleRadius: Float64 = (r - (r * this.mChart.getHoleRadius() / 100.0)) / 2.0

        let drawAngles: Array<Float64> = this.mChart.getDrawAngles()
        var angle: Float64 = this.mChart.getRotationAngle()

        for (j in 0..dataSet.getEntryCount()) {
            let sliceAngle: Float64 = drawAngles[j]

            let e: EntryOhos = dataSet.getEntryForIndex(j)()

            // draw only if the value is greater than zero
            if ((abs(e.getY()) > Utils.FLOAT_EPSILON)) {
                let x: Float64 = /*(float) */
                    ((r - circleRadius) * cos(MyMath.toRadians((angle + sliceAngle) * phaseY)) + center.x)
                let y: Float64 = /*(float)*/
                    ((r - circleRadius) * sin(MyMath.toRadians((angle + sliceAngle) * phaseY)) + center.y)

                this.mRenderPaint.setColor(Color(dataSet.getColor(j)))
                // this.mBitmapCanvas.drawCircle(x, y, circleRadius, this.mRenderPaint)
                Utils.resetContext2DStyle(c, this.mRenderPaint)
                c.beginPath()
                c.arc(center.x, center.y, circleRadius, 0.0, 2.0 * Float64.PI)
                c.fill()
                c.closePath()
            }

            angle += sliceAngle * phaseX
        }
        MPPointF.recycleInstance(center)
    }

    private func arcTo(path: Path2D, roundedCircleBox: MyRect, startAngle: Float64, sweepAngle: Float64): Unit {
        path.ellipse(
            roundedCircleBox.left + (roundedCircleBox.right - roundedCircleBox.left) / 2.0,
            roundedCircleBox.top + (roundedCircleBox.bottom - roundedCircleBox.top) / 2.0,
            (roundedCircleBox.right - roundedCircleBox.left) / 2.0,
            (roundedCircleBox.bottom - roundedCircleBox.top) / 2.0,
            0.0,
            startAngle * Utils.DEG2RAD,
            (startAngle + sweepAngle) * Utils.DEG2RAD,
            anticlockwise: if (sweepAngle < 0.0) {
                true
            } else {
                false
            }
        )
    }
}
