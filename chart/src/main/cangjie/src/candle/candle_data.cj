/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.candle

public class CandleData <: BarLineScatterCandleBubbleData<ICandleDataSet, CandleEntry> {
    public init() {
        super()
    }

    public init(dataSets: Array<ICandleDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }

    public init(dataSets: ArrayList<ICandleDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }
}
