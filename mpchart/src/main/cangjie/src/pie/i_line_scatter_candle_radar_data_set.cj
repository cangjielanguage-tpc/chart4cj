/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public interface ILineScatterCandleRadarDataSet<E> <: IBarLineScatterCandleBubbleDataSet<E> where E <: EntryOhos {

    /**
     * Returns true if vertical highlight indicator lines are enabled (drawn)
     * @return
     */
    func isVerticalHighlightIndicatorEnabled(): Bool

    /**
     * Returns true if vertical highlight indicator lines are enabled (drawn)
     * @return
     */
    func isHorizontalHighlightIndicatorEnabled(): Bool

    /**
     * Returns the line-width in which highlight lines are to be drawn.
     * @return
     */
    func getHighlightLineWidth(): Float64

    /**
     * Returns the DashPathEffect that is used for highlighting.
     * @return
     */
    func getDashPathEffectHighlight(): ?DashPathEffect
}
