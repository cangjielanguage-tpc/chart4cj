/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine

public class CombinedData <: BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos> {
    private var mWaterfallData: ?WaterfallData = None // BarLineScatterCandleBubbleData<IWaterfallDataSet, WaterfallEntry>
    private var mLineData: ?LineData = None // BarLineScatterCandleBubbleData<ILineDataSet, EntryOhos>
    private var mBarData: ?BarData = None // BarLineScatterCandleBubbleData<IBarDataSet, BarEntry>
    private var mScatterData: ?ScatterData = None // BarLineScatterCandleBubbleData<IScatterDataSet, EntryOhos>
    private var mCandleData: ?CandleData = None // BarLineScatterCandleBubbleData<ICandleDataSet, CandleEntry>
    private var mBubbleData: ?BubbleData = None // BarLineScatterCandleBubbleData<IBubbleDataSet, BubblesEntry>

    public init() {
        super()
    }

    public func setLineData(data: LineData) {
        this.mLineData = data
        this.notifyDataChanged()
    }

    public func setBarData(data: BarData) {
        this.mBarData = data
        this.notifyDataChanged()
    }

    public func setCandleData(data: CandleData) {
        this.mCandleData = data
        this.notifyDataChanged()
    }

    public func setBubbleData(data: BubbleData) {
        this.mBubbleData = data
        this.notifyDataChanged()
    }

    public func setScatterData(data: ScatterData) {
        this.mScatterData = data
        this.notifyDataChanged()
    }

    public func setWaterfallData(data: WaterfallData) {
        this.mWaterfallData = data
        this.notifyDataChanged()
    }

    public override func calcMinMax(): Unit {
        this.mDataSets.clear()

        this.mYMax = -Float64.Max
        this.mYMin = Float64.Max
        this.mXMax = -Float64.Max
        this.mXMin = Float64.Max

        let allData: ArrayList<ChartDataWrapper> = this.getAllData()
        for (data in allData) {
            data.calcMinMax()
            let sets = data.getDataSets()
            this.mDataSets.add(all: sets)

            if (data.getYMax() > this.mYMax) {
                this.mYMax = data.getYMax()
            }
            if (data.getYMin() < this.mYMin) {
                this.mYMin = data.getYMin()
            }
            if (data.getXMax() > this.mXMax) {
                this.mXMax = data.getXMax()
            }
            if (data.getXMin() < this.mXMin) {
                this.mXMin = data.getXMin()
            }

            for (dataset in sets) {
                if (dataset.getAxisDependency() == AxisDependency.LEFT) {
                    if (dataset.getYMax() > this.mLeftAxisMax) {
                        this.mLeftAxisMax = dataset.getYMax()
                    }
                    if (dataset.getYMin() < this.mLeftAxisMin) {
                        this.mLeftAxisMin = dataset.getYMin()
                    }
                } else {
                    if (dataset.getYMax() > this.mRightAxisMax) {
                        this.mRightAxisMax = dataset.getYMax()
                    }
                    if (dataset.getYMin() < this.mRightAxisMin) {
                        this.mRightAxisMin = dataset.getYMin()
                    }
                }
            }
        }
    }

    public func getBubbleData(): ?BubbleData {
        return this.mBubbleData
    }

    public func getLineData(): ?LineData {

        return this.mLineData
    }

    public func getBarData(): ?BarData {
        return this.mBarData
    }

    public func getScatterData(): ?ScatterData {
        return this.mScatterData
    }

    public func getCandleData(): ?CandleData {
        return this.mCandleData
    }

    public func getWaterfallData(): ?WaterfallData {
        return this.mWaterfallData
    }

