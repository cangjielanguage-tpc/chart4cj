/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public interface IBubbleDataSet <: IBarLineScatterCandleBubbleDataSet<BubblesEntry> {

    /**
     * Sets the width of the circle that surrounds the bubble when highlighted,
     * in vp.
     *
     * @param width
     */
    public func setHighlightCircleWidth(width: Float64): Unit

    public func getMaxSize(): Float64

    public func isNormalizeSizeEnabled(): Bool

    /**
     * Returns the width of the highlight-circle that surrounds the bubble
     * @return
     */
    public func getHighlightCircleWidth(): Float64
}
