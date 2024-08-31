/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public interface  IDataSet<E> where E <: EntryOhos {
     operator func ==(s: Any): Bool
      operator func !=(s: Any): Bool
    /** ###### ###### DATA RELATED METHODS ###### ###### */

    /**
     * returns the minimum y-value this DataSet holds
     *
     * @return
     */
     func getYMin(): Float64

    /**
     * returns the maximum y-value this DataSet holds
     *
     * @return
     */
     func getYMax(): Float64

    /**
     * returns the minimum x-value this DataSet holds
     *
     * @return
     */
     func getXMin(): Float64

    /**
     * returns the maximum x-value this DataSet holds
     *
     * @return
     */
     func getXMax(): Float64

    /**
     * Returns the number of y-values this DataSet represents -> the size of the y-values array
     * -> yvals.size()
     *
     * @return
     */
     func getEntryCount(): Int64

    /**
     * Calculates the minimum and maximum x and y values (mXMin, mXMax, mYMin, mYMax).
     */
     func calcMinMax(): Unit

    /**
     * Calculates the min and max y-values from the Entry closest to the given fromX to the Entry closest to the given toX value.
     * This is only needed for the autoScaleMinMax feature.
     *
     * @param fromX
     * @param toX
     */
     func calcMinMaxY(fromX: Float64, toX: Float64): Unit

    /**
     * Returns the first Entry object found at the given x-value with binary
     * search.
     * If the no Entry at the specified x-value is found, this method
     * returns the Entry at the closest x-value according to the rounding.
     * INFORMATION: This method does calculations at runtime. Do
     * not over-use in performance critical situations.
     *
     * @param xValue the x-value
     * @param closestToY If there are multiple y-values for the specified x-value,
     * @param rounding determine whether to round up/down/closest
     *                 if there is no Entry matching the provided x-value
     * @return
     *
     *
     */
     func getEntryForXValue(xValue: Float64, closestToY: Float64, rounding!: Rounding): ?E

    /**
     * Returns the first Entry object found at the given x-value with binary
     * search.
     * If the no Entry at the specified x-value is found, this method
     * returns the Entry at the closest x-value.
     * INFORMATION: This method does calculations at runtime. Do
     * not over-use in performance critical situations.
     *
     *
     * @param xValue the x-value
     * @param closestToY If there are multiple y-values for the specified x-value,
     * @return
     */
    //    public func getEntryForXValue(xValue: Float64, closestToY: Float64): T

    /**
     * Returns all Entry objects found at the given x-value with binary
     * search. An empty array if no Entry object at that x-value.
     * INFORMATION: This method does calculations at runtime. Do
     * not over-use in performance critical situations.
     *
     * @param xValue
     * @return
     */
     func getEntriesForXValue(xValue: Float64): ArrayList<E>

    /**
     * Returns the Entry object found at the given index (NOT xIndex) in the values array.
     *
     * @param index
     * @return
     */
     func getEntryForIndex(index: Int64): ?E

    /**
     * Returns the first Entry index found at the given x-value with binary
     * search.
     * If the no Entry at the specified x-value is found, this method
     * returns the Entry at the closest x-value according to the rounding.
     * INFORMATION: This method does calculations at runtime. Do
     * not over-use in performance critical situations.
     *
     * @param xValue the x-value
     * @param closestToY If there are multiple y-values for the specified x-value,
     * @param rounding determine whether to round up/down/closest
     *                 if there is no Entry matching the provided x-value
     * @return
     */
     func getEntryIndex(xValue: Float64, closestToY: Float64, rounding: Rounding): Int64

    /**
     * Returns the position of the provided entry in the DataSets Entry array.
     * Returns -1 if doesn't exist.
     *
     * @param e
     * @return
     */
     func getEntryIndexByEntry(e: E): Int64

    /**
     * This method returns the actual
     * index in the Entry array of the DataSet for a given xIndex. IMPORTANT: This method does
     * calculations at runtime, do not over-use in performance critical
     * situations.
     *
     * @param xIndex
     * @return
     */
     func getIndexInEntries(xIndex: Float64): Int64

    /**
     * Adds an Entry to the DataSet dynamically.
     * Entries are added to the end of the list.
     * This will also recalculate the current minimum and maximum
     * values of the DataSet and the value-sum.
     *
     * @param e
     */
     func addEntry(e: ?E): Bool

    /**
     * Adds an Entry to the DataSet dynamically.
     * Entries are added to their appropriate index in the values array respective to their x-position.
     * This will also recalculate the current minimum and maximum
     * values of the DataSet and the value-sum.
     *
     * @param e
     */
     func addEntryOrdered(e: E): Unit

    /**
     * Removes the first Entry (at index 0) of this DataSet from the entries array.
     * Returns true if successful, false if not.
     *
     * @return
     */
     func removeFirst(): Bool

    /**
     * Removes the last Entry (at index size-1) of this DataSet from the entries array.
     * Returns true if successful, false if not.
     *
     * @return
     */
     func removeLast(): Bool

    /**
     * Removes an Entry from the DataSets entries array. This will also
     * recalculate the current minimum and maximum values of the DataSet and the
     * value-sum. Returns true if an Entry was removed, false if no Entry could
     * be removed.
     *
     * @param e
     */
     func removeEntry(e: E): Bool

    /**
     * Removes the Entry object closest to the given x-value from the DataSet.
     * Returns true if an Entry was removed, false if no Entry could be removed.
     *
     * @param xValue
     */
     func removeEntryByXValue(xValue: Float64): Bool

    /**
     * Removes the Entry object at the given index in the values array from the DataSet.
     * Returns true if an Entry was removed, false if no Entry could be removed.
     *
     * @param index
     * @return
     */
     func removeEntryByIndex(indexL: Int64): Bool

    /**
     * Checks if this DataSet contains the specified Entry. Returns true if so,
     * false if not. NOTE: Performance is pretty bad on this one, do not
     * over-use in performance critical situations.
     *
     * @param entry
     * @return
     */
     func contains(entry: E): Bool

    /**
     * Removes all values from this DataSet and does all necessary recalculations.
     */
     func clear(): Unit

    /** ###### ###### STYLING RELATED (& OTHER) METHODS ###### ###### */

    /**
     * Returns the label string that describes the DataSet.
     *
     * @return
     */
     func getLabel(): String

    /**
     * Sets the label string that describes the DataSet.
     *
     * @param label
     */
     func setLabel(label: String): Unit

    /**
     * Returns the axis this DataSet should be plotted against.
     *
     * @return
     */
     func getAxisDependency(): AxisDependency

    /**
     * Set the y-axis this DataSet should be plotted against (either LEFT or
     * RIGHT). Default: LEFT
     *
     * @param dependency
     */
     func setAxisDependency(dependency: AxisDependency): Unit

    /**
     * returns all the colors that are set for this DataSet
     *
     * @return
     */
     func getColors(): ArrayList<UInt32>

    /**
     * Returns the first color (index 0) of the colors-array this DataSet
     * contains. This is only used for performance reasons when only one color is in the colors array (size == 1)
     *
     * @return
     */
     func getColor(): UInt32

    /**
     * Returns the color at the given index of the DataSet's color array.
     * Performs a IndexOutOfBounds check by modulus.
     *
     * @param index
     * @return
     */
     func getColor(index: Int64): UInt32

    /**
     * returns true if highlighting of values is enabled, false if not
     *
     * @return
     */
     func isHighlightEnabled(): Bool

    /**
     * If set to true, value highlighting is enabled which means that values can
     * be highlighted programmatically or by touch gesture.
     *
     * @param enabled
     */
     func setHighlightEnabled(enabled: Bool): Unit

    /**
     * Sets the formatter to be used for drawing the values inside the chart. If
     * no formatter is set, the chart will automatically determine a reasonable
     * formatting (concerning decimals) for all the values that are drawn inside
     * the chart. Use chart.getDefaultValueFormatter() to use the formatter
     * calculated by the chart.
     *
     * @param f
     */
     func setValueFormatter(f: IValueFormatter): Unit

    /**
     * Returns the formatter used for drawing the values inside the chart.
     *
     * @return
     */
     func getValueFormatter(): ?IValueFormatter

    /**
     * Returns true if the valueFormatter object of this DataSet is null.
     *
     * @return
     */
     func needsFormatter(): Bool

    /**
     * Sets the color the value-labels of this DataSet should have.
     *
     * @param color
     */
     func setValueTextColor(color: UInt32): Unit

    /**
     * Sets a list of colors to be used as the colors for the drawn values.
     *
     * @param colors
     */
     func setValueTextColors(colors: ArrayList<UInt32>): Unit

    /**
     * Sets a Typeface for the value-labels of this DataSet.
     *
     * @param tf
     */
     func setValueTypeface(tf: FontFamily): Unit

    /**
     * Sets the text-size of the value-labels of this DataSet in dp.
     *
     * @param size
     */
     func setValueTextSize(size: Float64): Unit

    /**
     * Returns only the first color of all colors that are set to be used for the values.
     *
     * @return
     */
    //    public func getValueTextColor(): Int64

    /**
     * Returns the color at the specified index that is used for drawing the values inside the chart.
     * Uses modulus internally.
     *
     * @param index
     * @return
     */
     func getValueTextColor(index: ?Int64): UInt32

    /**
     * Returns the typeface that is used for drawing the values inside the chart
     *
     * @return
     */
     func getValueTypeface(): FontFamily

    /**
     * Returns the text size that is used for drawing the values inside the chart
     *
     * @return
     */
     func getValueTextSize(): Float64

    /**
     * The form to draw for this dataset in the legend.
     * <p/>
     * Return `DEFAULT` to use the default legend form.
     */
     func getForm(): LegendForm

    /**
     * The form size to draw for this dataset in the legend.
     * <p/>
     * Return `Float.NaN` to use the default legend form size.
     */
     func getFormSize(): Float64

    /**
     * The line width for drawing the form of this dataset in the legend
     * <p/>
     * Return `Float.NaN` to use the default legend form line width.
     */
     func getFormLineWidth(): Float64

    /**
     * The line dash path effect used for shapes that consist of lines.
     * <p/>
     * Return `null` to use the default legend form line dash effect.
     */
     func getFormLineDashEffect(): ?DashPathEffect

    /**
     * set this to true to draw y-values on the chart.
     *
     * NOTE (for bar and line charts): if `maxVisibleCount` is reached, no values will be drawn even
     * if this is enabled
     * @param enabled
     */
     func setDrawValues(enabled: Bool): Unit

    /**
     * Returns true if y-value drawing is enabled, false if not
     *
     * @return
     */
     func isDrawValuesEnabled(): Bool

    /**
     * Set this to true to draw y-icons on the chart.
     *
     * NOTE (for bar and line charts): if `maxVisibleCount` is reached, no icons will be drawn even
     * if this is enabled
     *
     * @param enabled
     */
     func setDrawIcons(enabled: Bool): Unit

    /**
     * Returns true if y-icon drawing is enabled, false if not
     *
     * @return
     */
     func isDrawIconsEnabled(): Bool

    /**
     * Offset of icons drawn on the chart.
     *
     * For all charts except Pie and Radar it will be ordinary (x offset,y offset).
     *
     * For Pie and Radar chart it will be (y offset, distance from center offset); so if you want icon to be rendered under value, you should increase X component of CGPoint, and if you want icon to be rendered closet to center, you should decrease height component of CGPoint.
     * @param offset
     */
     func setIconsOffset(offset: MPPointF): Unit

    /**
     * Get the offset for drawing icons.
     */
     func getIconsOffset(): MPPointF

    /**
     * Set the visibility of this DataSet. If not visible, the DataSet will not
     * be drawn to the chart upon refreshing it.
     *
     * @param visible
     */
     func setVisible(visible: Bool): Unit

    /**
     * Returns true if this DataSet is visible inside the chart, or false if it
     * is currently hidden.
     *
     * @return
     */
     func isVisible(): Bool
}
