/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public abstract class AxisBase <: ComponentBase {
    protected var mAxisValueFormatter: ?IAxisValueFormatter = Option<IAxisValueFormatter>.None
    private var mGridColor: Color = Color.GRAY
    private var mGridLineWidth: Float64 = 1.0
    private var mAxisLineColor: Color = Color.GRAY
    private var mAxisLineWidth: Float64 = 1.0
    /**
     * the actual array of entries
     */
    public var mEntries: ArrayList<Float64> = ArrayList<Float64>()
    /**
     * axis label entries only used for centered labels
     */
    public var mCenteredEntries: ArrayList<Float64> = ArrayList<Float64>()
    /**
     * the number of entries the legend contains
     */
    public var mEntryCount: Float64 = 0.0
    /**
     * the number of decimal digits to use
     */
    public var mDecimals: Int64 = 0
    /**
     * the number of label entries the axis should have, default 6
     */
    private var mLabelCount: Int64 = 6
    /**
     * the minimum interval between axis values
     */
    protected var mGranularity: Float64 = 1.0
    /**
     * When true, axis labels are controlled by the `granularity` property.
     * When false, axis values could possibly be repeated.
     * This could happen if two adjacent axis values are rounded to same value.
     * If using granularity this could be avoided by having fewer axis values visible.
     */
    protected var mGranularityEnabled: Bool = false
    /**
     * if true, the set number of y-labels will be forced
     */
    protected var mForceLabels: Bool = false
    /**
     * flag indicating if the grid lines for this axis should be drawn
     */
    protected var mDrawGridLines: Bool = true
    /**
     * flag that indicates if the line alongside the axis is drawn or not
     */
    protected var mDrawAxisLine: Bool = true
    /**
     * flag that indicates of the labels of this axis should be drawn or not
     */
    protected var mDrawLabels: Bool = true
    protected var mCenterAxisLabels: Bool = false
    /**
     * the path effect of the axis line that makes dashed lines possible
     */
    private var mAxisLineDashPathEffect: ?DashPathEffect = Option<DashPathEffect>.None
    /**
     * the path effect of the grid lines that makes dashed lines possible
     */
    private var mGridDashPathEffect: ?DashPathEffect = Option<DashPathEffect>.None

    /**
     * array of limit lines that can be set for the axis
     */
    protected var mLimitLines: ArrayList<LimitLine>
    /**
     * array of custom grid lines that can be set for the axis
     */
    protected var mGridLines: ArrayList<LimitLine>
    /**
     * flag indicating the limit lines layer depth
     */
    protected var mDrawLimitLineBehindData: Bool = false
    /**
     * flag indicating the grid lines layer depth
     */
    protected var mDrawGridLinesBehindData: Bool = true
    /**
     * Extra spacing for `axisMinimum` to be added to automatically calculated `axisMinimum`
     */
    protected var mSpaceMin: Float64 = 0.0
    /**
     * Extra spacing for `axisMaximum` to be added to automatically calculated `axisMaximum`
     */
    protected var mSpaceMax: Float64 = 0.0
    /**
     * flag indicating that the axis-min value has been customized
     */
    protected var mCustomAxisMin: Bool = false
    /**
     * flag indicating that the axis-max value has been customized
     */
    protected var mCustomAxisMax: Bool = false
    /**
     * don't touch this directly, use setter
     */
    public var mAxisMaximum: Float64 = 0.0
    /**
     * don't touch this directly, use setter
     */
    public var mAxisMinimum: Float64 = 0.0
    /**
     * the total range of values this axis covers
     */
    public var mAxisRange: Float64 = 0.0
    private var mAxisMinLabels: Int64 = 2
    private var mAxisMaxLabels: Int64 = 25

    /**
     * The minimum number of labels on the axis
     */
    public func getAxisMinLabels(): Int64 {
        return this.mAxisMinLabels
    }

    /**
     * The minimum number of labels on the axis
     */
    public func setAxisMinLabels(labels: Int64): Unit {
        if (labels > 0) {
            this.mAxisMinLabels = labels
        }
    }

    /**
     * The maximum number of labels on the axis
     */
    public func getAxisMaxLabels(): Int64 {
        return this.mAxisMaxLabels
    }

    /**
     * The maximum number of labels on the axis
     */
    public func setAxisMaxLabels(labels: Int64): Unit {
        if (labels > 0) {
            this.mAxisMaxLabels = labels
        }
    }

    /**
     * default constructor
     */
    public init() {
        super()
        this.mTextSize = Utils.handleDataValues(10.0)
        this.mXOffset = Utils.handleDataValues(5.0)
        this.mYOffset = Utils.handleDataValues(5.0)
        this.mLimitLines = ArrayList<LimitLine>()
        this.mGridLines = ArrayList<LimitLine>()
    }

    /**
     * Set this to true to enable drawing the grid lines for this axis.
     *
     * @param enabled
     */
    public func setDrawGridLines(enabled: Bool): Unit {
        this.mDrawGridLines = enabled
    }

    /**
     * Returns true if drawing grid lines is enabled for this axis.
     *
     * @return
     */
    public func isDrawGridLinesEnabled(): Bool {
        return this.mDrawGridLines
    }

    /**
     * Set this to true if the line alongside the axis should be drawn or not.
     *
     * @param enabled
     */
    public func setDrawAxisLine(enabled: Bool): Unit {
        this.mDrawAxisLine = enabled
    }

    /**
     * Returns true if the line alongside the axis should be drawn.
     *
     * @return
     */
    public func isDrawAxisLineEnabled(): Bool {
        return this.mDrawAxisLine
    }

    /**
     * Centers the axis labels instead of drawing them at their original position.
     * This is useful especially for grouped BarChart.
     *
     * @param enabled
     */
    public func setCenterAxisLabels(enabled: Bool): Unit {
        this.mCenterAxisLabels = enabled
    }

    public func isCenterAxisLabelsEnabled(): Bool {
        return this.mCenterAxisLabels && this.mEntryCount > 0.0
    }

    /**
     * Sets the color of the grid lines for this axis (the horizontal lines
     * coming from each label).
     *
     * @param color
     */
    public func setGridColor(color: Color): Unit {
        this.mGridColor = color
    }

    /**
     * Returns the color of the grid lines for this axis (the horizontal lines
     * coming from each label).
     *
     * @return
     */
    public func getGridColor(): Color {
        return this.mGridColor
    }

    /**
     * Sets the width of the border surrounding the chart in vp.
     *
     * @param width
     */
    public func setAxisLineWidth(width: Float64): Unit {
        this.mAxisLineWidth = Utils.handleDataValues(width)
    }

    /**
     * Returns the width of the axis line (line alongside the axis).
     *
     * @return
     */
    public func getAxisLineWidth(): Float64 {
        return this.mAxisLineWidth
    }

    /**
     * Sets the width of the grid lines that are drawn away from each axis
     * label.
     *
     * @param width
     */
    public func setGridLineWidth(width: Float64): Unit {
        this.mGridLineWidth = Utils.handleDataValues(width)
    }

    /**
     * Returns the width of the grid lines that are drawn away from each axis
     * label.
     *
     * @return
     */
    public func getGridLineWidth(): Float64 {
        return this.mGridLineWidth
    }

    /**
     * Sets the color of the border surrounding the chart.
     *
     * @param color
     */
    public func setAxisLineColor(color: Color): Unit {
        this.mAxisLineColor = color
    }

    /**
     * Returns the color of the axis line (line alongside the axis).
     *
     * @return
     */
    public func getAxisLineColor(): Color {
        return this.mAxisLineColor
    }

    /**
     * Set this to true to enable drawing the labels of this axis (this will not
     * affect drawing the grid lines or axis lines).
     *
     * @param enabled
     */
    public func setDrawLabels(enabled: Bool): Unit {
        this.mDrawLabels = enabled
    }

    /**
     * Returns true if drawing the labels is enabled for this axis.
     *
     * @return
     */
    public func isDrawLabelsEnabled(): Bool {
        return this.mDrawLabels
    }

    /**
     * sets the number of label entries for the y-axis max = 25, min = 2, default: 6, be aware
     * that this number is not
     * fixed (if force == false) and can only be approximated.
     *
     * @param count the number of y-axis labels that should be displayed
     * @param force if enabled, the set label count will be forced, meaning that the exact
     *              specified count of labels will
     *              be drawn and evenly distributed alongside the axis - this might cause labels
     *              to have uneven values
     */
    public func setLabelCount(count: Int64, force: ?Bool): Unit {
        var countt = count
        if (countt > this.getAxisMaxLabels()) {
            countt = this.getAxisMaxLabels()
        }
        if (countt < this.getAxisMinLabels()) {
            countt = this.getAxisMinLabels()
        }
        this.mLabelCount = countt
        this.mForceLabels = false
        if (let Some(f) <- force) {
            this.mForceLabels = f
        }
    }

    /**
     * Returns true if focing the y-label count is enabled. Default: false
     *
     * @return
     */
    public func isForceLabelsEnabled(): Bool {
        return this.mForceLabels
    }

    /**
     * Returns the number of label entries the y-axis should have
     *
     * @return
     */
    public func getLabelCount(): Int64 {
        return this.mLabelCount
    }

    /**
     * @return true if granularity is enabled
     */
    public func isGranularityEnabled(): Bool {
        return this.mGranularityEnabled
    }

    /**
     * Enabled/disable granularity control on axis value intervals. If enabled, the axis
     * interval is not allowed to go below a certain granularity. Default: false
     *
     * @param enabled
     */
    public func setGranularityEnabled(enabled: Bool): Unit {
        this.mGranularityEnabled = enabled
    }

    /**
     * @return the minimum interval between axis values
     */
    public func getGranularity(): Float64 {
        return this.mGranularity
    }

    /**
     * Set a minimum interval for the axis when zooming in. The axis is not allowed to go below
     * that limit. This can be used to avoid label duplicating when zooming in.
     *
     * @param granularity
     */
    public func setGranularity(granularity: Float64): Unit {
        this.mGranularity = granularity
        // set this to true if it was disabled, as it makes no sense to call this method with granularity disabled
        this.mGranularityEnabled = true
    }

    /**
     * Adds a new LimitLine to this axis.
     *
     * @param l
     */
    public func addLimitLine(l: LimitLine): Unit {
        this.mLimitLines.append(l)

        if (this.mLimitLines.size > 6) {
            //      Info("MPChart",
            //        "Warning! You have more than 6 LimitLines on your axis, do you really want " +
            //        "that?")
        }
    }

    public func addGridLine(customLine: GridLineConfig) {
        var line = LimitLine(customLine.getPosition())
        line.setLineWidth(customLine.getLineWidth())
        line.setLineColor(customLine.getLineColor())
        line.enableDashedLine(
            customLine.getDashPathEffect()().getLineLength(),
            customLine.getDashPathEffect()().getSpaceLength(),
            customLine.getDashPathEffect()().getPhase()
        )
        this.mGridLines.append(line)
    }

    public func getGridLines(): ArrayList<LimitLine> {
        return this.mGridLines
    }

    /**
     * Removes the specified LimitLine from the axis.
     *
     * @param l
     */
    public func removeLimitLine(l: LimitLine): Unit {
        //    this.mLimitLines.remove(l)
    }

    /**
     * Removes all LimitLines from the axis.
     */
    public func removeAllLimitLines(): Unit {
        this.mLimitLines.clear()
    }

    /**
     * Returns the LimitLines of this axis.
     *
     * @return
     */
    public func getLimitLines(): ArrayList<LimitLine> {
        return this.mLimitLines
    }

    /**
     * If this is set to true, the LimitLines are drawn behind the actual data,
     * otherwise on top. Default: false
     *
     * @param enabled
     */
    public func setDrawLimitLinesBehindData(enabled: Bool): Unit {
        this.mDrawLimitLineBehindData = enabled
    }

    public func isDrawLimitLinesBehindDataEnabled(): Bool {
        return this.mDrawLimitLineBehindData
    }

    /**
     * If this is set to false, the grid lines are draw on top of the actual data,
     * otherwise behind. Default: true
     *
     * @param enabled
     */
    public func setDrawGridLinesBehindData(enabled: Bool): Unit {
        this.mDrawGridLinesBehindData = enabled
    }

    public func isDrawGridLinesBehindDataEnabled(): Bool {
        return this.mDrawGridLinesBehindData
    }

    /**
     * Returns the longest formatted label (in terms of characters), this axis
     * contains.
     *
     * @return
     */
    public func getLongestLabel(): String {
        var longest: String = ""
        var longestLength: Int64 = 0
        for (i in 0..this.mEntries.size) {
            let text: String = this.getFormattedLabel(i)
            let textLength: Int64 = this.getStringVisualLength(text)
            if (textLength > longestLength) {
                longest = text
                longestLength = textLength
            }
        }
        return longest
    }

    private func getStringVisualLength(str: String): Int64 {
        var length = 0
        for (i in 0..str.toRuneArray().size) {
            if (this.isFullWidthCharacter(String(str.toRuneArray()[i]))) {
                length += 2
            } else {
                length += 1
            }
        }
        return length
    }

    private func isFullWidthCharacter(char: String): Bool {
        //    const regExp = RegExp("[\u4E00-\u9FA5]|[\uFF00-\uFFEF]|[\u3000-\u303F]")
        //    return regExp.test(char)
        return true
    }

    public func getFormattedLabel(index: Int64): String {
        if (index < 0 || index >= this.mEntries.size || this.getValueFormatter().isNone()) {
            return ""
        } else {
            return this.getValueFormatter()().getFormattedValue(this.mEntries[index], this)
        }
    }

    /**
     * Sets the formatter to be used for formatting the axis labels. If no formatter is set, the
     * chart will
     * automatically determine a reasonable formatting (concerning decimals) for all the values
     * that are drawn inside
     * the chart. Use chart.getDefaultValueFormatter() to use the formatter calculated by the chart.
     *
     * @param f
     */
    public func setValueFormatter(f: ?IAxisValueFormatter): Unit {
        if(let Some(ff) <- f) {
            this.mAxisValueFormatter = ff
        } else {
            this.mAxisValueFormatter = DefaultAxisValueFormatter(this.mDecimals)
        }
    }

    /**
     * Returns the formatter used for formatting the axis labels.
     *
     * @return
     */
    public func getValueFormatter(): ?IAxisValueFormatter {
        if(this.mAxisValueFormatter.isNone()) {
            this.mAxisValueFormatter = DefaultAxisValueFormatter(this.mDecimals)
        }
        if (let Some(f: DefaultAxisValueFormatter) <- this.mAxisValueFormatter) {
            if ((f.getDecimalDigits() != this.
                mDecimals)) {
                this.mAxisValueFormatter = DefaultAxisValueFormatter(this.mDecimals)
                return this.mAxisValueFormatter
            }
            return f
        } else {
            return this.mAxisValueFormatter
        }
    }

    /**
     * Enables the grid line to be drawn in dashed mode, e.g. like this
     * "- - - - - -". THIS ONLY WORKS IF HARDWARE-ACCELERATION IS TURNED OFF.
     * Keep in mind that hardware acceleration boosts performance.
     *
     * @param lineLength  the length of the line pieces
     * @param spaceLength the length of space in between the pieces
     * @param phase       offset, in degrees (normally, use 0)
     */
    public func enableGridDashedLine(lineLength: Int64, spaceLength: Int64, phase: Int64): Unit {
        this.mGridDashPathEffect = DashPathEffect([lineLength, spaceLength], phase)
    }

    /**
     * Enables the grid line to be drawn in dashed mode, e.g. like this
     * "- - - - - -". THIS ONLY WORKS IF HARDWARE-ACCELERATION IS TURNED OFF.
     * Keep in mind that hardware acceleration boosts performance.
     *
     * @param effect the DashPathEffect
     */
    public func setGridDashedLine(effect: DashPathEffect): Unit {
        this.mGridDashPathEffect = effect
    }

    /**
     * Disables the grid line to be drawn in dashed mode.
     */
    public func disableGridDashedLine(): Unit {
        this.mGridDashPathEffect = Option<DashPathEffect>.None
    }

    /**
     * Returns true if the grid dashed-line effect is enabled, false if not.
     *
     * @return
     */
    public func isGridDashedLineEnabled(): Bool {
        if (this.mGridDashPathEffect.isNone()) {
            return false
        } else {
            return true
        }
    }

    /**
     * returns the DashPathEffect that is set for grid line
     *
     * @return
     */
    public func getGridDashPathEffect(): ?DashPathEffect {
        if (let Some(value) <- this.mGridDashPathEffect) {
        	return value
        } else {
        	return Option<DashPathEffect>.None
        }
    }

    /**
     * Enables the axis line to be drawn in dashed mode, e.g. like this
     * "- - - - - -". THIS ONLY WORKS IF HARDWARE-ACCELERATION IS TURNED OFF.
     * Keep in mind that hardware acceleration boosts performance.
     *
     * @param lineLength  the length of the line pieces
     * @param spaceLength the length of space in between the pieces
     * @param phase       offset, in degrees (normally, use 0)
     */
    public func enableAxisLineDashedLine(lineLength: Int64, spaceLength: Int64, phase: Int64): Unit {
        this.mAxisLineDashPathEffect = DashPathEffect([lineLength, spaceLength], phase)
    }

    /**
     * Enables the axis line to be drawn in dashed mode, e.g. like this
     * "- - - - - -". THIS ONLY WORKS IF HARDWARE-ACCELERATION IS TURNED OFF.
     * Keep in mind that hardware acceleration boosts performance.
     *
     * @param effect the DashPathEffect
     */
    public func setAxisLineDashedLine(effect: DashPathEffect): Unit {
        this.mAxisLineDashPathEffect = effect
    }

    /**
     * Disables the axis line to be drawn in dashed mode.
     */
    public func disableAxisLineDashedLine(): Unit {
        this.mAxisLineDashPathEffect = None
    }

    /**
     * Returns true if the axis dashed-line effect is enabled, false if not.
     *
     * @return
     */
    public func isAxisLineDashedLineEnabled(): Bool {
        if (this.mAxisLineDashPathEffect.isNone()) {
            return false
        } else {
            return true
        }
    }

    /**
     * returns the DashPathEffect that is set for axis line
     *
     * @return
     */
    public func getAxisLineDashPathEffect(): ?DashPathEffect {
        if(let Some(value) <- this.mAxisLineDashPathEffect) {
            return value
        } else {
            return Option<DashPathEffect>.None
        }
    }

    /**
     * ###### BELOW CODE RELATED TO CUSTOM AXIS VALUES ######
     */
    public func getAxisMaximum(): Float64 {
        return this.mAxisMaximum
    }

    public func getAxisMinimum(): Float64 {
        return this.mAxisMinimum
    }

    /**
     * By calling this method, any custom maximum value that has been previously set is reset,
     * and the calculation is
     * done automatically.
     */
    public func resetAxisMaximum(): Unit {
        this.mCustomAxisMax = false
    }

    /**
     * Returns true if the axis max value has been customized (and is not calculated automatically)
     *
     * @return
     */
    public func isAxisMaxCustom(): Bool {
        return this.mCustomAxisMax
    }

    /**
     * By calling this method, any custom minimum value that has been previously set is reset,
     * and the calculation is
     * done automatically.
     */
    public func resetAxisMinimum(): Unit {
        this.mCustomAxisMin = false
    }

    /**
     * Returns true if the axis min value has been customized (and is not calculated automatically)
     *
     * @return
     */
    public func isAxisMinCustom(): Bool {
        return this.mCustomAxisMin
    }

    /**
     * Set a custom minimum value for this axis. If set, this value will not be calculated
     * automatically depending on
     * the provided data. Use resetAxisMinValue() to undo this. Do not forget to call
     * setStartAtZero(false) if you use
     * this method. Otherwise, the axis-minimum value will still be forced to 0.
     *
     * @param min
     */
    public func setAxisMinimum(min: Float64): Unit {
        this.mCustomAxisMin = true
        this.mAxisMinimum = min
        this.mAxisRange = abs(this.mAxisMaximum - min)
    }

    /**
     * Use setAxisMinimum(...) instead.
     *
     * @param min
     */
    public func setAxisMinValue(min: Float64): Unit {
        this.setAxisMinimum(min)
    }

    /**
     * Set a custom maximum value for this axis. If set, this value will not be calculated
     * automatically depending on
     * the provided data. Use resetAxisMaxValue() to undo this.
     *
     * @param max
     */
    public func setAxisMaximum(max: Float64): Unit {
        this.mCustomAxisMax = true
        this.mAxisMaximum = max
        this.mAxisRange = abs(max - this.mAxisMinimum)
    }

    /**
     * Use setAxisMaximum(...) instead.
     *
     * @param max
     */
    public func setAxisMaxValue(max: Float64): Unit {
        this.setAxisMaximum(max)
    }

    /**
     * Calculates the minimum / maximum  and range values of the axis with the given
     * minimum and maximum values from the chart data.
     *
     * @param dataMin the min value according to chart data
     * @param dataMax the max value according to chart data
     */
    public open func calculate(dataMin: Float64, dataMax: Float64): Unit {
        // if custom, use value as is, else use data value
        var min: Float64
        var max: Float64
        if (this.mCustomAxisMin) {
            min = this.mAxisMinimum
        } else {
            min = dataMin - this.mSpaceMin
        }
        if (this.mCustomAxisMax) {
            max = this.mAxisMaximum
        } else {
            max = dataMax + this.mSpaceMax
        }
        // temporary range (before calculations)
        let range: Float64 = abs(max - min)

        // in case all values are equal
        if (range == 0.0) {
            max = max + 1.0
            min = min - 1.0
        }

        this.mAxisMinimum = min
        this.mAxisMaximum = max
        // actual range
        this.mAxisRange = abs(max - min)
    }

    /**
     * Gets extra spacing for `axisMinimum` to be added to automatically calculated `axisMinimum`
     */
    public func getSpaceMin(): Float64 {
        return this.mSpaceMin
    }

    /**
     * Sets extra spacing for `axisMinimum` to be added to automatically calculated `axisMinimum`
     */
    public func setSpaceMin(mSpaceMin: Float64): Unit {
        this.mSpaceMin = mSpaceMin
    }

    /**
     * Gets extra spacing for `axisMaximum` to be added to automatically calculated `axisMaximum`
     */
    public func getSpaceMax(): Float64 {
        return this.mSpaceMax
    }

    /**
     * Sets extra spacing for `axisMaximum` to be added to automatically calculated `axisMaximum`
     */
    public func setSpaceMax(mSpaceMax: Float64): Unit {
        this.mSpaceMax = mSpaceMax
    }
}
