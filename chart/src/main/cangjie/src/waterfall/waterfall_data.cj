/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.waterfall

public class WaterfallData <: BarLineScatterCandleBubbleData<IWaterfallDataSet, WaterfallEntry> {
    /**
     * the width of the bars on the x-axis, in values (not pixels)
     */
    private var mBarWidth: Float64 = 0.85

    /**
     * 顶部圆角半径
     */
    private var topRadius: Float64 = 0.0

    public init() {
        super()
    }
    public init(dataSets: Array<IWaterfallDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }
    public init(dataSets: ArrayList<IWaterfallDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }

    public func setBarWidth(mBarWidth: Float64): Unit {
        this.mBarWidth = mBarWidth
    }

    public func getBarWidth(): Float64 {
        return this.mBarWidth
    }

    public func setTopRadius(radius: Float64): Unit {
        var r = radius
        if (r < 0.0) {
            r = 0.0
        }
        this.topRadius = r
    }

    public func getTopRadius(): Float64 {
        return this.topRadius
    }

    public func groupBars(fromX: Float64, groupSpace: Float64, barSpace: Float64): Unit {
        let dataSets = this.mDataSets
        let setCount: Int64 = dataSets.size
        if (setCount <= 1) {
            throw Exception("BarData needs to hold at least 2 BarDataSets to allow grouping.")
        }

        let max: ?IWaterfallDataSet = this.getMaxEntryCountSet()
        if (let Some(m) <- max) {
            let maxEntryCount: Int64 = m.getEntryCount()

            let groupSpaceWidthHalf: Float64 = groupSpace / 2.0
            let barSpaceHalf: Float64 = barSpace / 2.0
            let barWidthHalf: Float64 = this.mBarWidth / 2.0

            let interval: Float64 = this.getGroupWidth(groupSpace, barSpace)
            var f = fromX
            for (i in 0..maxEntryCount) {
                var start: Float64 = f
                f += groupSpaceWidthHalf

                for (j in 0..dataSets.size) {
                    let dataSet: IWaterfallDataSet = dataSets[j]
                    f += barSpaceHalf
                    f += barWidthHalf

                    if (i < dataSet.getEntryCount() /* && dataSet != undefined*/ ) {
                        let entry: ?BarEntry = (dataSet.getEntryForIndex(i) as BarEntry)

                        if (let Some(e) <- entry) {
                            e.setX(f)
                        }
                    }

                    f += barWidthHalf
                    f += barSpaceHalf
                }

                f += groupSpaceWidthHalf
                let end: Float64 = f
                let innerInterval: Float64 = end - start
                let diff: Float64 = interval - innerInterval

                // correct rounding errors
                if (diff > 0.0 || diff < 0.0) {
                    f += diff
                }
            }

            this.notifyDataChanged()
        }
    }

    public func getGroupWidth(groupSpace: Float64, barSpace: Float64): Float64 {
        return Float64(this.mDataSets.size) * (this.mBarWidth + barSpace) + groupSpace
    }
}
