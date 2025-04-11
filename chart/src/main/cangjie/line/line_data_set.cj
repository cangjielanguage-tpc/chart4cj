/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

public class LineDataSet <: LineRadarDataSet<EntryOhos> & ILineDataSet {
    /**
     * Drawing mode for this line dataset
     **/
    private var mMode: Mode = Mode.LINEAR
    /**
     * List representing all colors that are used for the circles
     */
    private var mCircleColors: ArrayList<UInt32> = ArrayList<UInt32>()

    /**
     * the color of the inner circles
     */
    private var mCircleHoleColor: UInt32 = 0xffffff
    /**
     * the radius of the circle-shaped value indicators
     */
    private var mCircleRadius: Float64 = 8.0
    /**
     * the hole radius of the circle-shaped value indicators
     */
    private var mCircleHoleRadius: Float64 = 4.0
    /**
     * sets the intensity of the cubic lines
     */
    private var mCubicIntensity: Float64 = 0.2
    /**
     * the path effect of this DataSet that makes dashed lines possible
     */
    private var mDashPathEffect: ?DashPathEffect = None
    /**
     * formatter for customizing the position of the fill-line
     */
    private var mFillFormatter: IFillFormatter = DefaultFillFormatter()
    /**
     * if true, drawing circles is enabled
     */
    private var mDrawCircles: Bool = true
    private var mDrawCircleHole: Bool = true

    public init(yVals: ArrayList<EntryOhos>, label: String) {
        super(yVals, label)
        this.calcMinMax()
        this.mCircleColors.clear()
        this.mCircleColors.append(UInt32(ChartColor.rgb(140, 234, 255)))
        this.mColors.clear()
        this.mColors.append(0x868686)
    }

    public func getCircleColor(index: Int64): UInt32 {
        return this.mCircleColors[index]
    }

    public func copy(): DataSet<EntryOhos> {
        let entries = ArrayList<EntryOhos>()
        if (let Some(e) <- this.mEntries) {
            for (i in 0..e.size) {
                entries.append(e[i].copy())
            }
        }
        let copied = LineDataSet(entries, this.getLabel())
        this.copyTo(copied)
        return copied
    }

    protected func copyTo(lineDataSet: LineDataSet): Unit {
        super.copyTo(lineDataSet)
        lineDataSet.mCircleColors = this.mCircleColors
        lineDataSet.mCircleHoleColor = this.mCircleHoleColor
        lineDataSet.mCircleHoleRadius = this.mCircleHoleRadius
        lineDataSet.mCircleRadius = this.mCircleRadius
        lineDataSet.mCubicIntensity = this.mCubicIntensity
        lineDataSet.mDashPathEffect = this.mDashPathEffect
        lineDataSet.mDrawCircleHole = this.mDrawCircleHole
        lineDataSet.mDrawCircles = this.mDrawCircleHole
        lineDataSet.mFillFormatter = this.mFillFormatter
        lineDataSet.mMode = this.mMode
    }

    /**
     * Returns the drawing mode for this line dataset
     *
     * @return
     */
    public func getMode(): Mode {
        return this.mMode
    }

    /**
     * Returns the drawing mode for this LineDataSet
     *
     * @return
     */
    public func setMode(mode: Mode): Unit {
        this.mMode = mode
    }

    /**
     * Sets the intensity for cubic lines (if enabled). Max = 1f = very cubic,
     * Min = 0.05f = low cubic effect, Default: 0.2f
     *
     * @param intensity
     */
    public func setCubicIntensity(intensity: Float64): Unit {
        if (intensity > 1.0) {
            this.mCubicIntensity = 1.0
        }

        if (intensity < 0.05) {
            this.mCubicIntensity = 0.05
        }
    }

    public func getCubicIntensity(): Float64 {
        return this.mCubicIntensity
    }

    /**
     * Sets the radius of the drawn circles.
     * Default radius = 4f, Min = 1f
     *
     * @param radius
     */
    public func setCircleRadius(radius: Float64): Unit {
        if (radius >= 1.0) {
            this.mCircleRadius = radius
        } else {
            Hilog.info(0x000000,"chart","LineDataSet: Circle radius cannot be < 1")
        }
    }

    public func getCircleRadius(): Float64 {
        return this.mCircleRadius
    }

    /**
     * Sets the hole radius of the drawn circles.
     * Default radius = 2f, Min = 0.5f
     *
     * @param holeRadius
     */
    public func setCircleHoleRadius(holeRadius: Float64): Unit {
        if (holeRadius >= 0.5) {
            this.mCircleHoleRadius = holeRadius
        } else {
            Hilog.info(0x000000,"chart","LineDataSet: Circle radius cannot be < 0.5")
        }
    }

