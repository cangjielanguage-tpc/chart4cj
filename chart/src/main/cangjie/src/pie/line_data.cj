/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public class LineData <: BarLineScatterCandleBubbleData<ILineDataSet, EntryOhos> {
    public init() {
        super()
    }
    public init(dataSets: Array<ILineDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }

    public init(dataSets: ArrayList<ILineDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }
}
