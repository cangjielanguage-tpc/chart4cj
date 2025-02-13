/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.scatter

public class ScatterData <: BarLineScatterCandleBubbleData<IScatterDataSet, EntryOhos> {
    public init() {
        super()
    }

    public init(dataSets: ArrayList<IScatterDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }

    /**
     * Returns the maximum shape-size across all DataSets.
     *
     * @return
     */
    public func getGreatestShapeSize() {
        var maxs: Float64 = 0.0
        for (i in 0..this.mDataSets.size) {
            let set: IScatterDataSet = this.mDataSets[i]
            let size: Float64 = set.getScatterShapeSize()
            if (size > maxs) {
                maxs = size
            }
        }
        return maxs
    }
}
