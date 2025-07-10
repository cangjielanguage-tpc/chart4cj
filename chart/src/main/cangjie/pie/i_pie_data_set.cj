/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public interface  IPieDataSet <: IDataSet<PiEntry> {

    /**
     * Returns the space that is set to be between the piechart-slices of this
     * DataSet, in pixels.
     *
     * @return
     */
     func getSliceSpace(): Float64

    /**
     * When enabled, slice spacing will be 0.0 when the smallest value is going to be
     *   smaller than the slice spacing itself.
     *
     * @return
     */
     func isAutomaticallyDisableSliceSpacingEnabled(): Bool

    /**
     * Returns the distance a highlighted piechart slice is "shifted" away from
     * the chart-center in vp.
     *
     * @return
     */
     func getSelectionShift(): Float64

     func getXValuePosition(): ValuePosition

     func getYValuePosition(): ValuePosition

    /**
     * When valuePosition is OutsideSlice, indicates line color
     * */
     func getValueLineColor(): UInt32

    /**
     * When valuePosition is OutsideSlice and enabled, line will have the same color as the slice
     * */
     func isUseValueColorForLineEnabled(): Bool

    /**
     *  When valuePosition is OutsideSlice, indicates line width
     *  */
     func getValueLineWidth(): Float64

    /**
     * When valuePosition is OutsideSlice, indicates offset as percentage out of the slice size
     * */
     func getValueLinePart1OffsetPercentage(): Float64

    /**
     * When valuePosition is OutsideSlice, indicates length of first half of the line
     * */
     func getValueLinePart1Length(): Float64

    /**
     * When valuePosition is OutsideSlice, indicates length of second half of the line
     * */
     func getValueLinePart2Length(): Float64

    /**
     * When valuePosition is OutsideSlice, this allows variable line length
     * */
     func isValueLineVariableLength(): Bool

    /**
     * Gets the color for the highlighted sector
     * */
     func getHighlightColor(): ?UInt32
}
