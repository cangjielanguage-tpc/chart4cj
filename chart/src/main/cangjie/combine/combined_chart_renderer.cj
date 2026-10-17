/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine

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
                        this.mRenderers.add(BarChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }

                case DrawOrder.BUBBLE => if (let Some(chart: BubbleDataProvider) <- chart) {
                    if (chart.getBubbleData().isSome()) {
                        this.mRenderers.add(BubbleChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }

                 case DrawOrder.LINE =>
                    if (let Some(lineChart: LineDataProvider) <- chart) {
                        if (lineChart.getLineData().isSome()) {
                            this.mRenderers.add(LineChartRenderer(lineChart, this.mAnimator(), this.mViewPortHandler()))
                        }
                    }

                case DrawOrder.CANDLE => if (let Some(chart: CandleDataProvider) <- chart) {
                    if (chart.getCandleData().isSome()) {
                        this.mRenderers.add(CandleStickChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()
                        ))
                    }
                }

                case DrawOrder.SCATTER => if (let Some(chart: ScatterDataProvider) <- chart) {
                    if (chart.getScatterData().isSome()) {
                        this.mRenderers.add(ScatterChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
                    }
                }

                case DrawOrder.WATERFALL => if (let Some(chart: WaterfallDataProvider) <- chart) {
                    if (chart.getWaterfallData().isSome()) {
                        this.mRenderers.add(WaterfallChartRenderer(chart, this.mAnimator(), this.mViewPortHandler()))
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

        for (indexT in 0..this.mRenderers.size) {
            this.mRenderers[indexT].drawExtras(c)
            var data: ?ChartDataWrapper = Option<ChartDataWrapper>.None

            match (this.mRenderers.get(indexT)) {
                case Some(render: WaterfallChartRenderer) =>
                    data = CombinedChartDataWrapper<IWaterfallDataSet, WaterfallEntry>(render.mChart.getWaterfallData()())
                case Some(render: BarChartRenderer) =>
                    data = CombinedChartDataWrapper<IBarDataSet, BarEntry>(render.mChart.getBarData()())
                case Some(render: LineChartRenderer) =>
                    data = CombinedChartDataWrapper<ILineDataSet, EntryOhos>(render.mChart.getLineData()())
                case Some(render: CandleStickChartRenderer) =>
                    data = CombinedChartDataWrapper<ICandleDataSet, CandleEntry>(render.mChart.getCandleData()())
                case Some(render: ScatterChartRenderer) =>
                    data = CombinedChartDataWrapper<IScatterDataSet, EntryOhos>(render.mChart.getScatterData()())
                case Some(render: BubbleChartRenderer) =>
                    data = CombinedChartDataWrapper<IBubbleDataSet, BubblesEntry>(render.mChart.getBubbleData()())

                case _ => ()
            }

            let dataIndex: Int64 = if (let Some(dataT) <- data) {
                if (let Some(allData: CombinedData) <- tos<CombinedData>(chart().getData())) {
                    indexofT(dataT, allData.getAllData())
                } else {
                    -1
                }
            } else {
                -1
            }

            this.mHighlightBuffer.clear()
            for (index in 0..indices.size) {
                if (indices[index].getDataIndex() == dataIndex || indices[index].getDataIndex() == -1) {
                    this.mHighlightBuffer.add(indices[index])
                }
            }

            this.mRenderers[indexT].drawHighlighted(c, this.mHighlightBuffer.toArray())
        }
    }

    public func indexofT(dataT: ChartDataWrapper, dataObjects: ArrayList<ChartDataWrapper>): Int64 {
        for( i in 0..dataObjects.size) {
            let dataObject: ? ChartDataWrapper = dataObjects.get(i)
            match(dataObject) {
                case Some(bubbledata: CombinedChartDataWrapper<IBubbleDataSet, BubblesEntry>) =>
                    if(dataT is CombinedChartDataWrapper<IBubbleDataSet, BubblesEntry>) {
                        return i
                    }
                case Some(scatterdata: CombinedChartDataWrapper<IScatterDataSet, EntryOhos>) =>
                    if(dataT is CombinedChartDataWrapper<IScatterDataSet, EntryOhos>) {
                        return i
                    }
                case Some(linedata: CombinedChartDataWrapper<ILineDataSet, EntryOhos>) =>
                    if(dataT is CombinedChartDataWrapper<ILineDataSet, EntryOhos>) {
                        return i
                    }
                case Some(waterfalldata: CombinedChartDataWrapper<IWaterfallDataSet, WaterfallEntry>) =>
                    if(dataT is CombinedChartDataWrapper<IWaterfallDataSet, WaterfallEntry>) {
                        return i
                    }
                case Some(candledata: CombinedChartDataWrapper<ICandleDataSet, CandleEntry>) =>
                    if(dataT is CombinedChartDataWrapper<ICandleDataSet, CandleEntry>) {
                        return i
                    }
                case Some(bardata: CombinedChartDataWrapper<IBarDataSet, BarEntry>) =>
                    if(dataT is CombinedChartDataWrapper<IBarDataSet, BarEntry>) {
                        return i
                    }
                case _=> return -1
            }
        }
        return -1
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
