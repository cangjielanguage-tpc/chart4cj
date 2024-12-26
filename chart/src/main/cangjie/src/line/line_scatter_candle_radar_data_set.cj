/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

public abstract class LineScatterCandleRadarDataSet<E> <: BarLineScatterCandleBubbleDataSet<E> & ILineScatterCandleRadarDataSet<E> where E <: EntryOhos {
    protected var mDrawVerticalHighlightIndicator: Bool = true
    protected var mDrawHorizontalHighlightIndicator: Bool = true
    /** the width of the highlight indicator lines */
    protected var mHighlightLineWidth: Float64 = 0.5
    /** the path effect for dashed highlight-lines */
    protected var mHighlightDashPathEffect: ?DashPathEffect = None

    public init(yVals: ArrayList<E>, label: String) {
        super(yVals, label)
        this.mHighlightLineWidth = Utils.handleDataValues(0.5)
    }

    /**
     * Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
     * @param enabled
     */
    public func setDrawHorizontalHighlightIndicator(enabled: Bool): Unit {
        this.mDrawHorizontalHighlightIndicator = enabled
    }

    /**
     * Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
     * @param enabled
     */
    public func setDrawVerticalHighlightIndicator(enabled: Bool): Unit {
        this.mDrawVerticalHighlightIndicator = enabled
    }

    /**
     * Enables / disables both vertical and horizontal highlight-indicators.
     * @param enabled
     */
    public func setDrawHighlightIndicators(enabled: Bool): Unit {
        this.setDrawVerticalHighlightIndicator(enabled)
        this.setDrawHorizontalHighlightIndicator(enabled)
    }

    public func isVerticalHighlightIndicatorEnabled(): Bool {
        return this.mDrawVerticalHighlightIndicator
    }

    public func isHorizontalHighlightIndicatorEnabled(): Bool {
        return this.mDrawHorizontalHighlightIndicator
    }

    /**
     * Sets the width of the highlight line in vp.
     * @param width
     */
    public func setHighlightLineWidth(width: Float64): Unit {
        this.mHighlightLineWidth = Utils.handleDataValues(width)
    }

    public func getHighlightLineWidth(): Float64 {
        return this.mHighlightLineWidth
    }

    /**
     * Enables the highlight-line to be drawn in dashed mode, e.g. like this "- - - - - -"
     *
     * @param lineLength the length of the line pieces
     * @param spaceLength the length of space in between the line-pieces
     * @param phase offset, in degrees (normally, use 0)
     */
    public func enableDashedHighlightLine(lineLength: Int64, spaceLength: Int64): Unit {
        let arr = [lineLength, spaceLength]
        this.mHighlightDashPathEffect = DashPathEffect(arr)
    }

    /**
     * Disables the highlight-line to be drawn in dashed mode.
     */
    public func disableDashedHighlightLine(): Unit {
        this.mHighlightDashPathEffect = None
    }

    /**
     * Returns true if the dashed-line effect is enabled for highlight lines, false if not.
     * Default: disabled
     * @return
     */
    public func isDashedHighlightLineEnabled(): Bool {
        return if (this.mHighlightDashPathEffect.isNone()) {
            false
        } else {
            true
        }
    }

    public open func getDashPathEffectHighlight(): ?DashPathEffect {
        return this.mHighlightDashPathEffect
    }

    protected func copyTo(lineScatterCandleRadarDataSet: LineScatterCandleRadarDataSet<E>): Unit {
        super.copyTo(lineScatterCandleRadarDataSet)
        lineScatterCandleRadarDataSet.mDrawHorizontalHighlightIndicator = this.mDrawHorizontalHighlightIndicator
        lineScatterCandleRadarDataSet.mDrawVerticalHighlightIndicator = this.mDrawVerticalHighlightIndicator
        lineScatterCandleRadarDataSet.mHighlightLineWidth = this.mHighlightLineWidth
        lineScatterCandleRadarDataSet.mHighlightDashPathEffect = this.mHighlightDashPathEffect
    }
}