    public func getAllData(): ArrayList<ChartDataWrapper> {
        let data: ArrayList<ChartDataWrapper> = ArrayList<ChartDataWrapper>()
        if (let Some(mWaterfallData) <- this.mWaterfallData) {
            data.add(CombinedChartDataWrapper(mWaterfallData))
        }
        if (let Some(mLineData) <- this.mLineData) {
            data.add(CombinedChartDataWrapper(mLineData))
        }
        if (let Some(mBarData) <- this.mBarData) {
            data.add(CombinedChartDataWrapper(mBarData))
        }
        if (let Some(mScatterData) <- this.mScatterData) {
            data.add(CombinedChartDataWrapper(mScatterData))
        }
        if (let Some(mCandleData) <- this.mCandleData) {
            data.add(CombinedChartDataWrapper(mCandleData))
        }
        if (let Some(mBubbleData) <- this.mBubbleData) {
            data.add(CombinedChartDataWrapper(mBubbleData))
        }
        return data
    }

    public func getDataByIndex(index: Int64): ChartDataWrapper {
        return this.getAllData()[index]
    }

    public func notifyDataChanged(): Unit {
        if (let Some(mWaterfallData) <- this.mWaterfallData) {
            mWaterfallData.notifyDataChanged()
        }

        if (let Some(mLineData) <- this.mLineData) {
            mLineData.notifyDataChanged()
        }

        if (let Some(mBarData) <- this.mBarData) {
            mBarData.notifyDataChanged()
        }

        if (let Some(mCandleData) <- this.mCandleData) {
            mCandleData.notifyDataChanged()
        }

        if (let Some(mScatterData) <- this.mScatterData) {
            mScatterData.notifyDataChanged()
        }

        if (let Some(mBubbleData) <- this.mBubbleData) {
            mBubbleData.notifyDataChanged()
        }

        this.calcMinMax() // recalculate everything
    }

    /**
     * Get the Entry for a corresponding highlight object
     *
     * @param highlight
     * @return the entry that is highlighted
     */
    public func getEntryForHighlight(highlight: Highlight): ?EntryOhos {
        if (highlight.getDataIndex() >= this.getAllData().size) {
            return Option<EntryOhos>.None
        }

        let data: ChartDataWrapper = this.
            getDataByIndex(highlight.getDataIndex())

        if (highlight.getDataSetIndex() >= data.getDataSetCount()) {
            return Option<EntryOhos>.None
        }

        // The value of the highlighted entry could be NaN -
        //   if we are not interested in highlighting a specific value.

        let dataSet = data.getDataSetByIndex(highlight.getDataSetIndex())
        if (dataSet.isNone()) {
            return Option<EntryOhos>.None
        }
        let entries: ?ArrayList<EntryOhos> = dataSet().getEntriesForXValue(highlight.getX())

        if (let Some(entries) <- entries) {
            for (i in 0..entries.size) {
                let entry = entries[i]
                if (entry.getY() == highlight.getY() || highlight.getY().isNaN()) {
                    return entry
                }
            }
        } else {
            return Option<EntryOhos>.None
        }

        return Option<EntryOhos>.None
    }

    /**
     * Get dataset for highlight
     *
     * @param highlight current highlight
     * @return dataset related to highlight
     */
    public func getDataSetByHighlight(highlight: Highlight): ?IBarLineScatterCandleBubbleDataSet<EntryOhos> {
        if (highlight.getDataIndex() >= this.getAllData().size) {
            return None
        }

        let data: ChartDataWrapper = this.
            getDataByIndex(highlight.getDataIndex())

        if (highlight.getDataSetIndex() >= data.getDataSetCount()) {
            return None
        }

        return data.getDataSets()[(highlight.getDataSetIndex())]
    }

    public func getDataIndex(
        data: ChartDataWrapper): Int64 {
        return this.getAllData().indexOf(data)
    }

    public func removeDataSet(d: IBarLineScatterCandleBubbleDataSet<EntryOhos>): Bool {
        let allData: ArrayList<ChartDataWrapper> = this.
            getAllData()

        var success: Bool = false

        for (i in 0..allData.size) {
            let data = allData[i]
            success = data.removeDataSet(d)

            if (success) {
                break
            }
        }

        return success
    }
}
