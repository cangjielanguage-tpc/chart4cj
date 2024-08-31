/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public class YAxis <: AxisBase {
    private var mDrawBottomYLabelEntry: Bool = true

    private var mDrawTopYLabelEntry: Bool = true
    /**
     * flag that indicates if the axis is inverted or not
     */
    protected var mInverted: Bool = false
    /**
     * flag that indicates if the zero-line should be drawn regardless of other grid lines
     */
    protected var mDrawZeroLine: Bool = false
    /**
     * flag indicating that auto scale min restriction should be used
     */
    private var mUseAutoScaleRestrictionMin: Bool = false
    /**
     * flag indicating that auto scale max restriction should be used
     */
    private var mUseAutoScaleRestrictionMax: Bool = false
    /**
     * Color of the zero line
     */
    protected var mZeroLineColor: Color = Color.GRAY
    /**
     * Width of the zero line in pixels
     */
    protected var mZeroLineWidth: Float64 = 1.0
    /**
     * axis space from the largest value to the top in percent of the total axis range
     */
    protected var mSpacePercentTop: Float64 = 10.0
    /**
     * axis space from the smallest value to the bottom in percent of the total axis range
     */
    protected var mSpacePercentBottom: Float64 = 10.0
    /**
     * the position of the y-labels relative to the chart
     */
    private var mPosition: YAxisLabelPosition = YAxisLabelPosition.OUTSIDE_CHART
    /**
     * the horizontal offset of the y-label
     */
    private var mXLabelOffset: Float64 = 0.0
    /**
     * the side this axis object represents
     */
    private var mAxisDependency: AxisDependency
    /**
     * the minimum width that the axis should take (in vp).
     * <p/>
     * default: 0.0
     */
    protected var mMinWidth: Float64 = 0.0
    /**
     * the maximum width that the axis can take (in vp).
     * use Inifinity for disabling the maximum
     * default: Float.POSITIVE_INFINITY (no maximum specified)
     */
    protected var mMaxWidth: Float64 = Float64.Max

    public init(position: ?AxisDependency) {
        super()

        // default left
        if (position.isNone()) {
            this.mAxisDependency = AxisDependency.LEFT
        } else {
            this.mAxisDependency = position()
        }
        this.mYOffset = 0.0
    }

    public func getAxisDependency(): AxisDependency {
        return this.mAxisDependency
    }

    /**
     * @return the minimum width that the axis should take (in vp).
     */
    public func getMinWidth(): Float64 {
        return this.mMinWidth
    }

    /**
     * Sets the minimum width that the axis should take (in vp).
     *
     * @param minWidth
     */
    public func setMinWidth(minWidth: Float64): Unit {
        this.mMinWidth = minWidth
    }

    /**
     * @return the maximum width that the axis can take (in vp).
     */
    public func getMaxWidth(): Float64 {
        return this.mMaxWidth
    }

    /**
     * Sets the maximum width that the axis can take (in vp).
     *
     * @param maxWidth
     */
    public func setMaxWidth(maxWidth: Float64): Unit {
        this.mMaxWidth = maxWidth
    }

    /**
     * returns the position of the y-labels
     */
    public func getLabelPosition(): YAxisLabelPosition {
        return this.mPosition
    }

    /**
     * sets the position of the y-labels
     *
     * @param pos
     */
    public func setPosition(pos: YAxisLabelPosition): Unit {
        this.mPosition = pos
    }

    /**
     * returns the horizontal offset of the y-label
     */
    public func getLabelXOffset(): Float64 {
        return this.mXLabelOffset
    }

    /**
     * sets the horizontal offset of the y-label
     *
     * @param xOffset
     */
    public func setLabelXOffset(xOffset: Float64): Unit {
        this.mXLabelOffset = xOffset
    }

    /**
     * returns true if drawing the top y-axis label entry is enabled
     *
     * @return
     */
    public func isDrawTopYLabelEntryEnabled(): Bool {
        return this.mDrawTopYLabelEntry
    }

    /**
     * returns true if drawing the bottom y-axis label entry is enabled
     *
     * @return
     */
    public func isDrawBottomYLabelEntryEnabled(): Bool {
        return this.mDrawBottomYLabelEntry
    }

    /**
     * set this to true to enable drawing the top y-label entry. Disabling this can be helpful
     * when the top y-label and
     * left x-label interfere with each other. default: true
     *
     * @param enabled
     */
    public func setDrawTopYLabelEntry(enabled: Bool): Unit {
        this.mDrawTopYLabelEntry = enabled
    }

    /**
     * If this is set to true, the y-axis is inverted which means that low values are on top of
     * the chart, high values
     * on bottom.
     *
     * @param enabled
     */
    public func setInverted(enabled: Bool): Unit {
        this.mInverted = enabled
    }

    /**
     * If this returns true, the y-axis is inverted.
     *
     * @return
     */
    public func isInverted(): Bool {
        return this.mInverted
    }

    /**
     * Sets the top axis space in percent of the full range. Default 10f
     *
     * @param percent
     */
    public func setSpaceTop(percent: Float64): Unit {
        this.mSpacePercentTop = percent
    }

    /**
     * Returns the top axis space in percent of the full range. Default 10f
     *
     * @return
     */
    public func getSpaceTop(): Float64 {
        return this.mSpacePercentTop
    }

    /**
     * Sets the bottom axis space in percent of the full range. Default 10f
     *
     * @param percent
     */
    public func setSpaceBottom(percent: Float64): Unit {
        this.mSpacePercentBottom = percent
    }

    /**
     * Returns the bottom axis space in percent of the full range. Default 10f
     *
     * @return
     */
    public func getSpaceBottom(): Float64 {
        return this.mSpacePercentBottom
    }

    public func isDrawZeroLineEnabled(): Bool {
        return this.mDrawZeroLine
    }

    /**
     * Set this to true to draw the zero-line regardless of weather other
     * grid-lines are enabled or not. Default: false
     *
     * @param mDrawZeroLine
     */
    public func setDrawZeroLine(mDrawZeroLine: Bool): Unit {
        this.mDrawZeroLine = mDrawZeroLine
    }

    public func getZeroLineColor(): Color {
        return this.mZeroLineColor
    }

    /**
     * Sets the color of the zero line
     *
     * @param color
     */
    public func setZeroLineColor(color: Color): Unit {
        this.mZeroLineColor = color
    }

    public func getZeroLineWidth(): Float64 {
        return this.mZeroLineWidth
    }

    /**
     * Sets the width of the zero line in vp
     *
     * @param width
     */
    public func setZeroLineWidth(width: Float64): Unit {
        this.mZeroLineWidth = Utils.handleDataValues(width)
    }

    /**
     * This is for normal (not horizontal) charts horizontal spacing.
     *
     * @param p
     * @return
     */
    public func getRequiredWidthSpace(p: Paint): Float64 {
        p.setTextSize(this.mTextSize)

        var label: String = super.getLongestLabel()
        var width: Float64 = Utils.calcTextWidth(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), p, label) + super.getXOffset() * 2.0

        var minWidth: Float64 = this.getMinWidth()
        var maxWidth: Float64 = this.getMaxWidth()

        if (minWidth > 0.00) {
            minWidth = Utils.handleDataValues(minWidth)
        }
        if (maxWidth > 0.0 && maxWidth != Float64.Max) {
            maxWidth = Utils.handleDataValues(maxWidth)
        }

        var mins: Float64
        if (maxWidth > 0.0) {
            mins = maxWidth
        } else {
            mins = width
        }

        width = max(minWidth, min(width, mins))

        return width
    }

    /**
     * This is for HorizontalBarChart vertical spacing.
     *
     * @param p
     * @return
     */
    public func getRequiredHeightSpace(p: Paint): Float64 {
        p.setTextSize(this.mTextSize)

        let label: String = super.getLongestLabel()
        return Utils.calcTextHeight(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), p, label) + super.getYOffset() * 2.0
    }

    /**
     * Returns true if this axis needs horizontal offset, false if no offset is needed.
     *
     * @return
     */
    public func needsOffset(): Bool {
        if (super.isEnabled() && super.isDrawLabelsEnabled() && this.getLabelPosition() == YAxisLabelPosition.
            OUTSIDE_CHART) {
            return true
        } else {
            return false
        }
    }

    public func calculate(dataMin: Float64, dataMax: Float64): Unit {
        var min: Float64 = dataMin
        var max: Float64 = dataMax
        // Make sure max is greater than min
        if (min > max) {
            if (this.mCustomAxisMax && this.mCustomAxisMin) {
                let t: Float64 = min
                min = max
                max = t
            } else if (this.mCustomAxisMax) {
                if (max < 0.0) {
                    min = max * 1.5
                } else {
                    min = max * 0.5
                }
            } else if (this.mCustomAxisMin) {
                if (min < 0.0) {
                    max = min * 0.5
                } else {
                    max = min * 1.5
                }
            }
        }

        var range: Float64 = abs(max - min)

        // in case all values are equal
        if (range == 0.0) {
            max = max + 1.0
            min = min - 1.0
        }

        // recalculate
        range = abs(max - min)
        // calc extra spacing
        if (this.mCustomAxisMin) {
            this.mAxisMinimum = this.mAxisMinimum
        } else {
            this.mAxisMinimum = min - (range / 100.0) * this.getSpaceBottom()
        }

        if (this.mCustomAxisMax) {
            this.mAxisMaximum = this.mAxisMaximum
        } else {
            this.mAxisMaximum = max + (range / 100.0) * this.getSpaceTop()
        }
        this.mAxisRange = abs(this.mAxisMinimum - this.mAxisMaximum)
    }
}
