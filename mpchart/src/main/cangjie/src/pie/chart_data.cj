/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public open class ChartData<S, E> where S <: IDataSet<E>, E <: EntryOhos {
    /**
     * maximum y-value in the value array across all axes
     */
    protected var mYMax: Float64 = -Float64.Max
    /**
     * the minimum y-value in the value array across all axes
     */
    protected var mYMin: Float64 = Float64.Max
    /**
     * maximum x-value in the value array
     */
    protected var mXMax: Float64 = -Float64.Max
    /**
     * minimum x-value in the value array
     */
    protected var mXMin: Float64 = Float64.Max
    protected var mLeftAxisMax: Float64 = -Float64.Max
    protected var mLeftAxisMin: Float64 = Float64.Max
    protected var mRightAxisMax: Float64 = -Float64.Max
    protected var mRightAxisMin: Float64 = Float64.Max

    /**
     * array that holds all DataSets the ChartData object represents
     */
    protected var mDataSets: ArrayList<S> = ArrayList<S>()

    /**
     * 是否仅通过X轴距离来判断是否高亮点
     */
    private var mHighlightByXDistance: Bool = false

    /**
     * Default constructor.
     */
    public init() {
        this.mDataSets = ArrayList<S>()
    }

    public init(dataSets: ArrayList<S>) {
        this.mDataSets = dataSets
        //都是用到这个构造函数的子类必须手动调用这个函数
        //this.notifyDataChanged()
    }

    public init(dataSets: Array<S>) {
        this.mDataSets = arrayToList(dataSets)
        //  this.notifyDataChanged()
    }

    /**
     * Created because Arrays.asList(...) does not support modification.
     *
     * @param array
     * @return
     */
    private static func arrayToList(array: Array<S>): ArrayList<S> {
        let list = ArrayList<S>()

        for (data in array) {
            list.append(data)
        }

        return list
    }

    /**
     * Call this method to let the ChartData know that the underlying data has
     * changed. Calling this performs all necessary recalculations needed when
     * the contained data has changed.
     */
    public func notifyDataChanged(): Unit {
        this.calcMinMax()
    }

    /**
     * Calc minimum and maximum y-values over all DataSets.
     * Tell DataSets to recalculate their min and max y-values, this is only needed for autoScaleMinMax.
     *
     * @param fromX the x-value to start the calculation from
     * @param toX   the x-value to which the calculation should be performed
     */
    public func calcMinMaxY(fromX: Float64, toX: Float64): Unit {
        for (data in mDataSets) {
            data.calcMinMaxY(fromX, toX)
        }
        // apply the new data
        this.calcMinMax()
    }

    /**
     * Calc minimum and maximum values (both x and y) over all DataSets.
     */
    public open func calcMinMax(): Unit {
        this.mYMax = -Float64.Max
        this.mYMin = Float64.Max
        this.mXMax = -Float64.Max
        this.mXMin = Float64.Max

        for (dataSet in this.mDataSets) {
            this.calcMinMax(dataSet)
        }

        this.mLeftAxisMax = -Float64.Max
        this.mLeftAxisMin = Float64.Max
        this.mRightAxisMax = -Float64.Max
        this.mRightAxisMin = Float64.Max

        // left axis
        let firstLeft: ?S = this.getFirstLeft(this.mDataSets)

        if (let Some(f) <- firstLeft) {
            this.mLeftAxisMax = f.getYMax()
            this.mLeftAxisMin = f.getYMin()

            for (dataSet in this.mDataSets) {
                if (dataSet.getAxisDependency() == AxisDependency.LEFT) {
                    if (dataSet.getYMin() < this.mLeftAxisMin) {
                        this.mLeftAxisMin = dataSet.getYMin()
                    }

                    if (dataSet.getYMax() > this.mLeftAxisMax) {
                        this.mLeftAxisMax = dataSet.getYMax()
                    }
                }
            }
        }

        // right axis
        let firstRight: ?S = this.getFirstRight(this.mDataSets)

        if (let Some(f) <- firstRight) {
            this.mRightAxisMax = f.getYMax()
            this.mRightAxisMin = f.getYMin()

            for (dataSet in this.mDataSets) {
                if (dataSet.getAxisDependency() == AxisDependency.RIGHT) {
                    if (dataSet.getYMin() < this.mRightAxisMin) {
                        this.mRightAxisMin = dataSet.getYMin()
                    }

                    if (dataSet.getYMax() > this.mRightAxisMax) {
                        this.mRightAxisMax = dataSet.getYMax()
                    }
                }
            }
        }
    }

    /** ONLY GETTERS AND SETTERS BELOW THIS */

    /**
     * returns the number of LineDataSets this object contains
     *
     * @return
     */
    public func getDataSetCount(): Int64 {
        return this.mDataSets.size
    }

    /**
     * Returns the minimum y-value for the specified axis.
     *
     * @param axis
     * @return
     */
    public func getYMin(): Float64 {
        return mYMin
    }

    public func getYMin(axis: AxisDependency): Float64 {
        if (axis == AxisDependency.LEFT) {
            if (this.mLeftAxisMin == Float64.Max) {
                return this.mRightAxisMin
            } else {
                return this.mLeftAxisMin
            }
        } else {
            if (this.mRightAxisMin == Float64.Max) {
                return this.mLeftAxisMin
            } else {
                return this.mRightAxisMin
            }
        }
    }

    /**
     * Returns the maximum y-value for the specified axis.
     *
     * @param axis
     * @return
     */
    public func getYMax(): Float64 {
        return mYMax
    }

    public func getYMax(axis: AxisDependency): Float64 {
        if (axis == AxisDependency.LEFT) {
            if (this.mLeftAxisMax == -Float64.Max) {
                return this.mRightAxisMax
            } else {
                return this.mLeftAxisMax
            }
        } else {
            if (this.mRightAxisMax == -Float64.Max) {
                return this.mLeftAxisMax
            } else {
                return this.mRightAxisMax
            }
        }
    }

    /**
     * Returns the minimum x-value this data object contains.
     *
     * @return
     */
    public func getXMin(): Float64 {
        return this.mXMin
    }

    /**
     * Returns the maximum x-value this data object contains.
     *
     * @return
     */
    public func getXMax(): Float64 {
        return this.mXMax
    }

    /**
     * Returns all DataSet objects this ChartData object holds.
     *
     * @return
     */
    public open func getDataSets(): ArrayList<S> {
        return this.mDataSets
    }

    /**
     * Retrieve the index of a DataSet with a specific label from the ChartData.
     * Search can be case sensitive or not. IMPORTANT: This method does
     * calculations at runtime, do not over-use in performance critical
     * situations.
     *
     * @param dataSets   the DataSet array to search
     * @param label
     * @param ignorecase if true, the search is not case-sensitive
     * @return
     */
    protected func getDataSetIndexByLabel(dataSets: ArrayList<S>, label: String, ignorecase: Bool): Int64 {
        if (ignorecase) {
            for (i in 0..dataSets.size) {
                if (label.toAsciiLower() == dataSets[i].getLabel().toAsciiLower()) {
                    return i
                }
            }
        } else {
            for (i in 0..dataSets.size) {
                if (label == dataSets[i].getLabel()) {
                    return i
                }
            }
        }
        return -1
    }

    /**
     * Returns the labels of all DataSets as a string array.
     *
     * @return
     */
    public func getDataSetLabels(): Array<String> {
        var types: Array<String> = Array<String>(mDataSets.size, item: "")

        for (i in 0..this.mDataSets.size) {
            types[i] = this.mDataSets[i].getLabel()
        }

        return types
    }

    /**
     * Get the Entry for a corresponding highlight object
     *
     * @param highlight
     * @return the entry that is highlighted
     */
    public open func getEntryForHighlight(highlight: Highlight): EntryOhos {
        if (highlight.getDataSetIndex() >= this.mDataSets.size) {
            return unsafe { zeroValue<E>() }
        } else {
            // return this.mDataSets[highlight.getDataSetIndex()].getEntryForXValue(highlight.getX(), highlight.getY(), rounding: Rounding.CLOSEST)
            return unsafe { zeroValue<E>() }
        }
    }

    /**
     * Returns the DataSet object with the given label. Search can be case
     * sensitive or not. IMPORTANT: This method does calculations at runtime.
     * Use with care in performance critical situations.
     *
     * @param label
     * @param ignorecase
     * @return
     */
    public open func getDataSetByLabel(label: String, ignorecase: Bool): ?S {
        let index: Int64 = this.getDataSetIndexByLabel(this.mDataSets, label, ignorecase)

        if (index < 0 || index >= this.mDataSets.size) {
            return Option<S>.None
        } else {
            return this.mDataSets.get(index)
        }
    }

    public open func getDataSetByIndex(index: Int64): ?S {
        if (index < 0 || index >= this.mDataSets.size) {
            return Option<S>.None
        }
        return this.mDataSets[index]
    }

    /**
     * Adds a DataSet dynamically.
     *
     * @param d
     */
    public func addDataSet(d: S): Unit {
        this.calcMinMax(d)
        this.mDataSets.append(d)
    }

    /**
     * Removes the given DataSet from this data object. Also recalculates all
     * minimum and maximum values. Returns true if a DataSet was removed, false
     * if no DataSet could be removed.
     *
     * @param d
     */
    public func removeDataSet(d: S): Bool {
        let index: Int64 = findIndex(d)
        if (index == -1) {
            return false
        }
        this.mDataSets.remove(index)
        this.notifyDataChanged()
        return true
    }

    private func findIndex(d: S): Int64 {
        for (i in 0..this.mDataSets.size) {
            if (this.mDataSets[i] == d) {
                return i
            }
        }
        return -1
    }
    /**
     * Removes the DataSet at the given index in the DataSet array from the data
     * object. Also recalculates all minimum and maximum values. Returns true if
     * a DataSet was removed, false if no DataSet could be removed.
     *
     * @param index
     */
    public func removeDataSetByIndex(index: Int64): Bool {
        if (index >= this.mDataSets.size || index < 0) {
            return false
        }

        this.mDataSets.remove(index)
        this.notifyDataChanged()
        return true
    }

    /**
     * Adds an Entry to the DataSet at the specified index.
     * Entries are added to the end of the list.
     *
     * @param e
     * @param dataSetIndex
     */
    public func addEntry(e: E, dataSetIndex: Int64): Unit {
        if (this.mDataSets.size > dataSetIndex && dataSetIndex >= 0) {
            let data: S = this.mDataSets[dataSetIndex]
            // add the entry to the dataset
            if (!data.addEntry(e)) {
                return
            }
            this.calcMinMax(e, data.getAxisDependency())
        } else {
            AppLog.info("Cannot add Entry because dataSetIndex too high or too low.")
        }
    }

    /**
     * Adjusts the current minimum and maximum values based on the provided Entry object.
     *
     * @param e
     * @param axis
     */
    protected func calcMinMax(e: EntryOhos, axis: AxisDependency): Unit {
        if (this.mYMax < e.getY()) {
            this.mYMax = e.getY()
        }

        if (this.mYMin > e.getY()) {
            this.mYMin = e.getY()
        }

        if (this.mXMax < e.getX()) {
            this.mXMax = e.getX()
        }

        if (this.mXMin > e.getX()) {
            this.mXMin = e.getX()
        }

        if (axis == AxisDependency.LEFT) {
            if (this.mLeftAxisMax < e.getY()) {
                this.mLeftAxisMax = e.getY()
            }

            if (this.mLeftAxisMin > e.getY()) {
                this.mLeftAxisMin = e.getY()
            }
        } else {
            if (this.mRightAxisMax < e.getY()) {
                this.mRightAxisMax = e.getY()
            }

            if (this.mRightAxisMin > e.getY()) {
                this.mRightAxisMin = e.getY()
            }
        }
    }

    /**
     * Adjusts the minimum and maximum values based on the given DataSet.
     *
     * @param d
     */
    protected func calcMinMax(d: S): Unit {
        if (this.mYMax < d.getYMax()) {
            this.mYMax = d.getYMax()
        }

        if (this.mYMin > d.getYMin()) {
            this.mYMin = d.getYMin()
        }
        if (this.mXMax < d.getXMax()) {
            this.mXMax = d.getXMax()
        }
        if (this.mXMin > d.getXMin()) {
            this.mXMin = d.getXMin()
        }
        if (d.getAxisDependency() == AxisDependency.LEFT) {
            if (this.mLeftAxisMax < d.getYMax()) {
                this.mLeftAxisMax = d.getYMax()
            }
            if (this.mLeftAxisMin > d.getYMin()) {
                this.mLeftAxisMin = d.getYMin()
            }
        } else {
            if (this.mRightAxisMax < d.getYMax()) {
                this.mRightAxisMax = d.getYMax()
            }
            if (this.mRightAxisMin > d.getYMin()) {
                this.mRightAxisMin = d.getYMin()
            }
        }
    }

    /**
     * Removes the given Entry object from the DataSet at the specified index.
     *
     * @param e
     * @param dataSetIndex
     */
    public func removeEntry(e: E, dataSetIndex: Int64): Bool {

        // entry null, outofbounds
        if (dataSetIndex >= this.mDataSets.size) {
            return false
        }
        let data: IDataSet<E> = this.mDataSets[dataSetIndex]

        // remove the entry from the dataset
        let removed: Bool = data.removeEntry(e)
        if (removed) {
            this.notifyDataChanged()
        }
        return removed
    }

    /**
     * Removes the Entry object closest to the given DataSet at the
     * specified index. Returns true if an Entry was removed, false if no Entry
     * was found that meets the specified requirements.
     *
     * @param xValue
     * @param dataSetIndex
     * @return
     */
    public func removeEntryByXValue(xValue: Float64, dataSetIndex: Int64): Bool {
        if (dataSetIndex >= this.mDataSets.size) {
            return false
        }

        let dataSet: IDataSet<E> = this.mDataSets[dataSetIndex]
        let e: ?E = dataSet.getEntryForXValue(xValue, Float64.NaN, rounding: Rounding.CLOSEST)

        if (e.isNone()) {
            return false
        }

        return this.removeEntry(e(), dataSetIndex)
    }

    /**
     * Returns the DataSet that contains the provided Entry, or null, if no
     * DataSet contains this Entry.
     *
     * @param e
     * @return
     */
    public func getDataSetForEntry(e: EntryOhos): ?S {
        for (i in 0..this.mDataSets.size) {
            let dataSet: S = this.mDataSets[i]

            for (j in 0..dataSet.getEntryCount()) {
                if (refEq(e, dataSet.getEntryForXValue(e.getX(), e.getY(), rounding: Rounding.CLOSEST)())) {
                    return dataSet
                }
            }
        }

        return Option<S>.None
    }

    /**
     * Returns all colors used across all DataSet objects this object
     * represents.
     *
     * @return
     */
    public func getColors(): Array<UInt32> {
        var clrcnt: Int64 = 0

        for (i in 0..this.mDataSets.size) {
            clrcnt += this.mDataSets[i].getColors().size
        }

        let colors: Array<UInt32> = Array<UInt32>(clrcnt, item: 0)
        var cnt: Int64 = 0

        for (i in 0..this.mDataSets.size) {
            var clrs: Array<UInt32> = this.mDataSets[i].getColors().toArray()

            for (j in 0..clrs.size) {
                colors[cnt] = clrs[j]
                cnt++
            }
        }

        return colors
    }

    /**
     * Returns the index of the provided DataSet in the DataSet array of this data object, or -1 if it does not exist.
     *
     * @param dataSet
     * @return
     */
    public func getIndexOfDataSet(dataSet: S): Int64 {
        return findIndex(dataSet)
    }

    /**
     * Returns the first DataSet from the datasets-array that has it's dependency on the left axis.
     * Returns null if no DataSet with left dependency could be found.
     *
     * @return
     */
    protected func getFirstLeft(sets: ArrayList<S>): ?S {
        for (data in sets) {
            if (data.getAxisDependency() == AxisDependency.LEFT) {
                return data
            }
        }
        return Option<S>.None
    }

    /**
     * Returns the first DataSet from the datasets-array that has it's dependency on the right axis.
     * Returns null if no DataSet with right dependency could be found.
     *
     * @return
     */
    public func getFirstRight(sets: ArrayList<S>): ?S {
        for (dataSet in sets) {
            if (dataSet.getAxisDependency() == AxisDependency.RIGHT) {
                return dataSet
            }
        }
        return Option<S>.None
    }

    /**
     * Sets a custom IValueFormatter for all DataSets this data object contains.
     *
     * @param f
     */
    public func setValueFormatter(f: ?IValueFormatter): Unit {
        if (f.isNone()) {
            return
        } else {
            for (data in this.mDataSets) {
                data.setValueFormatter(f())
            }
        }
    }

    /**
     * Sets the color of the value-text (color in which the value-labels are
     * drawn) for all DataSets this data object contains.
     *
     * @param color
     */
    public func setValueTextColor(color: UInt32): Unit {
        for (data in this.mDataSets) {
            data.setValueTextColor(color)
        }
    }

    /**
     * Sets the same list of value-colors for all DataSets this
     * data object contains.
     *
     * @param colors
     */
    public func setValueTextColors(colors: ArrayList<UInt32>): Unit {
        for (data in this.mDataSets) {
            data.setValueTextColors(colors)
        }
    }

    /**
     * Sets the Typeface for all value-labels for all DataSets this data object
     * contains.
     *
     * @param tf
     */
    public func setValueTypeface(tf: FontFamily): Unit {
        for (data in this.mDataSets) {
            data.setValueTypeface(tf)
        }
    }

    /**
     * Sets the size (in vp) of the value-text for all DataSets this data object
     * contains.
     *
     * @param size
     */
    public func setValueTextSize(size: Float64): Unit {
        for (data in this.mDataSets) {
            data.setValueTextSize(size)
        }
    }

    /**
     * Enables / disables drawing values (value-text) for all DataSets this data
     * object contains.
     *
     * @param enabled
     */
    public func setDrawValues(enabled: Bool): Unit {
        for (data in this.mDataSets) {
            data.setDrawValues(enabled);
        }
    }

    /**
     * Enables / disables highlighting values for all DataSets this data object
     * contains. If set to true, this means that values can
     * be highlighted programmatically or by touch gesture.
     */
    public func setHighlightEnabled(enabled: Bool): Unit {
        for (data in this.mDataSets) {
            data.setHighlightEnabled(enabled);
        }
    }

    /**
     * Returns true if highlighting of all underlying values is enabled, false
     * if not.
     *
     * @return
     */
    public func isHighlightEnabled(): Bool {
        for (data in this.mDataSets) {
            if (!data.isHighlightEnabled()) {
                return false
            }
        }

        return true
    }

    /**
     * Clears this data object from all DataSets and removes all Entries. Don't
     * forget to invalidate the chart after this.
     */
    public func clearValues(): Unit {
        this.mDataSets.clear()

        this.notifyDataChanged()
    }

    /**
     * Checks if this data object contains the specified DataSet. Returns true
     * if so, false if not.
     *
     * @param dataSet
     * @return
     */
    public func contains(dataSet: S): Bool {
        for (data in this.mDataSets) {
            if (data == dataSet) {
                return true
            }
        }
        return false
    }

    /**
     * Returns the total entry count across all DataSet objects this data object contains.
     *
     * @return
     */
    public func getEntryCount(): Int64 {
        var count: Int64 = 0
        for (data in this.mDataSets) {
            count += data.getEntryCount()
        }

        return count
    }

    /**
     * Returns the DataSet object with the maximum number of entries or null if there are no DataSets.
     *
     * @return
     */
    public func getMaxEntryCountSet(): ?S {
        if (this.mDataSets.size == 0) {
            return Option<S>.None
        }

        var max: S = this.mDataSets[0]

        for (data in this.mDataSets) {
            if (data.getEntryCount() > max.getEntryCount()) {
                max = data
            }
        }
        return max
    }

    /**
     * 设置是否仅通过X轴距离来判断是否高亮点
     * @param value 是否仅通过X轴距离来判断是否高亮点
     */
    public func setHighlightByXDistance(highlightByXDistance: Bool) {
        this.mHighlightByXDistance = highlightByXDistance
    }

    /**
     * 检查是否仅通过X轴距离来判断是否高亮点
     * @returns 是否仅通过X轴距离来判断是否高亮点的布尔值
     */
    public func isHighlightByXDistance(): Bool {
        return this.mHighlightByXDistance
    }
}
