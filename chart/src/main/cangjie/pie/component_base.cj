/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public abstract class ComponentBase {
    protected var mEnabled: Bool = true
    /**
     * the offset in pixels this component has on the x-axis
     */
    protected var mXOffset: Float64 = 5.0
    /**
     * the offset in pixels this component has on the Y-axis
     */
    protected var mYOffset: Float64 = 5.0
    /**
     * the typeface used for the labels
     */
    protected var mTypeface: FontFamily = FontFamily.NONE
    /**
     * the text size of the labels
     */
    protected var mTextSize: Float64 = 14.0
    /**
     * the text color to use for the labels
     */
    protected var mTextColor: Color = Color.BLACK

    init() {
    }

    /**
     * Returns the used offset on the x-axis for drawing the axis or legend
     * labels. This offset is applied before and after the label.
     *
     * @return
     */
    public func getXOffset(): Float64 {
        return this.mXOffset
    }

    /**
     * Sets the used x-axis offset for the labels on this axis.
     *
     * @param xOffset
     */
    public func setXOffset(xOffset: Float64): Unit {
        this.mXOffset = Utils.handleDataValues(xOffset)
    }

    /**
     * Returns the used offset on the x-axis for drawing the axis labels. This
     * offset is applied before and after the label.
     *
     * @return
     */
    public func getYOffset(): Float64 {
        return this.mYOffset
    }

    /**
     * Sets the used y-axis offset for the labels on this axis. For the legend,
     * higher offset means the legend as a whole will be placed further away
     * from the top.
     *
     * @param yOffset
     */
    public func setYOffset(yOffset: Float64): Unit {
        this.mYOffset = Utils.handleDataValues(yOffset)
    }

    /**
     * returns the Typeface used for the labels, returns null if none is set
     *
     * @return
     */
    public func getTypeface(): FontFamily {
        return this.mTypeface
    }

    /**
     * sets a specific Typeface for the labels
     *
     * @param tf
     */
    public func setTypeface(tf: FontFamily): Unit {
        this.mTypeface = tf
    }

    /**
     * sets the size of the label text in density pixels min = 6f, max = 24f, default
     * 10f
     *
     * @param size the text size, in vp
     */
    public func setTextSize(size: Float64): Unit {
        var tSize: Float64 = size
        if (tSize > 48.0) {
            tSize = 48.0
        }
        if (tSize < 6.0) {
            tSize = 6.0
        }
        this.mTextSize = tSize
    }

    /**
     * returns the text size that is currently set for the labels, in pixels
     *
     * @return
     */
    public func getTextSize(): Float64 {
        return this.mTextSize
    }

    /**
     * Sets the text color to use for the labels. Make sure to use
     * getResources().getColor(...) when using a color from the resources.
     *
     * @param color
     */
    public func setTextColor(color: Color): Unit {
        this.mTextColor = color
    }

    /**
     * Returns the text color that is set for the labels.
     *
     * @return
     */
    public func getTextColor(): Color {
        return this.mTextColor
    }

    /**
     * Set this to true if this component should be enabled (should be drawn),
     * false if not. If disabled, nothing of this component will be drawn.
     * Default: true
     *
     * @param enabled
     */
    public func setEnabled(enabled: Bool): Unit {
        this.mEnabled = enabled
    }

    /**
     * Returns true if this component is enabled (should be drawn), false if not.
     *
     * @return
     */
    public func isEnabled(): Bool {
        return this.mEnabled
    }
}
