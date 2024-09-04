/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.combine

public class CombinedChartRenderer <: DataRenderer  {
    protected var mRenderers: ArrayList<DataRenderer> = ArrayList<DataRenderer>()
    protected var mChart: ?CombinedChartModel = None

    public init(chart: CombinedChartModel, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart
        this.createRenderers()
    }

    /**
     * Creates the renderers needed for this combined-renderer in the required order. Also takes the DrawOrder into
     * consideration.
     */
    public func createRenderers(): Unit {
        this.mRenderers.clear()

        let chart: ?CombinedChartModel = this.mChart

        if (chart.isNone()) {
            return
        }
        var orders: Array<DrawOrder> = Array<DrawOrder>()
        if(let Some(chart: CombinedChartModel) <- chart) {
            orders = chart.getDrawOrder()
        }

        for (index in 0..orders.size) {
            if (this.mAnimator.isNone() || this.mViewPortHandler.isNone()) {
                break
            }
            match (orders[index]) {
                case DrawOrder.BAR => if (let Some(chart: BarDataProvider) <- (chart)) {
                    if (chart.getBarData().isSome()) {
                        this.mRenderers.append(BarChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }

                case DrawOrder.BUBBLE => if (let Some(chart: BubbleDataProvider) <- chart) {
                    if (chart.getBubbleData().isSome()) {
                        this.mRenderers.append(BubbleChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }

                 case DrawOrder.LINE =>
                    if (let Some(lineChart: LineDataProvider) <- chart) {
                        if (lineChart.getLineData().isSome()) {
                            this.mRenderers.append(LineChartRenderer(lineChart, this.mAnimator(), this.mViewPortHandler()))
                        }
                    }

                case DrawOrder.CANDLE => if (let Some(chart: CandleDataProvider) <- chart) {
                    if (chart.getCandleData().isSome()) {
                        this.mRenderers.append(CandleStickChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()
                        ))
                    }
                }

                case DrawOrder.SCATTER => if (let Some(chart: ScatterDataProvider) <- chart) {
                    if (chart.getScatterData().isSome()) {
                        this.mRenderers.append(ScatterChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }

                case DrawOrder.WATERFALL => if (let Some(chart: WaterfallDataProvider) <- chart) {
                    if (chart.getWaterfallData().isSome()) {
                        this.mRenderers.append(WaterfallChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }
            }
        }

    }


    public func initBuffers(): Unit {
        for (index in 0..this.mRenderers.size) {
            this.mRenderers[index].initBuffers()
        }
    }


    public func drawData(c: CanvasRenderingContext2D): Unit {
        for (index in 0..this.mRenderers.size) {
            this.mRenderers[index].drawData(c)
        }
    }


    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool): Unit {
        for (index in 0..this.mRenderers.size) {
            this.mRenderers[index].drawValues(c, isHorizontalFlip: isHorizontalFlip)
        }
    }


    public func drawExtras(c: CanvasRenderingContext2D): Unit {
        for (index in 0..this.mRenderers.size) {
            this.mRenderers[index].drawExtras(c)
        }
    }

    protected var mHighlightBuffer: ArrayList<Highlight> = ArrayList<Highlight>()


    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>): Unit {
        let chart: ?CombinedChartModel = this.mChart
        if (chart.isNone()) {
            return
        }

        for (index in 0..this.mRenderers.size) {
            this.mRenderers[index].drawExtras(c)
            var data: ?ChartDataWrapper = Option<ChartDataWrapper>.None

            match (this.mRenderers.get(index)) {
                case Some(render: WaterfallChartRenderer) => data = render.mChart.getWaterfallData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                    EntryOhos>
                case Some(render: BarChartRenderer) => data = render.mChart.getBarData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                    EntryOhos>
                case Some(render: LineChartRenderer) => data = render.mChart.getLineData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                    EntryOhos>
                case Some(render: CandleStickChartRenderer) => data = render.mChart.getCandleData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                    EntryOhos>
                case Some(render: ScatterChartRenderer) => data = render.mChart.getScatterData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                    EntryOhos>
                case Some(render: BubbleChartRenderer) => data = render.mChart.getBubbleData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                    EntryOhos>
                case _ => ()
            }

            let dataIndex: Int64 = if (let Some(data) <- data) {
                if (let Some(allData: CombinedData) <- tos<CombinedData>(chart().getData())) {
                    allData.getAllData().indexOf(data)
                }
                -1
            } else {
                -1
            }

            this.mHighlightBuffer.clear()
            for (index in 0..indices.size) {
                if (indices[index].getDataIndex() == dataIndex || indices[index].getDataIndex() == -1) {
                    this.mHighlightBuffer.append(indices[index])
                }
            }

            let bufferSize = this.mHighlightBuffer.size
            var highlightArr = Array<Highlight>(bufferSize, item: Highlight(0.0))
            for (i in 0..bufferSize) {
                highlightArr[i] = this.mHighlightBuffer[i]
            }
            this.mRenderers[index].drawHighlighted(c, highlightArr)
        }
    }

    /**
     * Returns the sub-renderer object at the specified index.
     *
     * @param index
     * @return
     */
    public func getSubRenderer(index: Int64): ?DataRenderer {
        if (index >= this.mRenderers.size || index < 0) {
            return None
        } else {
            return this.mRenderers.get(index)
        }
    }

    /**
     * Returns all sub-renderers.
     *
     * @return
     */
    public func getSubRenderers(): ArrayList<DataRenderer> {
        return this.mRenderers
    }

    public func setSubRenderers(renderers: ArrayList<DataRenderer>): Unit {
        this.mRenderers = renderers
    }
}
