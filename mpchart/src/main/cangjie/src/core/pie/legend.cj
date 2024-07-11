/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

/**
 * Class representing the legend of the chart. The legend will contain one entry
 * per color and DataSet. Multiple colors in one DataSet are grouped together.
 * The legend object is NOT available before setting data to the chart.
 *
 */
public class Legend <: ComponentBase {
    /**
     * The legend entries array
     */
    private var mEntries: Array<LegendEntry> = []
    /**
     * Entries that will be appended to the end of the auto calculated entries after calculating the legend.
     * (if the legend has already been calculated, you will need to call notifyDataSetChanged() to let the changes take effect)
     */
    private var mExtraEntries: ?Array<LegendEntry> = None
    /**
     * Are the legend labels/colors a custom value or auto calculated? If false,
     * then it's auto, if true, then custom. default false (automatic legend)
     */
    private var mIsLegendCustom: Bool = false
    private var mHorizontalAlignment: LegendHorizontalAlignment = LegendHorizontalAlignment.LEFT
    private var mVerticalAlignment: LegendVerticalAlignment = LegendVerticalAlignment.BOTTOM
    private var mOrientation: LegendOrientation = LegendOrientation.HORIZONTAL
    private var mDrawInside: Bool = false
    /**
     * the text direction for the legend
     */
    private var mDirection: LegendDirection = LegendDirection.LEFT_TO_RIGHT
    /**
     * the shape/form the legend colors are drawn in
     */
    private var mShape: LegendForm = LegendForm.SQUARE
    /**
     * the size of the legend forms/shapes
     */
    private var mFormSize: Float64 = 8.0
    /**
     * the size of the legend forms/shapes
     */
    private var mFormLineWidth: Float64 = 3.0
    /**
     * Line dash path effect used for shapes that consist of lines.
     */
    private var mFormLineDashEffect: ?DashPathEffect = None
    /**
     * the space between the legend entries on a horizontal axis, default 6f
     */
    private var mXEntrySpace: Float64 = 6.0
    /**
     * the space between the legend entries on a vertical axis, default 5f
     */
    private var mYEntrySpace: Float64 = 0.0
    /**
     * the space between the legend entries on a vertical axis, default 2f
     * private float mYEntrySpace = 2f  the space between the form and the
     * actual label/text
     */
    private var mFormToTextSpace: Float64 = 1.0
    /**
     * the space that should be left between stacked forms
     */
    private var mStackSpace: Float64 = 3.0
    /**
     * the maximum relative size out of the whole chart view in percent
     */
    private var mMaxSizePercent: Float64 = 0.95

    /**
     * default constructor
     */
    public init() {
        super()
        this.mTextSize = Utils.handleDataValues(10.0)
        this.mXOffset = Utils.handleDataValues(5.0)
        this.mYOffset = Utils.handleDataValues(3.0)
    }

    public init(entries: Array<LegendEntry>) {
        super()
        this.mTextSize = Utils.handleDataValues(10.0)
        this.mXOffset = Utils.handleDataValues(5.0)
        this.mYOffset = Utils.handleDataValues(3.0)

        this.mEntries = entries
    }

    /**
     * This method sets the automatically computed colors for the legend. Use setCustom(...) to set custom colors.
     *
     * @param entries
     */
    public func setEntries(entries: ArrayList<LegendEntry>): Unit {
        this.mEntries = entries.toArray()
    }

    public func getEntries(): Array<LegendEntry> {
        return this.mEntries
    }

