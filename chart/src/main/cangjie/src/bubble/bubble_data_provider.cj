/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bubble

public interface BubbleDataProvider <: BarLineScatterCandleBubbleDataProvider<BubbleData, IBubbleDataSet, BubblesEntry> {
    func getBubbleData(): ?BubbleData
}
