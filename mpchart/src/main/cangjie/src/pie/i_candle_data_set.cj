/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public interface ICandleDataSet <: ILineScatterCandleRadarDataSet<CandleEntry> {

    /**
     * Returns the space that is left out on the left and right side of each
     * candle.
     *
     * @return
     */
    func getBarSpace(): Float64

    /**
     * Returns whether the candle bars should show?
     * When false, only "ticks" will show
     *
     * - default: true
     *
     * @return
     */
    func getShowCandleBar(): Bool

    /**
     * Returns the width of the candle-shadow-line in pixels.
     *
     * @return
     */
    func getShadowWidth(): Float64

    /**
     * Returns shadow color for all entries
     *
     * @return
     */
    func getShadowColor(): UInt32

    /**
     * Returns the neutral color (for open == close)
     *
     * @return
     */
    func getNeutralColor(): UInt32

    /**
     * Returns the increasing color (for open < close).
     *
     * @return
     */
    func getIncreasingColor(): UInt32

    /**
     * Returns the decreasing color (for open > close).
     *
     * @return
     */
    func getDecreasingColor(): UInt32

    /**
     * Returns paint style when open < close
     *
     * @return
     */
    func getIncreasingPaintStyle(): Style

    /**
     * Returns paint style when open > close
     *
     * @return
     */
    func getDecreasingPaintStyle(): Style

    /**
     * Is the shadow color same as the candle color?
     *
     * @return
     */
    func getShadowColorSameAsCandle(): Bool
}
