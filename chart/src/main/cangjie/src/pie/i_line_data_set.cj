/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public interface ILineDataSet <: ILineRadarDataSet<EntryOhos> {
    /**
     * Returns the drawing mode for this line dataset
     *
     * @return
     */
    func getMode(): Mode

    /**
     * Returns the intensity of the cubic lines (the effect intensity).
     * Max = 1f = very cubic, Min = 0.05f = low cubic effect, Default: 0.2f
     *
     * @return
     */
    func getCubicIntensity(): Float64

    /**
     * Returns the size of the drawn circles.
     */
    func getCircleRadius(): Float64

    /**
     * Returns the hole radius of the drawn circles.
     */
    func getCircleHoleRadius(): Float64

    /**
     * Returns the color at the given index of the DataSet's circle-color array.
     * Performs a IndexOutOfBounds check by modulus.
     *
     * @param index
     * @return
     */
    func getCircleColorByIndex(index: Int64): UInt32

    func getCircleColor(index: Int64): UInt32

    /**
     * Returns the number of colors in this DataSet's circle-color array.
     *
     * @return
     */
    func getCircleColorCount(): Int64

    /**
     * Returns true if drawing circles for this DataSet is enabled, false if not
     *
     * @return
     */
    func isDrawCirclesEnabled(): Bool

    /**
     * Returns the color of the inner circle (the circle-hole).
     *
     * @return
     */
    func getCircleHoleColor(): UInt32

    /**
     * Returns true if drawing the circle-holes is enabled, false if not.
     *
     * @return
     */
    func isDrawCircleHoleEnabled(): Bool

    func isDrawSteppedEnabled(): Bool

    /**
     * Returns the DashPathEffect that is used for drawing the lines.
     *
     * @return
     */
    func getDashPathEffect(): ?DashPathEffect

    /**
     * Returns true if the dashed-line effect is enabled, false if not.
     * If the DashPathEffect object is null, also return false here.
     *
     * @return
     */
    func isDashedLineEnabled(): Bool

    /**
     * Returns the IFillFormatter that is set for this DataSet.
     *
     * @return
     */
    func getFillFormatter(): IFillFormatter
}
