/**
 * Created on 2024/4/22
 */
package core.pie

public class LimitLine <: ComponentBase {
    private var mLimit: Float64 = 0.0
    /** the width of the limit line */
    private var mLineWidth: Float64 = 2.0
    /** the color of the limit line */
    private var mLineColor: UInt32  = UInt32(ChartColor.rgb(237, 91, 91))
    /** the style of the label text */
    private var mTextStyle: Style = Style.FILL_AND_STROKE
    /** label string that is drawn next to the limit line */
    private var mLabel: String = ""
    /** the path effect of this LimitLine that makes dashed lines possible */
    private var mDashPathEffect: ?DashPathEffect = Option<DashPathEffect>.None
    /** indicates the position of the LimitLine label */
    private var mLabelPosition: LimitLabelPosition = LimitLabelPosition.RIGHT_TOP

    public init(limit: Float64) {
        mLimit = limit
    }

    public init(limit: Float64, label: String) {
        super()
        this.mLimit = limit
        this.mLabel = label
    }

    /**
     * Returns the limit that is set for this line.
     *
     * @return
     */
    public func getLimit(): Float64 {
        return this.mLimit
    }

    /**
     * set the line width of the chart (min = 0.2f, max = 12f); default 2f NOTE:
     * thinner line == better performance, thicker line == worse performance
     *
     * @param width
     */
    public func setLineWidth(width: Float64) {
        var widths = width
        if (widths < 0.2) {
            widths = 0.2
        }
        if (widths > 12.0) {
            widths = 12.0
        }
        this.mLineWidth = widths
    }

    /**
     * returns the width of limit line
     *
     * @return
     */
    public func getLineWidth(): Float64 {
        return this.mLineWidth
    }

    /**
     * Sets the linecolor for this LimitLine. Make sure to use
     * getResources().getColor(...)
     *
     * @param color
     */
    public func setLineColor(color: UInt32) {
        this.mLineColor = color
    }

    /**
     * Returns the color that is used for this LimitLine
     *
     * @return
     */
    public func getLineColor(): UInt32 {
        return this.mLineColor
    }

    /**
     * Enables the line to be drawn in dashed mode, e.g. like this "- - - - - -"
     *
     * @param lineLength the length of the line pieces
     * @param spaceLength the length of space in between the pieces
     * @param phase offset, in degrees (normally, use 0)
     */
    public func enableDashedLine(lineLength: Int64, spaceLength: Int64, phase: Int64) {
        this.mDashPathEffect = DashPathEffect([lineLength, spaceLength], phase)
    }

    /**
     * Disables the line to be drawn in dashed mode.
     */
    public func disableDashedLine() {
        this.mDashPathEffect = Option<DashPathEffect>.None
    }

    /**
     * Returns true if the dashed-line effect is enabled, false if not. Default:
     * disabled
     *
     * @return
     */
    public func isDashedLineEnabled(): Bool {
        if (mDashPathEffect.isNone()) {
            return false
        } else {
            return true
        }
    }

    /**
     * returns the DashPathEffect that is set for this LimitLine
     *
     * @return
     */
    public func getDashPathEffect(): ?DashPathEffect {
        return this.mDashPathEffect
    }

    /**
     * Sets the color of the value-text that is drawn next to the LimitLine.
     * Default: Paint.Style.FILL_AND_STROKE
     *
     * @param style
     */
    public func setTextStyle(style: Style) {
        this.mTextStyle = style
    }

    /**
     * Returns the color of the value-text that is drawn next to the LimitLine.
     *
     * @return
     */
    public func getTextStyle(): Style {
        return this.mTextStyle
    }

    /**
     * Sets the position of the LimitLine value label (either on the right or on
     * the left edge of the chart). Not supported for RadarChart.
     *
     * @param pos
     */
    public func setLabelPosition(pos: LimitLabelPosition) {
        this.mLabelPosition = pos
    }

    /**
     * Returns the position of the LimitLine label (value).
     *
     * @return
     */
    public func getLabelPosition(): LimitLabelPosition {
        return this.mLabelPosition
    }

    /**
     * Sets the label that is drawn next to the limit line. Provide "" if no
     * label is required.
     *
     * @param label
     */
    public func setLabel(label: String) {
        this.mLabel = label
    }

    /**
     * Returns the label that is drawn next to the limit line.
     *
     * @return
     */
    public func getLabel(): String {
        return this.mLabel
    }
}

/** enum that indicates the position of the LimitLine label */
public enum LimitLabelPosition <: Equatable<LimitLabelPosition> {
    | LEFT_TOP
    | LEFT_BOTTOM
    | RIGHT_TOP
    | RIGHT_BOTTOM

    public operator func ==(b: LimitLabelPosition): Bool {
        this == b
    }

    public operator func !=(b: LimitLabelPosition): Bool {
        this != b
    }
}
