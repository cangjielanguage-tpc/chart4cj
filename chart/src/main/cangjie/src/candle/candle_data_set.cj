/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.candle

/**
 * DataSet for the CandleStickChart.
 */
public class CandleDataSet <: LineScatterCandleRadarDataSet<CandleEntry> & ICandleDataSet {
    /**
     * the width of the shadow of the candle
     */
    private var mShadowWidth: Float64 = 3.0
    /**
     * should the candle bars show?
     * when false, only "ticks" will show
     *
     * - default: true
     */
    private var mShowCandleBar: Bool = true
    /**
     * the space between the candle entries, default 0.1f (10%)
     */
    private var mBarSpace: Float64 = 0.1
    /**
     * use candle color for the shadow
     */
    private var mShadowColorSameAsCandle: Bool = false
    /**
     * paint style when open < close
     * increasing candlesticks are traditionally hollow
     */
    protected var mIncreasingPaintStyle: Style = Style.STROKE
    /**
     * paint style when open > close
     * descreasing candlesticks are traditionally filled
     */
    protected var mDecreasingPaintStyle: Style = Style.FILL
    /**
     * color for open == close
     */
    protected var mNeutralColor: UInt32 = ColorTemplate.COLOR_SKIP
    /**
     * color for open < close
     */
    protected var mIncreasingColor: UInt32 = ColorTemplate.COLOR_SKIP
    /**
     * color for open > close
     */
    protected var mDecreasingColor: UInt32 = ColorTemplate.COLOR_SKIP
    /**
     * shadow line color, set -1 for backward compatibility and uses default
     * color
     */
    protected var mShadowColor: UInt32 = ColorTemplate.COLOR_SKIP

    public init(yVals: ArrayList<CandleEntry>, label: String) {
        super(yVals, label)
        this.calcMinMax()
    }

    public func copy(): DataSet<CandleEntry> {
        let entries = ArrayList<CandleEntry>()
        if (let Some(entry) <- this.mEntries) {
            for (i in 0..entry.size) {
                entries.append(entry[i].copy())
            }
        }
        let copied = CandleDataSet(entries, this.getLabel())
        this.copyTo(copied)
        return copied
    }

    protected func copyTo(candleDataSet: CandleDataSet): Unit {
        super.copyTo(candleDataSet)
        candleDataSet.mShadowWidth = this.mShadowWidth
        candleDataSet.mShowCandleBar = this.mShowCandleBar
        candleDataSet.mBarSpace = this.mBarSpace
        candleDataSet.mShadowColorSameAsCandle = this.mShadowColorSameAsCandle
        candleDataSet.mHighLightColor = this.mHighLightColor
        candleDataSet.mIncreasingPaintStyle = this.mIncreasingPaintStyle
        candleDataSet.mDecreasingPaintStyle = this.mDecreasingPaintStyle
        candleDataSet.mNeutralColor = this.mNeutralColor
        candleDataSet.mIncreasingColor = this.mIncreasingColor
        candleDataSet.mDecreasingColor = this.mDecreasingColor
        candleDataSet.mShadowColor = this.mShadowColor
    }

    /**
     * Sets the space that is left out on the left and right side of each
     * candle, default 0.1f (10%), max 0.45f, min 0f
     *
     * @param space
     */
    public func setBarSpace(space: Float64): Unit {
        var spaceTemp = space
        if (space < 0.0) {
            spaceTemp = 0.0
        }

        if (space > 0.45) {
            spaceTemp = 0.45
        }

        this.mBarSpace = spaceTemp
    }

    public func getBarSpace(): Float64 {
        return this.mBarSpace
    }

    /**
     * Sets the width of the candle-shadow-line in pixels. Default 3f.
     *
     * @param width
     */
    public func setShadowWidth(width: Float64): Unit {
        this.mShadowWidth = Utils.handleDataValues(width)
    }

    public func getShadowWidth(): Float64 {
        return this.mShadowWidth
    }

    /**
     * Sets whether the candle bars should show?
     *
     * @param showCandleBar
     */
    public func setShowCandleBar(showCandleBar: Bool): Unit {
        this.mShowCandleBar = showCandleBar
    }

    public func getShowCandleBar(): Bool {
        return this.mShowCandleBar
    }

    /**
     * It is necessary to implement ColorsList class that will encapsulate
     * colors list functionality, because It's wrong to copy paste setColor,
     * addColor, ... resetColors for each time when we want to add a coloring
     * options for one of objects
     *
     *
     */

    /** BELOW THIS COLOR HANDLING */

    /**
     * Sets the one and ONLY color that should be used for this DataSet when
     * open == close.
     *
     * @param color
     */
    public func setNeutralColor(color: UInt32): Unit {
        this.mNeutralColor = color
    }

    public func getNeutralColor(): UInt32 {
        return this.mNeutralColor
    }

    /**
     * Sets the one and ONLY color that should be used for this DataSet when
     * open <= close.
     *
     * @param color
     */
    public func setIncreasingColor(color: UInt32): Unit {
        this.mIncreasingColor = color
    }

    public func getIncreasingColor(): UInt32 {
        return this.mIncreasingColor
    }

    /**
     * Sets the one and ONLY color that should be used for this DataSet when
     * open > close.
     *
     * @param color
     */
    public func setDecreasingColor(color: UInt32): Unit {
        this.mDecreasingColor = color
    }

    public func getDecreasingColor(): UInt32 {
        return this.mDecreasingColor
    }

    public func getIncreasingPaintStyle(): Style {
        return this.mIncreasingPaintStyle
    }

    /**
     * Sets paint style when open < close
     *
     * @param paintStyle
     */
    public func setIncreasingPaintStyle(paintStyle: Style): Unit {
        this.mIncreasingPaintStyle = paintStyle
    }

    public func getDecreasingPaintStyle(): Style {
        return this.mDecreasingPaintStyle
    }

    /**
     * Sets paint style when open > close
     *
     * @param decreasingPaintStyle
     */
    public func setDecreasingPaintStyle(decreasingPaintStyle: Style): Unit {
        this.mDecreasingPaintStyle = decreasingPaintStyle
    }

    public func getShadowColor(): UInt32 {
        return this.mShadowColor
    }

    /**
     * Sets shadow color for all entries
     *
     * @param shadowColor
     */
    public func setShadowColor(shadowColor: UInt32): Unit {
        this.mShadowColor = shadowColor
    }

    public func getShadowColorSameAsCandle(): Bool {
        return this.mShadowColorSameAsCandle
    }

    /**
     * Sets shadow color to be the same color as the candle color
     *
     * @param shadowColorSameAsCandle
     */
    public func setShadowColorSameAsCandle(shadowColorSameAsCandle: Bool): Unit {
        this.mShadowColorSameAsCandle = shadowColorSameAsCandle
    }

    public operator func ==(s: Any): Bool {
        return match (s) {
            case v: BarDataSet => refEq(this, v)
            case _ => false
        }
    }

    public operator func !=(s: Any): Bool {
        return !(this == s)
    }
}