    public func getCircleHoleRadius(): Float64 {
        return this.mCircleHoleRadius
    }

    public func enableDashedLine(lineLength: Float64, spaceLength: Float64): Unit {
        this.mDashPathEffect = DashPathEffect([lineLength, spaceLength])
    }

    /**
     * Disables the line to be drawn in dashed mode.
     */
    public func disableDashedLine(): Unit {
        this.mDashPathEffect = None
    }

    public func isDashedLineEnabled(): Bool {
        return if (this.mDashPathEffect.isNone()) {
            false
        } else {
            true
        }
    }

    public func getDashPathEffect(): ?DashPathEffect {
        return this.mDashPathEffect
    }

    /**
     * set this to true to enable the drawing of circle indicators for this
     * DataSet, default true
     *
     * @param enabled
     */
    public func setDrawCircles(enabled: Bool): Unit {
        this.mDrawCircles = enabled
    }

    public func isDrawCirclesEnabled(): Bool {
        return this.mDrawCircles
    }

    /** ALL CODE BELOW RELATED TO CIRCLE-COLORS */

    /**
     * returns all colors specified for the circles
     *
     * @return
     */
    public func getCircleColors(): ArrayList<UInt32> {
        return this.mCircleColors
    }

    public func getCircleColorByIndex(index: Int64): UInt32 {
        if (this.mCircleColors.size > 0) {
            return this.mCircleColors[index]
        }
        return 0
    }

    public func getCircleColorCount(): Int64 {
        if (this.mCircleColors.size > 0) {
            return this.mCircleColors.size
        }
        return 0
    }

    public func setCircleColorsByArray(colors: ArrayList<UInt32>): Unit {
        this.mCircleColors = colors
    }

    public func setCircleColors(colors: Array<UInt32>): Unit {
        this.mCircleColors = ColorTemplate.createColors(colors)
    }

    public func setCircleColorsByArrayAndCon(colors: Array<UInt32>): Unit {
        var clrs: ArrayList<UInt32> = this.mCircleColors
        if (clrs.size == 0) {
            clrs = ArrayList<UInt32>()
        }
        clrs.clear()
        for (color in colors) {
            clrs.append(color)
        }
        this.mCircleColors = clrs
    }

    /**
     * Sets the one and ONLY color that should be used for this DataSet.
     * Internally, this recreates the colors array and adds the specified color.
     *
     * @param color
     */
    public func setCircleColor(color: UInt32): Unit {
        this.resetCircleColors()

        this.mCircleColors.append(color)
    }

    /**
     * resets the circle-colors array and creates a new one
     */
    public func resetCircleColors(): Unit {
        this.mCircleColors = ArrayList<UInt32>()

        this.mCircleColors.clear()
    }

    /**
     * Sets the color of the inner circle of the line-circles.
     *
     * @param color
     */
    public func setCircleHoleColor(color: UInt32): Unit {
        this.mCircleHoleColor = color
    }

    public func getCircleHoleColor(): UInt32 {
        return this.mCircleHoleColor
    }

    /**
     * Set this to true to allow drawing a hole in each data circle.
     *
     * @param enabled
     */
    public func setDrawCircleHole(enabled: Bool): Unit {
        this.mDrawCircleHole = enabled
    }

    public func isDrawCircleHoleEnabled(): Bool {
        return this.mDrawCircleHole
    }

    /**
     * Sets a custom IFillFormatter to the chart that handles the position of the
     * filled-line for each DataSet. Set this to null to use the default logic.
     *
     * @param formatter
     */
    public func setFillFormatter(formatter: ?IFillFormatter): Unit {
        if (let Some(f) <- formatter) {
            this.mFillFormatter = f
        } else {
            this.mFillFormatter = DefaultFillFormatter()
        }
    }

    public func getFillFormatter(): IFillFormatter {
        return this.mFillFormatter
    }

    public func getDashPathEffectHighlight(): ?DashPathEffect {
        return None
    }
    public func isDrawSteppedEnabled(): Bool {
        return this.mMode == Mode.STEPPED
    }

    public operator func ==(s: Any): Bool {
        return match (s) {
            case v: LineDataSet => refEq(this, v)
            case _ => false
        }
    }

    public operator func !=(s: Any): Bool {
        return !(this == s)
    }
}




