/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.line

public abstract class LineRadarDataSet<E> <: LineScatterCandleRadarDataSet<E> & ILineRadarDataSet<E> where E <: EntryOhos {
    private var mFillColor: UInt32 = UInt32(ChartColor.rgb(140, 234, 255))
    private var mLinearGradientColors: ?ArrayList<ChartColorStop> = Option<ArrayList<ChartColorStop>>.None

    /**
     * the drawable to be used for filling the line surface
     */
    protected var mFillDrawable: ?ChartPixelMap = Option<ChartPixelMap>.None
    /**
     * transparency used for filling line surface
     */
    private var mFillAlpha: Float64 = 85.0
    /**
     * the width of the drawn data lines
     */
    private var mLineWidth: Float64 = 2.5
    /**
     * if true, the data will also be drawn filled
     */
    private var mDrawFilled: Bool = false

    public init(yVals: ArrayList<E>, label: String) {
        super(yVals, label)
    }

    public func getFillColor(): UInt32 {
        return this.mFillColor
    }

    /**
     * Sets the color that is used for filling the area below the line.
     * Resets an eventually set "fillDrawable".
     *
     * @param color
     */
    public func setFillColor(color: UInt32): Unit {
        this.mFillColor = color
        this.mFillDrawable = None
    }

    public func setGradientFillColor(linearGradientColors: ArrayList<ChartColorStop>): Unit {
        this.mLinearGradientColors = linearGradientColors
        this.mFillDrawable = None
        this.mFillColor = 0
    }

    public func getGradientFillColor(): ?ArrayList<ChartColorStop> {
        return this.mLinearGradientColors
    }

    public func getFillDrawable(): ?ChartPixelMap {
        return this.mFillDrawable
    }

    /**
     * Sets the drawable to be used to fill the area below the line.
     *
     * @param drawable
     */
    public func setFillDrawable(drawable: ChartPixelMap): Unit {
        this.mFillDrawable = drawable
    }

    public func getFillAlpha(): Float64 {
        return this.mFillAlpha
    }

    /**
     * sets the alpha value (transparency) that is used for filling the line
     * surface (0-255), default: 85
     *
     * @param alpha
     */
    public func setFillAlpha(alpha: Float64): Unit {
        this.mFillAlpha = alpha
    }

    /**
     * set the line width of the chart (min = 0.2f, max = 10f) default 1f NOTE:
     * thinner line == better performance, thicker line == worse performance
     *
     * @param width
     */
    public func setLineWidth(width: Float64): Unit {
        if (width < 0.0) {
            this.mLineWidth = 0.0
        }

        if (width > 10.0) {
            this.mLineWidth = 10.0
        }
        this.mLineWidth = width
    }

    public func getLineWidth(): Float64 {
        return this.mLineWidth
    }

    public func setDrawFilled(filled: Bool): Unit {
        this.mDrawFilled = filled
    }

    public func isDrawFilledEnabled(): Bool {
        return this.mDrawFilled
    }

    protected func copyTo(lineRadarDataSet: LineRadarDataSet<E>): Unit {
        super.copyTo(lineRadarDataSet)
        lineRadarDataSet.mDrawFilled = this.mDrawFilled
        lineRadarDataSet.mFillAlpha = this.mFillAlpha
        lineRadarDataSet.mFillColor = this.mFillColor
        lineRadarDataSet.mFillDrawable = this.mFillDrawable
        lineRadarDataSet.mLineWidth = this.mLineWidth
    }
}