    /**
     * returns the maximum length in pixels across all legend labels + formsize
     * + formtotextspace
     *
     * @param p the paint object used for rendering the text
     * @return
     */
    public func getMaximumEntryWidth(p: Paint): Float64 {
        var max: Float64 = 0.0
        var maxFormSize: Float64 = 0.0
        var formToTextSpace: Float64 = Utils.handleDataValues(this.mFormToTextSpace)

        for (i in 0..this.mEntries.size) {
            let entry = this.mEntries[i]

            let formSize: Float64 = Utils.handleDataValues(
                if (entry.formSize.isNaN()) {
                this.mFormSize
            } else {
                entry.formSize
            })
            if (formSize > maxFormSize) {
                maxFormSize = formSize
            }

            let label: String = entry.label
            //if (!label) continue

            let length: Float64 = Utils.calcTextWidth(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), p, label)

            if (length > max) {
                max = length
            }
        }

        return max + maxFormSize + formToTextSpace
    }

    /**
     * returns the maximum height in pixels across all legend labels
     *
     * @param p the paint object used for rendering the text
     * @return
     */
    public func getMaximumEntryHeight(p: Paint): Float64 {
        var max: Float64 = 0.0

        for (entry in this.mEntries) {
            let label: String = entry.label
            // if (!label) continue

            let length: Float64 = Utils.calcTextHeight(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), p, label)

            if (length > max) {
                max = length
            }
        }

        return max
    }

    public func getExtraEntries(): ?Array<LegendEntry> {
        return this.mExtraEntries
    }
    public func setExtra(entriesParams: ArrayList<LegendEntry>): Unit {
        this.mExtraEntries = entriesParams.toArray()
    }

    /**
     * Entries that will be appended to the end of the auto calculated
     *   entries after calculating the legend.
     * (if the legend has already been calculated, you will need to call notifyDataSetChanged()
     *   to let the changes take effect)
     */
    public func setExtra(colors: Array<UInt32>, labels: Array<String>, entriesParams: ArrayList<LegendEntry>): Unit {
        let entries: ArrayList<LegendEntry> = ArrayList<LegendEntry>()

        for (i in 0..min(colors.size, labels.size)) {
            let entry: LegendEntry = LegendEntry()
            entry.formColor = colors[i]
            entry.label = labels[i]

            if (entry.formColor == ColorTemplate.COLOR_SKIP || entry.formColor == 0) {
                entry.form = LegendForm.NONE
            } else if (entry.formColor == ColorTemplate.COLOR_NONE) {
                entry.form = LegendForm.EMPTY
            }

            entries.append(entry)
        }

        this.mExtraEntries = entries.toArray()
    }

    /**
     * Sets a custom legend's entries array.
     * * A null label will start a group.
     * This will disable the feature that automatically calculates the legend
     *   entries from the datasets.
     * Call resetCustom() to re-enable automatic calculation (and then
     *   notifyDataSetChanged() is needed to auto-calculate the legend again)
     */
    public func setCustom(entries: ArrayList<LegendEntry>): Unit {
        this.mEntries = []
        for (i in 0..entries.size) {
            this.mEntries[i] = entries[i]
        }
        this.mIsLegendCustom = true
    }

    public func setCustomArray(entries: Array<LegendEntry>): Unit {
        this.mEntries = entries
        this.mIsLegendCustom = true
    }

    /**
     * Calling this will disable the custom legend entries (set by
     * setCustom(...)). Instead, the entries will again be calculated
     * automatically (after notifyDataSetChanged() is called).
     */
    public func resetCustom(): Unit {
        this.mIsLegendCustom = false
    }

    /**
     * @return true if a custom legend entries has been set default
     * false (automatic legend)
     */
    public func isLegendCustom(): Bool {
        return this.mIsLegendCustom
    }

    /**
     * returns the horizontal alignment of the legend
     *
     * @return
     */
    public func getHorizontalAlignment(): LegendHorizontalAlignment {
        return this.mHorizontalAlignment
    }

    /**
     * sets the horizontal alignment of the legend
     *
     * @param value
     */
    public func setHorizontalAlignment(value: LegendHorizontalAlignment): Unit {
        this.mHorizontalAlignment = value
    }

    /**
     * returns the vertical alignment of the legend
     *
     * @return
     */
    public func getVerticalAlignment(): LegendVerticalAlignment {
        return this.mVerticalAlignment
    }

    /**
     * sets the vertical alignment of the legend
     *
     * @param value
     */
    public func setVerticalAlignment(value: LegendVerticalAlignment): Unit {
        this.mVerticalAlignment = value
    }

    /**
     * returns the orientation of the legend
     *
     * @return
     */
    public func getOrientation(): LegendOrientation {
        return this.mOrientation
    }

    /**
     * sets the orientation of the legend
     *
     * @param value
     */
    public func setOrientation(value: LegendOrientation): Unit {
        this.mOrientation = value
    }

    /**
     * returns whether the legend will draw inside the chart or outside
     *
     * @return
     */
    public func isDrawInsideEnabled(): Bool {
        return this.mDrawInside
    }

    /**
     * sets whether the legend will draw inside the chart or outside
     *
     * @param value
     */
    public func setDrawInside(value: Bool): Unit {
        this.mDrawInside = value
    }

    /**
     * returns the text direction of the legend
     *
     * @return
     */
    public func getDirection(): LegendDirection {
        return this.mDirection
    }

    /**
     * sets the text direction of the legend
     *
     * @param pos
     */
    public func setDirection(pos: LegendDirection): Unit {
        this.mDirection = pos
    }

    /**
     * returns the current form/shape that is set for the legend
     *
     * @return
     */
    public func getForm(): LegendForm {
        return this.mShape
    }

    /**
     * sets the form/shape of the legend forms
     *
     * @param shape
     */
    public func setForm(shape: LegendForm): Unit {
        this.mShape = shape
    }

    /**
     * sets the size in vp of the legend forms, default 8f
     *
     * @param size
     */
    public func setFormSize(size: Float64): Unit {
        this.mFormSize = size
    }

    /**
     * returns the size in vp of the legend forms
     *
     * @return
     */
    public func getFormSize(): Float64 {
        return this.mFormSize
    }

    /**
     * sets the line width in vp for forms that consist of lines, default 3f
     *
     * @param size
     */
    public func setFormLineWidth(size: Float64): Unit {
        this.mFormLineWidth = size
    }

    /**
     * returns the line width in vp for drawing forms that consist of lines
     *
     * @return
     */
    public func getFormLineWidth(): Float64 {
        return this.mFormLineWidth
    }

    /**
     * Sets the line dash path effect used for shapes that consist of lines.
     *
     * @param dashPathEffect
     */
    public func setFormLineDashEffect(dashPathEffect: DashPathEffect): Unit {
        this.mFormLineDashEffect = dashPathEffect
    }

    /**
     * @return The line dash path effect used for shapes that consist of lines.
     */
    public func getFormLineDashEffect(): ?DashPathEffect {
        return this.mFormLineDashEffect
    }

    /**
     * returns the space between the legend entries on a horizontal axis in
     * pixels
     *
     * @return
     */
    public func getXEntrySpace(): Float64 {
        return this.mXEntrySpace
    }

    /**
     * sets the space between the legend entries on a horizontal axis in pixels,
     * converts to dp internally
     *
     * @param space
     */
    public func setXEntrySpace(space: Float64): Unit {
        this.mXEntrySpace = space
    }

    /**
     * returns the space between the legend entries on a vertical axis in pixels
     *
     * @return
     */
    public func getYEntrySpace(): Float64 {
        return this.mYEntrySpace
    }

    /**
     * sets the space between the legend entries on a vertical axis in pixels,
     * converts to dp internally
     *
     * @param space
     */
    public func setYEntrySpace(space: Float64): Unit {
        this.mYEntrySpace = space
    }

    /**
     * returns the space between the form and the actual label/text
     *
     * @return
     */
    public func getFormToTextSpace(): Float64 {
        return this.mFormToTextSpace
    }

    /**
     * sets the space between the form and the actual label/text, converts to dp
     * internally
     *
     * @param space
     */
    public func setFormToTextSpace(space: Float64): Unit {
        this.mFormToTextSpace = space
    }

    /**
     * returns the space that is left out between stacked forms (with no label)
     *
     * @return
     */
    public func getStackSpace(): Float64 {
        return this.mStackSpace
    }

    /**
     * sets the space that is left out between stacked forms (with no label)
     *
     * @param space
     */
    public func setStackSpace(space: Float64): Unit {
        this.mStackSpace = space
    }

    /**
     * the total width of the legend (needed width space)
     */
    public var mNeededWidth: Float64 = 0.0
    /**
     * the total height of the legend (needed height space)
     */
    public var mNeededHeight: Float64 = 0.0
    public var mTextHeightMax: Float64 = 0.0
    public var mTextWidthMax: Float64 = 0.0
    /**
     * flag that indicates if word wrapping is enabled
     */
    private var mWordWrapEnabled: Bool = false

    /**
     * Should the legend word wrap? / this is currently supported only for:
     * BelowChartLeft, BelowChartRight, BelowChartCenter. / note that word
     * wrapping a legend takes a toll on performance. / you may want to set
     * maxSizePercent when word wrapping, to set the point where the text wraps.
     * / default: false
     *
     * @param enabled
     */
    public func setWordWrapEnabled(enabled: Bool): Unit {
        this.mWordWrapEnabled = enabled
    }

    /**
     * If this is set, then word wrapping the legend is enabled. This means the
     * legend will not be cut off if too long.
     *
     * @return
     */
    public func isWordWrapEnabled(): Bool {
        return this.mWordWrapEnabled
    }

    /**
     * The maximum relative size out of the whole chart view. / If the legend is
     * to the right/left of the chart, then this affects the width of the
     * legend. / If the legend is to the top/bottom of the chart, then this
     * affects the height of the legend. / If the legend is the center of the
     * piechart, then this defines the size of the rectangular bounds out of the
     * size of the "hole". / default: 0.95f (95%)
     *
     * @return
     */
    public func getMaxSizePercent(): Float64 {
        return this.mMaxSizePercent
    }

    /**
     * The maximum relative size out of the whole chart view. / If
     * the legend is to the right/left of the chart, then this affects the width
     * of the legend. / If the legend is to the top/bottom of the chart, then
     * this affects the height of the legend. / default: 0.95f (95%)
     *
     * @param maxSize
     */
    public func setMaxSizePercent(maxSize: Float64): Unit {
        this.mMaxSizePercent = maxSize
    }

    private var mCalculatedLabelSizes: ArrayList<FSize> = ArrayList<FSize>()
    private var mCalculatedLabelBreakPoints: ArrayList<Bool> = ArrayList<Bool>()
    private var mCalculatedLineSizes: ArrayList<FSize> = ArrayList<FSize>()

    public func getCalculatedLabelSizes(): ArrayList<FSize> {
        return this.mCalculatedLabelSizes
    }

    public func getCalculatedLabelBreakPoints(): ArrayList<Bool> {
        return this.mCalculatedLabelBreakPoints
    }

    public func getCalculatedLineSizes(): ArrayList<FSize> {
        return this.mCalculatedLineSizes
    }

    /**
     * Calculates the dimensions of the Legend. This includes the maximum width
     * and height of a single entry, as well as the total width and height of
     * the Legend.
     *
     * @param labelpaint
     */
    public func calculateDimensions(labelpaint: Paint, viewPortHandler: ViewPortHandler): Unit {
        let defaultFormSize: Float64 = Utils.handleDataValues(this.mFormSize);
        let stackSpace: Float64 = Utils.handleDataValues(this.mStackSpace);
        let formToTextSpace: Float64 = Utils.handleDataValues(this.mFormToTextSpace);
        let xEntrySpace: Float64 = Utils.handleDataValues(this.mXEntrySpace);
        let yEntrySpace: Float64 = Utils.handleDataValues(this.mYEntrySpace);
        let wordWrapEnabled: Bool = this.mWordWrapEnabled;
        let entries: Array<LegendEntry> = this.mEntries;
        let entryCount: Int64 = entries.size;

        this.mTextWidthMax = this.getMaximumEntryWidth(labelpaint)
        this.mTextHeightMax = this.getMaximumEntryHeight(labelpaint)

        match (this.mOrientation) {
            case LegendOrientation.VERTICAL => orientationIsVERTICAL(labelpaint, entryCount, entries, defaultFormSize,
                stackSpace, formToTextSpace, yEntrySpace)

            case LegendOrientation.HORIZONTAL => orientationIsHORIZONTAL(labelpaint, entryCount, entries,
                defaultFormSize, stackSpace, formToTextSpace, yEntrySpace, viewPortHandler, xEntrySpace, wordWrapEnabled
            )
        }

        this.mNeededHeight += this.mYOffset
        this.mNeededWidth += this.mXOffset
    }

    private func orientationIsVERTICAL(labelpaint: Paint, entryCount: Int64, entries: Array<LegendEntry>,
        defaultFormSize: Float64, stackSpace: Float64, formToTextSpace: Float64, yEntrySpace: Float64) {
        var maxWidth: Float64 = 0.0;
        var maxHeight: Float64 = 0.0;
        var width: Float64 = 0.0;
        let labelLineHeight: Float64 = Utils.getLineHeight(labelpaint, CanvasRenderingContext2D(RenderingContextSettings(antialias: true)))
        var wasStacked: Bool = false;

        for (i in 0..entryCount) {
            let e: LegendEntry = entries[i];
            let drawingForm: Bool = e.form != LegendForm.NONE;
            let formSize: Float64 = if (e.formSize.isNaN()) {
                defaultFormSize
            } else {
                Utils.handleDataValues(e.formSize)
            }

            let label: String = e.label;

            if (!wasStacked) {
                width = 0.1
            }

            if (drawingForm) {
                if (wasStacked) {
                    width += stackSpace
                }

                width += formSize
            }

            // grouped forms have null labels
            if (label != "") {

                // make a step to the left
                if (drawingForm && !wasStacked) {
                    width += formToTextSpace
                } else if (wasStacked) {
                    maxWidth = max(maxWidth, width)
                    maxHeight += labelLineHeight + yEntrySpace
                    width = 0.1
                    wasStacked = false
                }

                width += Utils.calcTextWidth(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), labelpaint, label)

                maxHeight += labelLineHeight + yEntrySpace
            } else {
                wasStacked = true
                width += formSize
                if (i < entryCount - 1) {
                    width += stackSpace
                }
            }

            maxWidth = max(maxWidth, width)
        }

        this.mNeededWidth = maxWidth
        this.mNeededHeight = maxHeight
    }

    private func orientationIsHORIZONTAL(labelpaint: Paint, entryCount: Int64, entries: Array<LegendEntry>,
        defaultFormSize: Float64, stackSpace: Float64, formToTextSpace: Float64, yEntrySpace: Float64,
        viewPortHandler: ViewPortHandler, xEntrySpace: Float64, wordWrapEnabled: Bool) {
        let labelLineHeight: Float64 = Utils.getLineHeight(labelpaint,  CanvasRenderingContext2D(RenderingContextSettings(antialias: true)));
        let labelLineSpacing: Float64 = Utils.getLineSpacing(labelpaint,  CanvasRenderingContext2D(RenderingContextSettings(antialias: true))) +
            yEntrySpace;
        let contentWidth: Float64 = viewPortHandler.contentWidth() * this.mMaxSizePercent;
        AppLog.info("contentWidth = ${contentWidth}");

        // Start calculating layout
        var maxLineWidth: Float64 = 0.0;
        var currentLineWidth: Float64 = 0.0;
        var requiredWidth: Float64 = 0.0;
        var stackedStartIndex: Int64 = -1;

        this.mCalculatedLabelBreakPoints.clear();
        this.mCalculatedLabelSizes.clear();
        this.mCalculatedLineSizes.clear();

        for (i in 0..entryCount) {
            let e: LegendEntry = entries[i];
            let drawingForm: Bool = e.form != LegendForm.NONE;
            let formSize: Float64 = fontsizeFunc(e, defaultFormSize)

            let label: String = e.label;

            this.mCalculatedLabelBreakPoints.append(false);

            requiredWidth = stackedStartIndexFunc(requiredWidth, stackSpace, stackedStartIndex)

            // grouped forms have null labels
            if (label != "") {
                this.mCalculatedLabelSizes.append(Utils.calcTextSize(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), labelpaint, label));
                requiredWidth += if (drawingForm) {
                    formToTextSpace + formSize
                } else {
                    0.0
                };
                requiredWidth += this.mCalculatedLabelSizes.get(i)().width
            } else {
                this.mCalculatedLabelSizes.append(FSize.getInstance(0.0, 0.0));
                requiredWidth += if (drawingForm) {
                    formSize
                } else {
                    0.0
                };

                if (stackedStartIndex == -1) {
                    // mark this index as we might want to break here later
                    stackedStartIndex = i
                }
            }

            if ((label != "") || i == entryCount - 1) {
                let requiredSpacing: Float64 = if (currentLineWidth == 0.0) {
                    0.0
                } else {
                    xEntrySpace
                };

                if (!wordWrapEnabled // No word wrapping, it must fit.
                    // The line is empty, it must fit
                    || currentLineWidth == 0.0
                    // It simply fits
                    || (contentWidth - currentLineWidth >= requiredSpacing + requiredWidth)) {
                    // Expand current line
                    currentLineWidth += requiredSpacing + requiredWidth
                } else { // It doesn't fit, we need to wrap a line

                    // Add current line size to array
                    this.mCalculatedLineSizes.append(FSize.getInstance(currentLineWidth, labelLineHeight));
                    maxLineWidth = max(maxLineWidth, currentLineWidth)

                    // Start a new line
                    this.mCalculatedLabelBreakPoints.set(
                        if (stackedStartIndex > -1) {
                            stackedStartIndex
                        } else {
                            i
                        },
                        true
                    );

                    currentLineWidth = requiredWidth
                }

                if (i == entryCount - 1) {
                    // Add last line size to array
                    this.mCalculatedLineSizes.append(FSize.getInstance(currentLineWidth, labelLineHeight));
                    maxLineWidth = max(maxLineWidth, currentLineWidth)
                }
            }

            stackedStartIndex = if ((label != "")) {
                -1
            } else {
                stackedStartIndex
            };
        }

        this.mNeededWidth = maxLineWidth
        this.mNeededHeight = labelLineHeight
            * Float64(this.mCalculatedLineSizes.size)
            + labelLineSpacing * (if (this.mCalculatedLineSizes.size == 0) {
            0.0
        } else {
            Float64(this.mCalculatedLineSizes.size - 1)
        })
    }

    private func fontsizeFunc(e: LegendEntry, defaultFormSize: Float64): Float64 {
        return if (e.formSize.isNaN()) {
            defaultFormSize
        } else {
            Utils.handleDataValues(e.formSize)
        }
    }

    private func stackedStartIndexFunc(requiredWidth: Float64, stackSpace: Float64, stackedStartIndex: Int64): Float64 {
        var width: Float64 = requiredWidth
        if (stackedStartIndex == -1) {
            // we are not stacking, so required width is for this label
            // only
            width = 0.0
        } else {
            // add the spacing appropriate for stacked labels/forms
            width += stackSpace
        }
        return width
    }
}
