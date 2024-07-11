/**
 * Created on 2024/5/28
 */
package core.bar

public class BarDataSet <: BarLineScatterCandleBubbleDataSet<BarEntry> & IBarDataSet {
    /**
     * the maximum number of bars that are stacked upon each other, this value
     * is calculated from the Entries that are added to the DataSet
     */
    private var mStackSize: Int64 = 1
    /**
     * the color used for drawing the bar shadows
     */
    private var mBarShadowColor: UInt32 = 0xd7d7d7
    private var mBarBorderWidth: Float64 = 0.0
    private var mBarBorderColor: UInt32 = 0x000000
    /**
     * the alpha value used to draw the highlight indicator bar
     */
    private var mHighLightAlpha: Float64 = 120.0
    /**
     * the overall entry count, including counting each stack-value individually
     */
    private var mEntryCountStacks: Int64 = 0
    /**
     * array of labels used to describe the different values of the stacked bars
     */
    private var mStackLabels: Array<String> = Array<String>()
    protected var mFills: ?ArrayList<Fill> = None

    public init(yVals: ArrayList<BarEntry>, label: String) {
        super(yVals, label)
        this.calcMinMax()
        this.mHighLightColor = 0x000000
        this.calcStackSize(yVals)
        this.calcEntryCountIncludingStacks(yVals)
    }

    private func calcStackSize(yVals: ArrayList<BarEntry>): Unit {
        for (i in 0..yVals.size) {
            let vals: Array<Float64> = yVals[i].getYVals();

            if (vals.size > this.mStackSize) {
                this.mStackSize = vals.size
            }
        }
    }

    public func copy(): DataSet<BarEntry> {
        let entries = ArrayList<BarEntry>()

        if (let Some(m) <- this.mEntries) {
            for (i in 0..m.size) {
                entries.append(m[i].copy())
            }
        }
        let copied = BarDataSet(entries, this.getLabel())
        this.copyTo(copied)
        return copied
    }

    protected func copyTo(barDataSet: BarDataSet): Unit {
        super.copyTo(barDataSet)
        barDataSet.mStackSize = this.mStackSize
        barDataSet.mBarShadowColor = this.mBarShadowColor
        barDataSet.mBarBorderWidth = this.mBarBorderWidth
        barDataSet.mStackLabels = this.mStackLabels
        barDataSet.mHighLightAlpha = this.mHighLightAlpha
    }

    public func getFills(): ?ArrayList<Fill> {
        if (let Some(val) <- this.mFills) {
            return val
        } else {
            return None
        }
    }

    public func getFill(index: Int64): Fill {
        if (let Some(f) <- this.mFills) {
            return f[Int64(index % f.size)]
        }
        return Fill()
    }

    /**
     * Sets the start and end color for gradient color, ONLY color that should be used for this DataSet.
     *
     * @param startColor
     * @param endColor
     */
    public func setGradientColor(startColor: UInt32, endColor: UInt32): Unit {
        if (let Some(f) <- this.mFills) {
            f.clear()
            f.insert(f.size - 1, Fill(startColor, endColor))
        }
    }

    /**
     * This method is deprecated.
     * Use setFills(...) instead.
     *
     * @param gradientColors
     */
    public func setGradientColors(gradientColors: ArrayList<Fill>): Unit {
        this.mFills = gradientColors
    }

    /**
     * Sets the fills for the bars in this dataset.
     *
     * @param fills
     */
    public func setFills(fills: ArrayList<Fill>): Unit {
        this.mFills = fills
    }

    /**
     * Calculates the total number of entries this DataSet represents, including
     * stacks. All values belonging to a stack are calculated separately.
     */
    private func calcEntryCountIncludingStacks(yVals: ArrayList<BarEntry>): Unit {
        this.mEntryCountStacks = 0

        for (i in 0..yVals.size) {
            let vals: Array<Float64> = yVals[i].getYVals()

            if (vals.size > 0) {
                this.mEntryCountStacks += vals.size
            } else {
                this.mEntryCountStacks++
            }
        }
    }

    public func myBarCalcMinMax(e: ?BarEntry): Unit {
        if (let Some(ee) <- e) {
            if (!ee.getY().isNaN()) {
                if (ee.getYVals().size > 0) {
                    if (ee.getY() < this.mYMin) {
                        this.mYMin = ee.getY()
                    }

                    if (ee.getY() > this.mYMax) {
                        this.mYMax = ee.getY()
                    }
                } else {
                    if (-ee.getNegativeSum() < this.mYMin) {
                        this.mYMin = -ee.getNegativeSum()
                    }

                    if (ee.getPositiveSum() > this.mYMax) {
                        this.mYMax = ee.getPositiveSum()
                    }
                }
                this.calcMinMaxX(ee)
            }
        }
    }

    public func getStackSize(): Int64 {
        return this.mStackSize
    }

    public func isStacked(): Bool {
        return if (this.mStackSize > 1) {
            true
        } else {
            false
        }
    }

    /**
     * returns the overall entry count, including counting each stack-value
     * individually
     *
     * @return
     */
    public func getEntryCountStacks(): Int64 {
        return this.mEntryCountStacks
    }

    /**
     * Sets the color used for drawing the bar-shadows. The bar shadows is a
     * surface behind the bar that indicates the maximum value. Don't for get to
     * use getResources().getColor(...) to set this. Or Color.rgb(...).
     *
     * @param color
     */
    public func setBarShadowColor(color: UInt32): Unit {
        this.mBarShadowColor = color
    }

    public func getBarShadowColor(): UInt32 {
        return this.mBarShadowColor
    }

    /**
     * Sets the width used for drawing borders around the bars.
     * If borderWidth == 0, no border will be drawn.
     *
     * @return
     */
    public func setBarBorderWidth(width: Float64): Unit {
        this.mBarBorderWidth = width
    }

    /**
     * Returns the width used for drawing borders around the bars.
     * If borderWidth == 0, no border will be drawn.
     *
     * @return
     */
    public func getBarBorderWidth(): Float64 {
        return this.mBarBorderWidth
    }

    /**
     * Sets the color drawing borders around the bars.
     *
     * @return
     */
    public func setBarBorderColor(color: UInt32): Unit {
        this.mBarBorderColor = color
    }

    /**
     * Returns the color drawing borders around the bars.
     *
     * @return
     */
    public func getBarBorderColor(): UInt32 {
        return this.mBarBorderColor
    }

    /**
     * Set the alpha value (transparency) that is used for drawing the highlight
     * indicator bar. min = 0 (fully transparent), max = 255 (fully opaque)
     *
     * @param alpha
     */
    public func setHighLightAlpha(alpha: Float64): Unit {
        this.mHighLightAlpha = alpha
    }

    public func getHighLightAlpha(): Float64 {
        return this.mHighLightAlpha
    }

    /**
     * Sets labels for different values of bar-stacks, in case there are one.
     *
     * @param labels
     */
    public func setStackLabels(labels: Array<String>): Unit {
        this.mStackLabels = labels
    }

    public func getStackLabels(): Array<String> {
        return this.mStackLabels
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
