/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bubble

public class BubbleData <: BarLineScatterCandleBubbleData<IBubbleDataSet, BubblesEntry> {
    public init() {
        super()
    }

    public init(sets: ArrayList<IBubbleDataSet>) {
        super(sets)
        this.notifyDataChanged()
    }

    /**
     * Sets the width of the circle that surrounds the bubble when highlighted
     * for all DataSet objects this data object contains, in vp.
     *
     * @param width
     */
    public func setHighlightCircleWidth(width: Float64): Unit {
        let dataSource = this.mDataSets

        for (sets in dataSource) {
            sets.setHighlightCircleWidth(width)
        }
    }
}
