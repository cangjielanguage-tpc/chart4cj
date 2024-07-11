/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.waterfall

public interface WaterfallDataProvider <: BarLineScatterCandleBubbleDataProvider<WaterfallData,IWaterfallDataSet, WaterfallEntry> {
    func getWaterfallData(): ?WaterfallData
    func isDrawBarShadowEnabled(): Bool

    func isDrawValueAboveBarEnabled(): Bool

    func isHighlightFullBarEnabled(): Bool
}
