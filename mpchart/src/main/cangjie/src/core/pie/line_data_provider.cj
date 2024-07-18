/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

public interface LineDataProvider <: BarLineScatterCandleBubbleDataProvider<LineData, ILineDataSet, EntryOhos> {
    func getLineData(): ?LineData

    func getAxis(dependency: AxisDependency): ?YAxis
}
