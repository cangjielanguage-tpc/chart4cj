/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bar

public class BarData <: BarLineScatterCandleBubbleData<IBarDataSet, BarEntry> {
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
    public init(dataSets: Array<IBarDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }
    public init(dataSets: ArrayList<IBarDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }

    /**
     * Sets the width each bar should have on the x-axis (in values, not pixels).
     * Default 0.85f
     *
     * @param mBarWidth
     */
    public func setBarWidth(mBarWidth: Float64): Unit {
        this.mBarWidth = mBarWidth
    }

    public func getBarWidth(): Float64 {
        return this.mBarWidth
    }

    /**
     * 设置顶部圆角半径
     * @param radius 顶部圆角半径
     */
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

    /**
     * Groups all BarDataSet objects this data object holds together by modifying the x-value of their entries.
     * Previously set x-values of entries will be overwritten. Leaves space between bars and groups as specified
     * by the parameters.
     * Do not forget to call notifyDataSetChanged() on your BarChart object after calling this method.
     *
     * @param fromX      the starting point on the x-axis where the grouping should begin
     * @param groupSpace the space between groups of bars in values (not pixels) e.g. 0.8f for bar width 1f
     * @param barSpace   the space between individual bars in values (not pixels) e.g. 0.1f for bar width 1f
     */
    public func groupBars(fromX: Float64, groupSpace: Float64, barSpace: Float64): Unit {
        let dataSets = this.mDataSets
        let setCount: Int64 = dataSets.size
        if (setCount <= 1) {
            throw Exception("BarData needs to hold at least 2 BarDataSets to allow grouping.")
        }

        let max: ?IBarDataSet = this.getMaxEntryCountSet()
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
                    let dataSet: IBarDataSet = dataSets[j]
                    f += barSpaceHalf
                    f += barWidthHalf

                    if (i < dataSet.getEntryCount() /* && dataSet != undefined*/ ) {
                        let entry: ?BarEntry = (dataSet.getEntryForIndex(i)() as BarEntry)

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

    /**
     * In case of grouped bars, this method returns the space an individual group of bar needs on the x-axis.
     *
     * @param groupSpace
     * @param barSpace
     * @return
     */
    public func getGroupWidth(groupSpace: Float64, barSpace: Float64): Float64 {
        return Float64(this.mDataSets.size) * (this.mBarWidth + barSpace) + groupSpace
    }
}
