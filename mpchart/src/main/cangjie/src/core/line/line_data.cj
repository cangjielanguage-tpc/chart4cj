/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.line

public class LineData <: BarLineScatterCandleBubbleData<ILineDataSet, EntryOhos> {
    public init() {
        super()
    }
    public init(dataSets: Array<ILineDataSet>) {
        super(dataSets)
    }

    public init(dataSets: ArrayList<ILineDataSet>) {
        super(dataSets)
    }
}
