/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bar

public interface BarDataProvider <: BarLineScatterCandleBubbleDataProvider<BarData, IBarDataSet, BarEntry> {
    func getBarData(): ?BarData

    func isDrawBarShadowEnabled(): Bool

    func isDrawValueAboveBarEnabled(): Bool

    func isHighlightFullBarEnabled(): Bool
}
