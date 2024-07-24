/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package mpchart.pie

public abstract class ChartModel<D, S, E> <: ChartInterface<D, S, E> & AnimatorUpdateListener where D <: ChartData<S, E>,
    S <: IDataSet<E>, E <: EntryOhos {
    public var mJobs: ArrayList<MoveViewJob> = ArrayList<MoveViewJob>()
    public static let LOG_TAG: String = "mpchart: "
    /**
     * flag that indicates if logging is enabled or not
     */
    protected var mLogEnabled: Bool = false
    /**
     * object that holds all data that was originally set for the chart, before
     * it was modified or any filtering algorithms had been applied
     */
    protected var mData: ?D = None
    /**
     * Flag that indicates if highlighting per tap (touch) is enabled
     */
    protected var mHighLightPerTapEnabled: Bool = true
    protected var mHighLightPerLongPressEnabled: Bool = true
    /**
     * If set to true, chart continues to scroll after touch up
     */
    private var mDragDecelerationEnabled: Bool = true
    /**
     * Deceleration friction coefficient in [0  1] interval, higher values
     * indicate that speed will decrease slowly, for example if it set to 0, it
     * will stop immediately. 1 is an invalid value, and will be converted to
     * 0.999f automatically.
     */
    private var mDragDecelerationFrictionCoef: Float64 = 0.9
    /**
     * default value-formatter, number of digits depends on provided chart-data
     */
    protected var mDefaultValueFormatter: DefaultValueFormatter = DefaultValueFormatter(0)
    /**
     * paint object used for drawing the description text in the bottom right
     * corner of the chart
     */
    protected var mDescPaint: Paint = Paint()
    /**
     * paint object for drawing the information text when there are no values in
     * the chart
     */
    protected var mInfoPaint: Paint = Paint()
    /**
     * the object representing the labels on the x-axis
     */
    protected var mXAxis: ?XAxis = None
    /**
     * if true, touch gestures are enabled on the chart
     */
    protected var mTouchEnabled: Bool = true
    /**
     * the object responsible for representing the description text
     */
    protected var mDescription: Description
    /**
     * the legend object containing all data associated with the legend
     */
    protected var mLegend: Legend
    /**
     * listener that is called when a value on the chart is selected
     */
    protected var mSelectionListener: ?OnChartValueSelectedListener = None
    protected var mChartTouchListener: ?ChartTouchListener<D, S, E> = None
    /**
     * text that is displayed when the chart is empty
     */
    private var mNoDataText: String = "No chart data available."
    /**
     * Gesture listener for custom callbacks when making gestures on the chart.
     */
    private var mGestureListener: ?OnChartGestureListener = None
    /**
     * object responsible for rendering the data
     */
    protected var mRenderer: ?DataRenderer = None
    protected var mHighlighter: ?IHighlighter = None
    /**
     * object that manages the bounds and drawing constraints of the chart
     */
    protected var mViewPortHandler: ViewPortHandler = ViewPortHandler()
    protected var mLegendRenderer: ?LegendRenderer = None
    /**
     * object responsible for animations
     */
    protected var mAnimator: ?ChartAnimator = None
    /**
     * Extra offsets to be appended to the viewport
     */
    private var mExtraTopOffset: Float64 = 0.0
    private var mExtraRightOffset: Float64 = 0.0
    private var mExtraBottomOffset: Float64 = 0.0
    private var mExtraLeftOffset: Float64 = 0.0
    protected var width: Float64 = Utils.handleDataValues(50.0)
    protected var height: Float64 = Utils.handleDataValues(50.0)

    public func getYChartMin(): Float64

    public func getYChartMax(): Float64

    public func getMaxVisibleCount(): Int64

    public func onAnimationUpdate(result: AnimatorResult): Unit {
        this.invalidate();
    }

    /**
     * initialize all paints and stuff
     */
    public init() {

        this.mMaxHighlightDistance = Utils.handleDataValues(500.0)
        this.mDescription = Description()
        this.mLegend = Legend()

        this.mLegendRenderer = LegendRenderer(this.mViewPortHandler, this.mLegend)
        this.mXAxis = XAxis()
        this.mDescPaint = Paint()
        this.mInfoPaint = Paint()
        this.mInfoPaint.setColor(Color.RED)
        this.mInfoPaint.setTextAlign(TextAlignStyle.Center)
        this.mInfoPaint.setTextSize(Utils.handleDataValues(12.0))

        if (this.mLogEnabled) {
            AppLog.info("Chart.init()")
        }
    }

    public func setData(data: ?D): Unit {
        this.mData = data
        this.mOffsetsCalculated = false

        if (let Some(d) <- data) {
            // calculate how many digits are needed
            // 缺失方法
            this.setupDefaultFormatter(d.getYMin(), d.getYMax())

            if (let Some(md) <- this.mData) {
                var dataSets = md.getDataSets()
                for (item in dataSets) {
                    if (item.needsFormatter() || refEq(
                        (item.getValueFormatter()() as DefaultValueFormatter)(),
                        this.mDefaultValueFormatter
                    )) {
                        item.setValueFormatter(this.mDefaultValueFormatter)
                    }
                }
            }

            // let the chart know there is new data
            this.notifyDataSetChanged()

            this.invalidate()

            if (this.mLogEnabled) {
                AppLog.info(LOG_TAG + ":Data is set.")
            }
        } else {
            return
        }
    }

    /**
     * Clears the chart from all data (sets it to null) and refreshes it (by
     * calling invalidate()).
     */
    public func clear(): Unit {
        this.mData = None
        this.mOffsetsCalculated = false
        this.mIndicesToHighlight = Option<Array<Highlight>>.None
        if (this.mChartTouchListener.isSome()) {
            this.mChartTouchListener().setLastHighlighted(Option<Highlight>.None)
        }
        this.invalidate()
    }

    /**
     * Removes all DataSets (and thereby Entries) from the chart. Does not set the data object to null. Also refreshes the
     * chart by calling invalidate().
     */
    public func clearValues(): Unit {
        if (let Some(md) <- this.mData) {
            md.clearValues()
        }
        this.invalidate()
    }

    /**
     * Returns true if the chart is empty (meaning it's data object is either
     * null or contains no entries).
     *
     * @return
     */
    public func isEmpty(): Bool {
        if (let Some(md) <- this.mData) {
            if (this.mData().getEntryCount() <= 0) {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }

    /**
     * Either posts a job immediately if the chart has already setup it's
     * dimensions or adds the job to the execution queue.
     *
     * @param job
     */
    public func addViewportJob(job: MoveViewJob): Unit {
        if (this.mViewPortHandler.hasChartDimens()) {
            job.run()
        } else {
            this.mJobs.append(job)
        }
    }

    /**
     * Lets the chart know its underlying data has changed and performs all
     * necessary recalculations. It is crucial that this method is called
     * every time data is changed dynamically. Not calling this method can lead
     * to crashes or unexpected behaviour.
     */
    public open func notifyDataSetChanged(): Unit

    /**
     * Calculates the offsets of the chart to the border depending on the
     * position of an eventual legend or depending on the length of the y-axis
     * and x-axis labels and their position
     */
    public open func calculateOffsets(): Unit

    /**
     * Calculates the y-min and y-max value and the y-delta and x-delta value
     */
    protected func calcMinMax(): Unit

    /**
     * Calculates the required number of digits for the values that might be
     * drawn in the chart (if enabled), and creates the default-value-formatter
     */
    protected func setupDefaultFormatter(mins: Float64, maxs: Float64): Unit {
        var reference: Float64 = 0.0

        if (this.mData.isNone() || this.mData().getEntryCount() < 2) {
            reference = max(abs(mins), abs(maxs))
        } else {
            reference = abs(maxs - mins)
        }

        var digits: Int64 = Int64(Utils.getDecimals(reference))

        // setup the formatter with a new number of digits
        this.mDefaultValueFormatter.setup(digits)
    }

    /**
     * flag that indicates if offsets calculation has already been done or not
     */
    private var mOffsetsCalculated: Bool = false
    public var mChartSizeCorrected: Bool = false

    public open func onDraw(c: CanvasRenderingContext2D): Unit {
        if (!this.mChartSizeCorrected) {
            return
        }
        if (this.mData.isNone()) {
            c.clearRect(0, 0, 0, 0)
            let hasText: Bool = !this.strIsEmpty(this.mNoDataText)

            if (hasText) {
                let pt: MPPointF = this.getCenter()

                Utils.resetContext2DStyle(c, this.mInfoPaint)
                match (this.mInfoPaint.getTextAlign()) {
                    case TextAlignStyle.Start =>
                        pt.x = 0.0
                        c.strokeText(this.mNoDataText, pt.x, pt.y)
                    case TextAlignStyle.End =>
                        pt.x *= 2.0
                        c.strokeText(this.mNoDataText, pt.x, pt.y)
                    case _ => c.strokeText(this.mNoDataText, pt.x, pt.y)
                }
                return
            }
        }
        if (!this.mOffsetsCalculated && this.mChartSizeCorrected) {
            this.calculateOffsets()
            this.mOffsetsCalculated = true
        }
    }

    public func strIsEmpty(str: ?String): Bool {
        return str.isNone() || str().size == 0
    }

    /**
     * Draws the description text in the bottom right corner of the chart (per default)
     */
    protected func drawDescription(c: CanvasRenderingContext2D): Unit {


        // check if description should be drawn
        if (this.mDescription.isEnabled()) {
            let position: ?MPPointF = this.mDescription.getPosition()

            this.mDescPaint.setFontFamily(this.mDescription.getTypeface())
            this.mDescPaint.setTextSize(this.mDescription.getTextSize())
            this.mDescPaint.setColor(this.mDescription.getTextColor())
            this.mDescPaint.setTextAlign(this.mDescription.getTextAlign())

            var x: Float64 = 0.0
            var y: Float64 = 0.0

            // if no position specified, draw on default position
            if (let Some(p) <- position) {
                x = position().x
                y = position().y
            } else {
                x = getWidth() - this.mViewPortHandler.offsetRight() - this.mDescription.getXOffset()
                y = getHeight() - this.mViewPortHandler.offsetBottom() - this.mDescription.getYOffset()
            }
            Utils.resetContext2DStyle(c, this.mDescPaint)
            c.strokeText(this.mDescription.getText(), x, y)
        }

    }

    /**
     * ################ ################ ################ ################
     */
    /** BELOW THIS CODE FOR HIGHLIGHTING */

    /**
     * array of Highlight objects that reference the highlighted slices in the
     * chart
     */
    protected var mIndicesToHighlight: ?Array<Highlight> = Option<Array<Highlight>>.None
    /**
     * The maximum distance in vp away from an entry causing it to highlight.
     */
    protected var mMaxHighlightDistance: Float64 = 0.0
    protected var mLastGesture = LastGesture.NONE

    public func setLastGestureSingleTap(): Unit {
        this.mLastGesture = LastGesture.SINGLE_TAP
    }

    public func setLastGestureLongPress(): Unit {
        this.mLastGesture = LastGesture.LONG_PRESS
    }

    public func getMaxHighlightDistance(): Float64 {
        return this.mMaxHighlightDistance
    }

    /**
     * Sets the maximum distance in screen dp a touch can be away from an entry to cause it to get highlighted.
     * Default: 500dp
     *
     * @param distDp
     */
    public func setMaxHighlightDistance(distDp: Float64): Unit {
        this.mMaxHighlightDistance = Utils.handleDataValues(distDp)
    }

    /**
     * Returns the array of currently highlighted values. This might a null or
     * empty array if nothing is highlighted.
     *
     * @return
     */
    public func getHighlighted(): ?Array<Highlight> {
        return this.mIndicesToHighlight
    }

    /**
     * Returns true if values can be highlighted via tap gesture, false if not.
     *
     * @return
     */
    public func isHighlightPerTapEnabled(): Bool {
        return this.mHighLightPerTapEnabled
    }

    public func isHighlightPerLongPressEnabled(): Bool {
        return this.mHighLightPerLongPressEnabled
    }

    /**
     * Set this to false to prevent values from being highlighted by tap gesture.
     * Values can still be highlighted via drag or programmatically. Default: true
     *
     * @param enabled
     */
    public func setHighlightPerTapEnabled(enabled: Bool) {
        this.mHighLightPerTapEnabled = enabled
    }

    public func setHighlightPerLongPressEnabled(enabled: Bool) {
        this.mHighLightPerLongPressEnabled = enabled
    }

    /**
     * Returns true if there are values to highlight, false if there are no
     * values to highlight. Checks if the highlight array is null, has a length
     * of zero or if the first object is null.
     *
     * @return
     */
    public func valuesToHighlight(): Bool {
        if (this.mIndicesToHighlight.isNone() || this.mIndicesToHighlight().size <= 0) {
            return false
        } else {
            return true
        }
    }

    /**
     * Sets the last highlighted value for the touchlistener.
     *
     * @param highs
     */
    protected func setLastHighlighted(highs: ?Array<Highlight>): Unit {
        if (highs.isNone() || highs().size <= 0) {
            this.mChartTouchListener().setLastHighlighted(Option<Highlight>.None)
        } else {
            this.mChartTouchListener().setLastHighlighted(highs()[0])
        }
    }

    /**
     * Highlights the values at the given indices in the given DataSets. Provide
     * null or an empty array to undo all highlighting. This should be used to
     * programmatically highlight values.
     * This method *will not* call the listener.
     *
     * @param highs
     */
    public func highlightValuesForArray(highs: Array<Highlight>) {

        // set the indices to highlight
        this.mIndicesToHighlight = highs

        this.setLastHighlighted(highs)

        // redraw the chart
        this.invalidate()
    }

    /**
     * Highlights any y-value at the given x-value in the given DataSet.
     * Provide -1 as the dataSetIndex to undo all highlighting.
     * @param x The x-value to highlight
     * @param y The y-value to highlight. Supply `NaN` for "any"
     * @param dataSetIndex The dataset index to search in
     * @param dataIndex The data index to search in (only used in CombinedChartView currently)
     * @param callListener Should the listener be called for this change
     */
    public open func highlightValue(x: Float64, dataSetIndex: Int64, dataIndex: Int64): Unit {
        highlightValue(x, dataSetIndex, dataIndex, true)
    }

    public func highlightValue(x: Float64, dataSetIndex: Int64): Unit {
        highlightValue(x, dataSetIndex, -1, true)
    }

    public func highlightValue(x: Float64, y: Float64, dataSetIndex: Int64, dataIndex: Int64): Unit {
        highlightValue(x, y, dataSetIndex, dataIndex, true)
    }

    public func highlightValue(x: Float64, y: Float64, dataSetIndex: Int64): Unit {
        highlightValue(x, y, dataSetIndex, -1, true)
    }

    public func highlightValue(x: Float64, dataSetIndex: Int64, dataIndex: Int64, callListener: Bool): Unit {
        highlightValue(x, Float64.NaN, dataSetIndex, dataIndex, callListener)
    }

    public func highlightValue(x: Float64, dataSetIndex: Int64, callListener: Bool): Unit {
        highlightValue(x, Float64.NaN, dataSetIndex, -1, callListener)
    }

    public func highlightValue(x: Float64, y: Float64, dataSetIndex: Int64, dataIndex: Int64, callListener: Bool) {
        if (dataSetIndex < 0 || dataSetIndex >= this.mData().getDataSetCount()) {
            this.highlightValueForObject(Option<Highlight>.None, callListener)
        } else {
            this.highlightValueForObject(
                Highlight(x, y: y, dataSetIndex: dataSetIndex, dataIndex: dataIndex, stackIndex: 0, xPx: 0.0, yPx: 0.0, axis: Option<AxisDependency>.None),
                callListener
            )
        }
    }

    public func highlightValue(x: Float64, y: Float64, dataSetIndex: Int64, callListener: Bool): Unit {
        highlightValue(x, y, dataSetIndex, -1, callListener)
    }

    public func highlightValue(high: ?Highlight): Unit {
        highlightValueForObject(high, false)
    }
    /**
     * Highlights the value selected by touch gesture. Unlike
     * highlightValues(...), this generates a callback to the
     * OnChartValueSelectedListener.
     *
     * @param high         - the highlight object
     * @param callListener - call the listener
     */
    public func highlightValueForObject(high: ?Highlight, callListener: Bool): Unit {
        var highlight = high

        //    let callListenerBool: Bool = match (callListener) {
        //    	case Some(_) => callListener()
        //        case None => false
        //    }
        var e: ?EntryOhos = Option<EntryOhos>.None

        if (highlight.isNone()) {
            this.mIndicesToHighlight = Option<Array<Highlight>>.None
        } else {
            if (this.mLogEnabled) {
                AppLog.info(LOG_TAG + ":Highlighted: " + highlight().toString())
            }

            // 缺失方法
            if (let Some(md) <- this.mData) {
                e = md.getEntryForHighlight(highlight())
                // e = null
                if (e.isNone()) {
                    this.mIndicesToHighlight = Option<Array<Highlight>>.None
                    highlight = Option<Highlight>.None
                } else {

                    // set the indices to highlight
                    this.mIndicesToHighlight = [highlight()]
                }
            }
        }
        if (this.mIndicesToHighlight.isNone()) {
            this.setLastHighlighted(this.mIndicesToHighlight)
        }

        if (callListener && this.mSelectionListener.isSome()) {
            let isHighLight = this.valuesToHighlight()
            if (!isHighLight) {
                this.mSelectionListener().onNothingSelected()
            } else {
                // notify the listener
                if (e.isSome() && high.isSome()) {
                    //          this.mSelectionListener().onValueSelected(e, highlight)
                }
            }
        }

        // redraw the chart
        this.invalidate()
    }

    public func invalidate(): Unit

    public func setContext2D(context2d: CanvasRenderingContext2D): Unit

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64): Unit

    /**
     * Returns the Highlight object (contains x-index and DataSet index) of the
     * selected value at the given touch point inside the Line-, Scatter-, or
     * CandleStick-Chart.
     *
     * @param x
     * @param y
     * @return
     */
    public open func getHighlightByTouchPoint(x: Float64, y: Float64): ?Highlight {
        if (this.mData.isNone()) {
            AppLog.error(LOG_TAG + ":Can't select by touch. No data set.")
            return Option<Highlight>.None
        } else {
            let hghLighter = this.getHighlighter()
            if (let Some(h) <- hghLighter) {
                return h.getHighlight(x, y)
            } else {
                return Option<Highlight>.None
            }
        }
    }

    /**
     * Set a new (e.g. custom) ChartTouchListener NOTE: make sure to
     * setTouchEnabled(true) if you need touch gestures on the chart
     *
     * @param l
     */
    public func setOnTouchListener(l: ChartTouchListener<D, S, E>): Unit {
        this.mChartTouchListener = l
    }

    /**
     * Returns an instance of the currently active touch listener.
     *
     * @return
     */
    public func getOnTouchListener(): ?ChartTouchListener<D, S, E> {
        return this.mChartTouchListener
    }

    /**
     * ################ ################ ################ ################
     */
    /** BELOW CODE IS FOR THE MARKER VIEW */

    /**
     * if set to true, the marker view is drawn when a value is clicked
     */
    protected var mDrawMarkers: Bool = true
    protected var mDrawLongPressMarkers: Bool = true
    /**
     * the view that represents the marker
     */
    protected var mMarker: ?IMarker = Option<IMarker>.None
    protected var mLongPressMarker: ?IMarker = Option<IMarker>.None

    /**
     * draws all MarkerViews on the highlighted positions
     */
    protected func drawMarkers(c: CanvasRenderingContext2D): Unit {
        match (mLastGesture) {
            case LastGesture.SINGLE_TAP => ()
            case _ => return
        }

        // let paints: Paint[] = []

        // if there is no marker view or drawing marker is disabled
        if (this.mMarker.isNone() || this.isDrawMarkersEnabled() || !this.valuesToHighlight()) {
            return
        }

        if (let Some(h) <- this.mIndicesToHighlight) {
            if (let Some(md) <- this.mData) {
                for (highlight in h) {
                    var dataSet: ?S = md.getDataSetByIndex(highlight.getDataSetIndex())

                    if (let Some(d: IDataSet<EntryOhos>) <- dataSet) {
                        let e: ?EntryOhos = md.getEntryForHighlight(highlight)
                        var entryIndex: Int64
                        if (let Some(ee) <- e) {
                            entryIndex = d.getEntryIndexByEntry(ee)
                            let pos: Array<Float64> = this.getMarkerPosition(highlight)

                            // check bounds
                            if (!this.mViewPortHandler.isInBounds(pos[0], pos[1])) {
                                continue
                            }
                            if (let Some(marker) <- this.mMarker) {
                                // callbacks to update the content
                                // this.mMarker.refreshContent(e, highlight)
                                marker.draw(c, pos[0], pos[1], ee, highlight)

                            }
                        }

                    }
                }
            }
        }
        // return paints
    }

    protected func drawLongPressMarkers(c: CanvasRenderingContext2D): Unit {
        match (mLastGesture) {
            case LastGesture.LONG_PRESS => ()
            case _ => return
        }

        if (this.mLongPressMarker.isNone() || !this.isDrawLongPressMarkersEnabled() || !this.valuesToHighlight()) {
            return
        }

        if (this.mIndicesToHighlight.isSome() && this.mData.isSome()) {
            for (highlight in this.mIndicesToHighlight()) {
                let dataSet = this.mData().getDataSetByIndex(highlight.getDataSetIndex())
                if (let Some(d:IDataSet<EntryOhos>) <- dataSet) {
                    let e: ?EntryOhos = this.mData().getEntryForHighlight(highlight)
                    if (e.isNone()) {
                        continue
                    }
                    let entryIndex: Int64 = d.getEntryIndexByEntry(e())
                    if (e.isNone() || this.mAnimator.isNone() || Float64(entryIndex) >
                        Float64(d.getEntryCount()) * this.mAnimator().getPhaseX()) {
                        continue
                    }
                    let pos: Array<Float64> = this.getMarkerPosition(highlight)
                    if (!this.mViewPortHandler.isInBounds(pos[0], pos[1])) {
                        continue
                    }
                    if (this.mLongPressMarker.isSome()) {
                        this.mLongPressMarker().draw(c, pos[0], pos[1], e(), highlight)
                    }
                }
            }
        }
    }

    /**
     * Returns the actual position in pixels of the MarkerView for the given
     * Highlight object.
     *
     * @param high
     * @return
     */
    public open func getMarkerPosition(high: Highlight): Array<Float64> {
        return [high.getDrawX(), high.getDrawY()]
    }

    /** CODE BELOW THIS RELATED TO ANIMATION */

    /**
     * Returns the animator responsible for animating chart values.
     *
     * @return
     */
    public func getAnimator(): ?ChartAnimator {
        return this.mAnimator
    }

    /**
     * If set to true, chart continues to scroll after touch up default: true
     */
    public func isDragDecelerationEnabled(): Bool {
        return this.mDragDecelerationEnabled
    }

    /**
     * If set to true, chart continues to scroll after touch up. Default: true.
     *
     * @param enabled
     */
    public func setDragDecelerationEnabled(enabled: Bool) {
        this.mDragDecelerationEnabled = enabled
    }

    /**
     * Returns drag deceleration friction coefficient
     *
     * @return
     */
    public func getDragDecelerationFrictionCoef(): Float64 {
        return this.mDragDecelerationFrictionCoef
    }

    /**
     * Deceleration friction coefficient in [0  1] interval, higher values
     * indicate that speed will decrease slowly, for example if it set to 0, it
     * will stop immediately. 1 is an invalid value, and will be converted to
     * 0.999f automatically.
     *
     * @param newValue
     */
    public func setDragDecelerationFrictionCoef(newValue: Float64) {
        var value = newValue
        if (value < 0.0) {
            value = 0.0
        }

        if (value >= 1.0) {
            value = 0.999
        }
        this.mDragDecelerationFrictionCoef = value
    }

    /** CODE BELOW FOR PROVIDING EASING FUNCTIONS */

    /**
     * Animates the drawing / rendering of the chart on both x- and y-axis with
     * the specified animation time. If animate(...) is called, no further
     * calling of invalidate() is necessary to refresh the chart. ANIMATIONS
     *
     * @param durationMillisX
     * @param durationMillisY
     * @param easingX         a custom easing function to be used on the animation phase
     * @param easingY         a custom easing function to be used on the animation phase
     */
    public func animateXY(durationMillisX: Int32, durationMillisY: Int32, easingX!: String = "linear", easingY!: String = "linear"): Unit {
        if (this.mAnimator.isNone()) {
            return
        }
        this.mAnimator().animateXY(durationMillisX, durationMillisY, xEasing: easingX, yEasing: easingY)
    }

    /**
     * Animates the rendering of the chart on the x-axis with the specified
     * animation time. If animate(...) is called, no further calling of
     * invalidate() is necessary to refresh the chart. ANIMATIONS ONLY WORK FOR
     *
     * @param durationMillis
     * @param easing         a custom easing function to be used on the animation phase
     */
    public func animateX(durationMillis: Int32, easing!: String = "linear"): Unit {
        if (this.mAnimator.isNone()) {
            return
        }
        this.mAnimator().animateX(durationMillis, easing: easing);
    }

    /**
     * Animates the rendering of the chart on the y-axis with the specified
     * animation time. If animate(...) is called, no further calling of
     * invalidate() is necessary to refresh the chart. ANIMATIONS ONLY WORK FOR
     *
     * @param durationMillis
     * @param easing         a custom easing function to be used on the animation phase
     */
    public func animateY(durationMillis: Int32, easing!: String = "linear"): Unit {
        if (this.mAnimator.isNone()) {
            return
        }
        this.mAnimator().animateY(durationMillis, easing: easing);
    }

    /**
     * ################ ################ ################ ################
     */
    /** BELOW THIS ONLY GETTERS AND SETTERS */

    /**
     * Returns the object representing all x-labels, this method can be used to
     * acquire the XAxis object and modify it (e.g. change the position of the
     * labels, styling, etc.)
     * R
     * @return
     */
    public func getXAxis(): ?XAxis {
        return this.mXAxis
    }

    /**
     * Returns the default IValueFormatter that has been determined by the chart
     * considering the provided minimum and maximum values.
     *
     * @return
     */
    public func getDefaultValueFormatter(): IValueFormatter {
        return this.mDefaultValueFormatter
    }

    /**
     * set a selection listener for the chart
     *
     * @param l
     */
    public func setOnChartValueSelectedListener(l: OnChartValueSelectedListener): Unit {
        this.mSelectionListener = l
    }

    /**
     * Sets a gesture-listener for the chart for custom callbacks when executing
     * gestures on the chart surface.
     *
     * @param l
     */
    public func setOnChartGestureListener(l: OnChartGestureListener): Unit {
        this.mGestureListener = l
    }

    /**
     * Returns the custom gesture listener.
     *
     * @return
     */
    public func getOnChartGestureListener(): ?OnChartGestureListener {
        return this.mGestureListener
    }

    /**
     * returns the current y-max value across all DataSets
     *
     * @return
     */
    public func getYMax(): Float64 {
        // 缺失方法
        if (this.mData.isSome()) {
            return this.mData().getYMax()
        }
        return 0.0
    }

    /**
     * returns the current y-min value across all DataSets
     *
     * @return
     */
    public func getYMin(): Float64 {
        // 缺失方法
        if (this.mData.isSome()) {
            return this.mData().getYMin()
        }
        return 0.0
    }

    public func getXChartMax(): Float64 {
        if (this.mXAxis.isSome()) {
            return this.mXAxis().mAxisMaximum
        }
        return 0.0
    }

    public func getXChartMin(): Float64 {
        if (this.mXAxis.isSome()) {
            return this.mXAxis().mAxisMinimum
        }
        return 0.0
    }

    public func getXRange(): Float64 {
        if (this.mXAxis.isSome()) {
            return this.mXAxis().mAxisRange
        }
        return 0.0
    }

    /**
     * Returns a recyclable MPPointF instance.
     * Returns the center point of the chart (the whole View) in pixels.
     *
     * @return
     */
    public func getCenter(): MPPointF {
        return MPPointF.getInstance(this.width / 2.0, this.height / 2.0)
    }

    public open func getWidth(): Float64 {
        return this.width
    }

    public open func getHeight(): Float64 {
        return this.height
    }

    /**
     * Returns a recyclable MPPointF instance.
     * Returns the center of the chart taking offsets under consideration.
     * (returns the center of the content rectangle)
     *
     * @return
     */
    public func getCenterOffsets(): ?MPPointF {
        return this.mViewPortHandler.getContentCenter()
    }

    /**
     * Sets extra offsets (around the chart view) to be appended to the
     * auto-calculated offsets.
     *
     * @param left
     * @param top
     * @param right
     * @param bottom
     */
    public func setExtraOffsets(left: Float64, top: Float64, right: Float64, bottom: Float64) {
        this.setExtraLeftOffset(left)
        this.setExtraTopOffset(top)
        this.setExtraRightOffset(right)
        this.setExtraBottomOffset(bottom)
    }

    /**
     * Set an extra offset to be appended to the viewport's top
     */
    public func setExtraTopOffset(offset: Float64) {
        this.mExtraTopOffset = Utils.handleDataValues(offset)
    }

    /**
     * @return the extra offset to be appended to the viewport's top
     */
    public func getExtraTopOffset(): Float64 {
        return this.mExtraTopOffset
    }

    /**
     * Set an extra offset to be appended to the viewport's right
     */
    public func setExtraRightOffset(offset: Float64) {
        this.mExtraRightOffset = Utils.handleDataValues(offset)
    }

    /**
     * @return the extra offset to be appended to the viewport's right
     */
    public func getExtraRightOffset(): Float64 {
        return this.mExtraRightOffset
    }

    /**
     * Set an extra offset to be appended to the viewport's bottom
     */
    public func setExtraBottomOffset(offset: Float64) {
        this.mExtraBottomOffset = Utils.handleDataValues(offset)
    }

    /**
     * @return the extra offset to be appended to the viewport's bottom
     */
    public func getExtraBottomOffset(): Float64 {
        return this.mExtraBottomOffset
    }

    /**
     * Set an extra offset to be appended to the viewport's left
     */
    public func setExtraLeftOffset(offset: Float64) {
        this.mExtraLeftOffset = Utils.handleDataValues(offset)
    }

    /**
     * @return the extra offset to be appended to the viewport's left
     */
    public func getExtraLeftOffset(): Float64 {
        return this.mExtraLeftOffset
    }

    /**
     * Set this to true to enable logcat outputs for the chart. Beware that
     * logcat output decreases rendering performance. Default: disabled.
     *
     * @param enabled
     */
    public func setLogEnabled(enabled: Bool) {
        this.mLogEnabled = enabled
    }

    /**
     * Returns true if log-output is enabled for the chart, fals if not.
     *
     * @return
     */
    public func isLogEnabled(): Bool {
        return this.mLogEnabled
    }

    /**
     * Sets the text that informs the user that there is no data available with
     * which to draw the chart.
     *
     * @param text
     */
    public func setNoDataText(text: String) {
        this.mNoDataText = text
    }

    /**
     * Sets the color of the no data text.
     *
     * @param color
     */
    public func setNoDataTextColor(color: Color) {
        this.mInfoPaint.setColor(color)
    }

    /**
     * Sets the typeface to be used for the no data text.
     *
     * @param tf
     */
    public func setNoDataTextTypeface(tf: FontFamily) {
        this.mInfoPaint.setFontFamily(tf)
    }

    /**
     * alignment of the no data text
     *
     * @param align
     */
    public func setNoDataTextAlignment(align: TextAlignStyle) {
        this.mInfoPaint.setTextAlign(align)
    }

    /**
     * Set this to false to disable all gestures and touches on the chart,
     * default: true
     *
     * @param enabled
     */
    public func setTouchEnabled(enabled: Bool) {
        this.mTouchEnabled = enabled
    }

    public func getTouchEnabled(): Bool {
        return this.mTouchEnabled
    }

    /**
     * sets the marker that is displayed when a value is clicked on the chart
     *
     * @param marker
     */
    public func setMarker(marker: IMarker) {
        this.mMarker = marker
    }

    public func setLongPressMarker(marker: IMarker) {
        this.mLongPressMarker = marker
    }

    /**
     * returns the marker that is set as a marker view for the chart
     *
     * @return
     */
    public func getMarker(): ?IMarker {
        return this.mMarker
    }

    public func getLongPressMarker(): ?IMarker {
        return this.mLongPressMarker
    }

    public func setMarkerView(v: IMarker) {
        this.setMarker(v)
    }

    public func getMarkerView(): ?IMarker {
        return this.getMarker()
    }

    /**
     * Sets a new Description object for the chart.
     *
     * @param desc
     */
    public func setDescription(desc: Description) {
        this.mDescription = desc
    }

    /**
     * Returns the Description object of the chart that is responsible for holding all information related
     * to the description text that is displayed in the bottom right corner of the chart (by default).
     *
     * @return
     */
    public func getDescription(): Description {
        return this.mDescription
    }

    /**
     * Returns the Legend object of the chart. This method can be used to get an
     * instance of the legend in order to customize the automatically generated
     * Legend.
     *
     * @return
     */
    public func getLegend(): ?Legend {
        return this.mLegend
    }

    /**
     * Returns the renderer object responsible for rendering / drawing the
     * Legend.
     *
     * @return
     */
    public func getLegendRenderer(): ?LegendRenderer {
        return this.mLegendRenderer
    }

    /**
     * Returns the rectangle that defines the borders of the chart-value surface
     * (into which the actual values are drawn).
     *
     * @return
     */
    public func getContentRect(): MyRect {
        return this.mViewPortHandler.getContentRect()
    }

    /**
     * disables intercept touchevents
     */
    public func disableScroll() {
        //        ViewParent parent = getParent()
        //        if (parent != null)
        //            parent.requestDisallowInterceptTouchEvent(true)
    }

    /**
     * enables intercept touchevents
     */
    public func enableScroll() {
        //        ViewParent parent = getParent()
        //        if (parent != null)
        //            parent.requestDisallowInterceptTouchEvent(false)
    }

    /**
     * paint for the grid background (only line and barchart)
     */
    public let PAINT_GRID_BACKGROUND: Int64 = 4
    /**
     * paint for the info text that is displayed when there are no values in the
     * chart
     */
    public let PAINT_INFO: Int64 = 7
    /**
     * paint for the description text in the bottom right corner
     */
    public let PAINT_DESCRIPTION: Int64 = 11
    /**
     * paint for the hole in the middle of the pie chart
     */
    public let PAINT_HOLE: Int64 = 13
    /**
     * paint for the text in the middle of the pie chart
     */
    public let PAINT_CENTER_TEXT: Int64 = 14
    /**
     * paint used for the legend
     */
    public let PAINT_LEGEND_LABEL: Int64 = 18

    /**
     * set a new paint object for the specified parameter in the chart e.g.
     * Chart.PAINT_VALUES
     *
     * @param p     the new paint object
     * @param which Chart.PAINT_VALUES, Chart.PAINT_GRID, Chart.PAINT_VALUES,
     *              ...
     */
    public func setPaint(p: Paint, which: Int64) {
        if (which == PAINT_INFO) {
            this.mInfoPaint = p
        }
        if (which == PAINT_DESCRIPTION) {
            this.mDescPaint = p
        }
    }

    /**
     * Returns the paint object associated with the provided constant.
     *
     * @param which e.g. Chart.PAINT_LEGEND_LABEL
     * @return
     */
    public func getPaint(which: Int64): ?Paint {
        if (which == PAINT_INFO) {
            return this.mInfoPaint
        }
        if (which == PAINT_DESCRIPTION) {
            return this.mDescPaint
        }
        return Option<Paint>.None
    }

    public func isDrawMarkerViewsEnabled(): Bool {
        return this.isDrawMarkersEnabled()
    }

    public func setDrawMarkerViews(enabled: Bool) {
        this.setDrawMarkers(enabled)
    }

    /**
     * returns true if drawing the marker is enabled when tapping on values
     * (use the setMarker(IMarker marker) method to specify a marker)
     *
     * @return
     */
    public func isDrawMarkersEnabled(): Bool {
        return this.mDrawMarkers
    }

    public func isDrawLongPressMarkersEnabled(): Bool {
        return this.mDrawLongPressMarkers
    }

    /**
     * Set this to true to draw a user specified marker when tapping on
     * chart values (use the setMarker(IMarker marker) method to specify a
     * marker). Default: true
     *
     * @param enabled
     */
    public func setDrawMarkers(enabled: Bool) {
        this.mDrawMarkers = enabled
    }

    public func setDrawLongPressMarkers(enabled: Bool) {
        this.mDrawLongPressMarkers = enabled
    }

    /**
     * Returns the ChartData object that has been set for the chart.
     *
     * @return
     */
    public func getData(): ?D {
        return this.mData
    }

    /**
     * Returns the ViewPortHandler of the chart that is responsible for the
     * content area of the chart and its offsets and dimensions.
     *
     * @return
     */
    public func getViewPortHandler(): ViewPortHandler {
        return this.mViewPortHandler
    }

    /**
     * Returns the Renderer object the chart uses for drawing data.
     *
     * @return
     */
    public func getRenderer(): ?DataRenderer {
        return this.mRenderer
    }

    /**
     * Sets a new DataRenderer object for the chart.
     *
     * @param renderer
     */
    public func setRenderer(renderer: ?DataRenderer) {
        if (renderer.isSome()) {
            this.mRenderer = renderer
        }
    }

    public func getHighlighter(): ?IHighlighter {
        return this.mHighlighter
    }

    /**
     * Sets a custom highligher object for the chart that handles / processes
     * all highlight touch events performed on the chart-view.
     *
     * @param highlighter
     */
    public func setHighlighter<P, D, S, E>(highlighter: ChartHighlighter<P, D, S, E>) where P <: BarLineScatterCandleBubbleDataProvider<D, S, E> {
        this.mHighlighter = highlighter
    }

    /**
     * Returns a recyclable MPPointF instance.
     *
     * @return
     */
    public func getCenterOfView(): MPPointF {
        return this.getCenter()
    }
    public open func onSizeChanged(w: Float64, h: Float64, oldw: Float64, oldh: Float64): Unit {
        if (this.mLogEnabled) {
            AppLog.info(LOG_TAG + "OnSizeChanged()")
        }
        this.mChartSizeCorrected = true
        this.width = Float64(w)
        this.height = Float64(h)
        if (w > 0.0 && h > 0.0 && w < 10000.0 && h < 10000.0) {
            if (this.mLogEnabled) {
                AppLog.info(LOG_TAG + "Setting chart dimens, width: ${w}, height: ${h}")
            }
            this.mViewPortHandler.setChartDimens(Float64(w), Float64(h))
        } else {
            if (this.mLogEnabled) {
                AppLog.info(LOG_TAG + "*Avoiding* setting chart dimens! width: ${w}, height: ${h}")
            }
        }

        // This may cause the chart view to mutate properties affecting the view port --
        //   lets do this before we try to run any pending jobs on the view port itself
        this.notifyDataSetChanged()

        // for (Runnable r : mJobs) {
        //     post(r)
        // }
        //
        // mJobs.clear()

        // super.onSizeChanged(w, h, oldw, oldh)
    }

    //
    /**
     * Setting this to true will set the layer-type HARDWARE for the view, false
     * will set layer-type SOFTWARE.
     *
     * @param enabled
     */
    public func setHardwareAccelerationEnabled(enabled: Bool) {

    }


    /**
     * unbind flag
     */
    private var mUnbind: Bool = false
    /**
     * Set this to true to enable "unbinding" of drawables. When a View is detached
     * from a window. This helps avoid memory leaks.
     * Default: false
     *
     * @param enabled
     */
    public func setUnbindEnabled(enabled: Bool) {
        this.mUnbind = enabled
    }
}
