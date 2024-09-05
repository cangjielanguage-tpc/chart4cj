/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public abstract class BaseDataSet<E> <: IDataSet<E> where E <: EntryOhos {
    /**
     * List representing all colors that are used for this DataSet
     */
    protected var mColors: ArrayList<UInt32> = ArrayList<UInt32>()
    /**
     * List representing all colors that are used for drawing the actual values for this DataSet
     */
    protected var mValueColors: ArrayList<UInt32> = ArrayList<UInt32>()
    /**
     * label that describes the DataSet or the data the DataSet represents
     */
    private var mLabel: String = "DataSet"
    /**
     * this specifies which axis this DataSet should be plotted against
     */
    protected var mAxisDependency: AxisDependency = AxisDependency.LEFT
    /**
     * if true, value highlighting is enabled
     */
    protected var mHighlightEnabled: Bool = true
    /**
     * custom formatter that is used instead of the auto-formatter if set
     */
    protected var mValueFormatter: ?IValueFormatter = None
    /**
     * the typeface used for the value text
     */
    protected var mValueTypeface: FontFamily = FontFamily.NONE
    private var mForm: LegendForm = LegendForm.DEFAULT
    private var mFormSize: Float64 = Float64.NaN
    private var mFormLineWidth: Float64 = Float64.NaN
    private var mFormLineDashEffect: ?DashPathEffect = None
    /**
     * if true, y-values are drawn on the chart
     */
    protected var mDrawValues: Bool = true
    /**
     * if true, y-icons are drawn on the chart
     */
    protected var mDrawIcons: Bool = true
    /**
     * the offset for drawing icons (in vp)
     */
    protected var mIconsOffset: MPPointF = MPPointF()
    /**
     * the size of the value-text labels
     */
    protected var mValueTextSize: Float64 = 8.0
    /**
     * flag that indicates if the DataSet is visible or not
     */
    protected var mVisible: Bool = true

    init(label!: String = "DataSet") {
        this.mColors = ArrayList<UInt32>()
        this.mValueColors = ArrayList<UInt32>()
        // default color
        this.mColors.append(0x8ceaff)
        this.mValueColors.append(0x000000)
        this.mLabel = label
    }

    /**
     * Use this method to tell the data set that the underlying data has changed.
     */
    public func notifyDataSetChanged(): Unit {
        this.calcMinMax()
    }

    /**
     * ###### ###### COLOR GETTING RELATED METHODS ##### ######
     */
    public func getColors(): ArrayList<UInt32> {
        return this.mColors
    }

    public func getValueColors(): ArrayList<UInt32> {
        return this.mValueColors
    }

    public func getColor(): UInt32 {
        return this.mColors.get(0)()
    }
    public func getColor(index: Int64): UInt32 {
        return this.mColors[index % this.mColors.size]
    }

    /**
     * ###### ###### COLOR SETTING RELATED METHODS ##### ######
     */

    /**
     * Sets the colors that should be used fore this DataSet. Colors are reused
     * as soon as the number of Entries the DataSet represents is higher than
     * the size of the colors array. If you are using colors from the resources,
     * make sure that the colors are already prepared (by calling
     * getResources().getColor(...)) before adding them to the DataSet.
     *
     * @param colors
     */
    public func setColorsByList(colors: ArrayList<UInt32>): Unit {
        if (colors.size > 0) {
            this.mColors = colors
        }

    }

    /**
     * Sets the colors that should be used fore this DataSet. Colors are reused
     * as soon as the number of Entries the DataSet represents is higher than
     * the size of the colors array. If you are using colors from the resources,
     * make sure that the colors are already prepared (by calling
     * getResources().getColor(...)) before adding them to the DataSet.
     *
     * @param colors
     */
    public func setColorsByVariable(colors: Array<UInt32>): Unit {
        this.mColors = ColorTemplate.createColors(colors)
    }

    /**
     * Sets the colors that should be used fore this DataSet. Colors are reused
     * as soon as the number of Entries the DataSet represents is higher than
     * the size of the colors array. You can use
     * "new int[] { R.color.red, R.color.green, ... }" to provide colors for
     * this method. Internally, the colors are resolved using
     * getResources().getColor(...)
     *
     * @param colors
     */
    public func setColorsByArr(colors: Array<UInt32>): Unit {
        if (colors.size > 0) {
            this.mColors.clear()
        }

        this.mColors.appendAll(colors)
    }

    /**
     * Adds a new color to the colors array of the DataSet.
     *
     * @param color
     */
    public func addColor(color: UInt32): Unit {
        this.mColors.append(color)
    }

    /**
     * Sets the one and ONLY color that should be used for this DataSet.
     * Internally, this recreates the colors array and adds the specified color.
     *
     * @param color
     */
    public func setColorByColor(color: UInt32): Unit {
        this.resetColors()
        this.mColors.append(color)
    }

    /**
     * Sets a color with a specific alpha value.
     *
     * @param color
     * @param alpha from 0-255
     */
    public func setColorByAlpha(color: UInt32, alpha: Float64): Unit {
        let mColor: UInt32 = UInt32(ColorTemplate.argb(alpha, ColorTemplate.red(Int64(color)),
                ColorTemplate.green(Int64(color)), ColorTemplate.blue(Int64(color))))
        this.setColorsByVariable([mColor])
    }

    /**
     * Sets colors with a specific alpha value.
     *
     * @param colors
     * @param alpha
     */
    public func setColorsByArrAndAlpha(colors: Array<UInt32>, alpha: Float64): Unit {
        this.resetColors()
        for (i in colors) {
            this.addColor(
                UInt32(ColorTemplate.argb(alpha, ColorTemplate.red(Int64(i)), ColorTemplate.green(Int64(i)), ColorTemplate.blue(Int64(i)))))
        }
    }

    /**
     * Resets all colors of this DataSet and recreates the colors array.
     */
    public func resetColors(): Unit {
        this.mColors.clear()
    }

    /**
     * ###### ###### OTHER STYLING RELATED METHODS ##### ######
     */
    public func setLabel(label: String): Unit {
        this.mLabel = label
    }

    public func getLabel(): String {
        return this.mLabel
    }

    public func setHighlightEnabled(enabled: Bool): Unit {
        this.mHighlightEnabled = enabled
    }

    public func isHighlightEnabled(): Bool {
        return this.mHighlightEnabled
    }

    public func setValueFormatter(f: IValueFormatter): Unit {
        this.mValueFormatter = f
    }

    public func getValueFormatter(): ?IValueFormatter {
        if (this.needsFormatter()) {
            return Utils.getDefaultValueFormatter()
        }
        return this.mValueFormatter
    }

    public func needsFormatter(): Bool {
        return this.mValueFormatter.isNone()
    }

    public func setValueTextColor(color: UInt32): Unit {
        if (this.mValueColors.size != 0) {
            this.mValueColors.clear()
            this.mValueColors.append(color)
        }
    }

    public func setValueTextColors(colors: ArrayList<UInt32>): Unit {
        if (this.mValueColors.size != 0) {
            this.mValueColors = colors
        }
    }

    public func setValueTypeface(tf: FontFamily): Unit {
        this.mValueTypeface = tf
    }

    public func setValueTextSize(size: Float64): Unit {
        this.mValueTextSize = size
    }

    public func getValueTextColor(index: ?Int64): UInt32 {
        var i: Int64 = index()
        if (index.isNone()) {
            i = 0
        }
        if (this.mValueColors.size != 0) {
            return this.mValueColors.get(i % this.mValueColors.size)()
        }
        return 0
    }

    public func getValueTypeface(): FontFamily {
        return this.mValueTypeface
    }

    public func getValueTextSize(): Float64 {
        return this.mValueTextSize
    }

    public func setForm(form: LegendForm): Unit {
        this.mForm = form
    }

    public func getForm(): LegendForm {
        return this.mForm
    }

    public func setFormSize(formSize: Float64): Unit {
        this.mFormSize = formSize
    }

    public func getFormSize(): Float64 {
        return this.mFormSize
    }

    public func setFormLineWidth(formLineWidth: Float64): Unit {
        this.mFormLineWidth = formLineWidth
    }

    public func getFormLineWidth(): Float64 {
        return this.mFormLineWidth
    }

    public func setFormLineDashEffect(dashPathEffect: ?DashPathEffect): Unit {
        this.mFormLineDashEffect = dashPathEffect
    }

    public func getFormLineDashEffect(): ?DashPathEffect {
        return this.mFormLineDashEffect
    }

    public func setDrawValues(enabled: Bool): Unit {
        this.mDrawValues = enabled
    }

    public func isDrawValuesEnabled(): Bool {
        return this.mDrawValues
    }

    public func setDrawIcons(enabled: Bool): Unit {
        this.mDrawIcons = enabled
    }

    public func isDrawIconsEnabled(): Bool {
        return this.mDrawIcons
    }

    public func setIconsOffset(offsetDp: MPPointF): Unit {
        this.mIconsOffset.x = offsetDp.x
        this.mIconsOffset.y = offsetDp.y
    }

    public func getIconsOffset(): MPPointF {
        return this.mIconsOffset
    }

    public func setVisible(visible: Bool): Unit {
        this.mVisible = visible
    }

    public func isVisible(): Bool {
        return this.mVisible
    }

    public func getAxisDependency(): AxisDependency {
        return this.mAxisDependency
    }

    public func setAxisDependency(dependency: AxisDependency): Unit {
        this.mAxisDependency = dependency
    }

    /**
     * ###### ###### DATA RELATED METHODS ###### ######
     */
    public func getIndexInEntries(xIndex: Float64): Int64 {
        for (i in 0..this.getEntryCount()) {
            let dataArray: ?E = this.getEntryForIndex(i)
            if (let Some(d) <- dataArray) {
                if (xIndex == d.getX()) {
                    return i
                } else {
                    return -1
                }
            }
        }
        return -1
    }

    public func removeFirst(): Bool {
        if (this.getEntryCount() > 0) {
            let entry: ?E = this.getEntryForIndex(0)
            if ( let Some(e) <- entry) {
                return this.removeEntry(e)
            }
            return true
        } else {
            return false
        }
    }

    public func removeLast(): Bool {
        if (this.getEntryCount() > 0) {
            let e: ?E = this.getEntryForIndex(this.getEntryCount() - 1)
            if (let Some(ee) <- e) {
                return this.removeEntry(ee)
            }
            return true
        } else {
            return false
        }
    }

    public func removeEntryByXValue(xValue: Float64): Bool {
        //        let e: ?E = this.getEntryForXValue(xValue, Float64.NaN, rounding: Rounding.CLOSEST)
        //        if (e.isSome()) {
        //            return this.removeEntry(e())
        //        }
        return true
    }

    public func removeEntryByIndex(index: Int64): Bool {
        let e: ?E = this.getEntryForIndex(index)
        if (let Some(ee) <- e) {
            return this.removeEntry(ee)
        }
        return true
    }

    public func contains(e: E): Bool {
        for (i in 0..this.getEntryCount()) {
            if (refEq(this.getEntryForIndex(i)(), e)) {
                return true
            }
        }
        return false
    }

    protected func copyTo(baseDataSet: BaseDataSet<E>): Unit {
        baseDataSet.mAxisDependency = this.mAxisDependency
        baseDataSet.mColors = this.mColors
        baseDataSet.mDrawIcons = this.mDrawIcons
        baseDataSet.mDrawValues = this.mDrawValues
        baseDataSet.mForm = this.mForm
        baseDataSet.mFormLineDashEffect = this.mFormLineDashEffect
        baseDataSet.mFormLineWidth = this.mFormLineWidth
        baseDataSet.mFormSize = this.mFormSize
        baseDataSet.mHighlightEnabled = this.mHighlightEnabled
        baseDataSet.mIconsOffset = this.mIconsOffset
        baseDataSet.mValueColors = this.mValueColors
        baseDataSet.mValueFormatter = this.mValueFormatter
        baseDataSet.mValueColors = this.mValueColors
        baseDataSet.mValueTextSize = this.mValueTextSize
        baseDataSet.mVisible = this.mVisible
    }

    public func getYMin(): Float64

    public func getYMax(): Float64

    public func getXMin(): Float64

    public func getXMax(): Float64

    public func getEntryCount(): Int64

    public func calcMinMax(): Unit

    public func calcMinMaxY(fromX: Float64, toX: Float64): Unit

    public func getEntryForXValue(xValue: Float64, closestToY: Float64, rounding!: Rounding): ?E

    public func getEntriesForXValue(xValue: Float64): ArrayList<E>

    public func getEntryForIndex(index: Int64): ?E

    public func getEntryIndex(xValue: Float64, closestToY: Float64, rounding: Rounding): Int64

    public func getEntryIndexByEntry(e: E): Int64

    public func addEntry(e: ?E): Bool

    public func addEntryOrdered(e: E): Unit

    public func removeEntry(e: E): Bool

    public func clear(): Unit
}
