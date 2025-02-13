/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public interface IBarDataSet <: IBarLineScatterCandleBubbleDataSet<BarEntry> {
    public func getFills(): ?ArrayList<Fill>

    public func getFill(index: Int64): Fill

    /**
     * Returns true if this DataSet is stacked (stacksize > 1) or not.
     *
     * @return
     */
    public func isStacked(): Bool

    /**
     * Returns the maximum number of bars that can be stacked upon another in
     * this DataSet. This should return 1 for non stacked bars, and > 1 for stacked bars.
     *
     * @return
     */
    public func getStackSize(): Int64

    /**
     * Returns the color used for drawing the bar-shadows. The bar shadows is a
     * surface behind the bar that indicates the maximum value.
     *
     * @return
     */
    public func getBarShadowColor(): UInt32

    /**
     * Returns the width used for drawing borders around the bars.
     * If borderWidth == 0, no border will be drawn.
     *
     * @return
     */
    public func getBarBorderWidth(): Float64

    /**
     * Returns the color drawing borders around the bars.
     *
     * @return
     */
    public func getBarBorderColor(): UInt32

    /**
     * Returns the alpha value (transparency) that is used for drawing the
     * highlight indicator.
     *
     * @return
     */
    public func getHighLightAlpha(): Float64

    /**
     * Returns the labels used for the different value-stacks in the legend.
     * This is only relevant for stacked bar entries.
     *
     * @return
     */
    public func getStackLabels(): Array<String>
}
