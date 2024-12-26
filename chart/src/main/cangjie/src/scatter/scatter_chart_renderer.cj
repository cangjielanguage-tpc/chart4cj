/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.scatter

public class ScatterChartRenderer <: LineScatterCandleRadarRenderer {
    public var mChart: ScatterDataProvider

    public init(chart: ScatterDataProvider, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart
    }

    public func initBuffers() {
    }

    public func drawData(c: CanvasRenderingContext2D) {
        let scatterData: ?ScatterData = this.mChart.getScatterData()
        if (let Some(scatterData) <- scatterData) {
            let sets = scatterData.getDataSets()
            for (index in 0..sets.size) {
                let set = sets[index]
                if (set.isVisible()) {
                    this.drawDataSet(c, set)
                }
            }
        } else {
            return
        }
    }

    private var mPixelBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    protected func drawDataSet(c: CanvasRenderingContext2D, dataSet: IScatterDataSet) {
        if (dataSet.getEntryCount() < 1) {
            return
        }
        if (this.mViewPortHandler.isSome() && this.mAnimator.isSome()) {
            let viewPortHandler: ?ViewPortHandler = this.mViewPortHandler

            let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())

            let phaseY = this.mAnimator().getPhaseY()

            let renderer: IShapeRenderer = dataSet.getShapeRenderer()

            let maxs = Int64(min(
                    ceil(Float64(dataSet.getEntryCount()) * this.mAnimator().getPhaseX()),
                    Float64(dataSet.getEntryCount())
                ))

            for (i in 0..maxs) {
                let e = dataSet.getEntryForIndex(i)()

                this.mPixelBuffer[0] = e.getX()
                this.mPixelBuffer[1] = e.getY() * phaseY

                if (trans.isNone()) {
                    continue
                }
                trans().pointValuesToPixel(this.mPixelBuffer)

                if (!viewPortHandler().isInBoundsRight(this.mPixelBuffer[0])) {
                    break
                }

                if (!viewPortHandler().isInBoundsLeft(this.mPixelBuffer[0]) ||
                    !viewPortHandler().isInBoundsY(this.mPixelBuffer[1])) {
                    continue
                }

                this.mRenderPaint.setColor(Color(dataSet.getColor(i / 2)))
                renderer.renderShape(c, dataSet, this.mViewPortHandler(), this.mPixelBuffer[0], this.mPixelBuffer[1],
                    this.mRenderPaint)
            }
        }
    }
    protected open func isDrawingValuesAllowed(chart: ScatterDataProvider): Bool {
        let chartData: ?ScatterData = chart.getScatterData()
        if (this.mViewPortHandler.isSome() && chartData.isSome()) {
            return Float64(chartData().getEntryCount()) < Float64(chart.getMaxVisibleCount()) *
                this.mViewPortHandler().getScaleX()
        }
        return false
    }

    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool) {

        // if values are drawn
        if (this.isDrawingValuesAllowed(this.mChart)) {
            let data = this.mChart.getScatterData()
            if (data.isNone()) {
                return
            }
            let dataSets: ArrayList<IScatterDataSet> = data().getDataSets()

            for (i in 0..data().getDataSetCount()) {
                let dataSet: IScatterDataSet = dataSets[i]

                if (!this.shouldDrawValues(dataSet) || dataSet.getEntryCount() < 1) {
                    continue
                }

                // apply the text-styling defined by the DataSet
                this.applyValueTextStyle(dataSet)

                if (this.mXBounds.isNone() || this.mAnimator.isNone()) {
                    continue
                }
                this.mXBounds().set(this.mChart, dataSet)

                let positions: Array<Float64> = this.mChart.getTransformer(dataSet.getAxisDependency())().
                    generateTransformedValuesScatter(dataSet, this.mAnimator().getPhaseX(), this.mAnimator().getPhaseY(),
                    this.mXBounds().mins, this.mXBounds().maxs)

                let shapeSize = Utils.handleDataValues(dataSet.getScatterShapeSize())

                let iconsOffset: MPPointF = MPPointF.getInstance(dataSet.getIconsOffset())
                iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
                iconsOffset.y = Utils.handleDataValues(iconsOffset.y)

                for (j in 0..positions.size : 2) {
                    if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsRight(positions[j])) {
                        break
                    }

                    // make sure the lines don't do shitty things outside bounds
                    if ((!this.mViewPortHandler().isInBoundsLeft(positions[j]) ||
                        !this.mViewPortHandler().isInBoundsY(positions[j + 1]))) {
                        continue
                    }

                    let entry = dataSet.getEntryForIndex(j / 2 + this.mXBounds().mins)()

                    if (dataSet.isDrawValuesEnabled()) {
                        let valueFormatter: ?IValueFormatter = dataSet.getValueFormatter()
                        if (valueFormatter.isSome()) {
                            this.drawValue(
                                c,
                                dataSet.getValueFormatter()(),
                                entry.getY(),
                                entry,
                                i,
                                positions[j],
                                positions[j + 1] - shapeSize,
                                Color(dataSet.getValueTextColor(j / 2 + this.mXBounds().mins))
                            )
                        }
                    }

                    if (entry.getIcon().isSome() && dataSet.isDrawIconsEnabled()) {
                        let icon: ?ChartPixelMap = entry.getIcon()
                        if (icon.isNone()) {
                            continue
                        }
                        Utils.drawImage(
                            c,
                            icon(),
                            (positions[j] + iconsOffset.x),
                            (positions[j + 1] + iconsOffset.y),
                        )
                    }
                }

                MPPointF.recycleInstance(iconsOffset)
            }
        }
    }

    public func drawExtras(c: CanvasRenderingContext2D) {
    }

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>) {
        let scatterData: ?ScatterData = this.mChart.getScatterData()
        if (scatterData.isNone()) {
            return
        }

        for (i in 0..indices.size) {
            let high = indices[i]
            let set: ?IScatterDataSet = scatterData().getDataSetByIndex(high.getDataSetIndex())

            if (set.isNone() || !set().isHighlightEnabled()) {
                continue
            }

            let e: ?EntryOhos = set().getEntryForXValue(high.getX(), high.getY(), rounding: Rounding.CLOSEST)

            if (e.isNone() || !this.isInBoundsX(e(), set()) || this.mAnimator.isNone()) {
                continue
            }

            let pix: MPPointD = this.mChart.getTransformer(set().getAxisDependency())().getPixelForValues(
                e().getX(),
                e().getY() * this.mAnimator().getPhaseY()
            )

            high.setDraw(pix.x, pix.y)

            // draw the lines
            this.drawHighlightLines(c, pix.x, pix.y, set())
        }
    }
}
