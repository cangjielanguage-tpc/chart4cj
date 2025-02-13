/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public interface ILineRadarDataSet<E> <: ILineScatterCandleRadarDataSet<E> where E <: EntryOhos {

    /**
     * Returns the color that is used for filling the line surface area.
     *
     * @return
     */
    func getFillColor(): UInt32

    /**
     * Returns the drawable used for filling the area below the line.
     *
     * @return
     */
    func getFillDrawable(): ?ChartPixelMap

    /**
     * Returns the alpha value that is used for filling the line surface,
     * default: 85
     *
     * @return
     */
    func getFillAlpha(): Float64

    /**
     * Returns the stroke-width of the drawn line
     *
     * @return
     */
    func getLineWidth(): Float64

    /**
     * Returns true if filled drawing is enabled, false if not
     *
     * @return
     */
    func isDrawFilledEnabled(): Bool

    /**
     * Set to true if the DataSet should be drawn filled (surface), and not just
     * as a line, disabling this will give great performance boost. Please note that this method
     * uses the canvas.clipPath(...) method for drawing the filled area.
     * be turned off. Default: false
     *
     * @param enabled
     */
    func setDrawFilled(enabled: Bool): Unit

    func getGradientFillColor(): ?ArrayList<ChartColorStop>

    func setGradientFillColor(linearGradientColors: ArrayList<ChartColorStop>): Unit
}

public type ChartColorStop = (UInt32, Float64)