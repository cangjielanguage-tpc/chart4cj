/**
 * Created on 2024/5/11
 */
package core.pie

public class PieChartModel <: PieRadarChartBaseModel<PieData, IPieDataSet, PiEntry> {
    /**
     * rect object that represents the bounds of the piechart, needed for
     * drawing the circle
     */
    private var mCircleBox: MyRect = MyRect()
    /**
     * flag indicating if entry labels should be drawn or not
     */
    private var mDrawEntryLabels: Bool = true
    /**
     * array that holds the width of each pie-slice in degrees
     */
    private var mDrawAngles: Array<Float64> = Array<Float64>(1, item: 0.0)
    /**
     * array that holds the absolute angle in degrees of each slice
     */
    private var mAbsoluteAngles: Array<Float64> = Array<Float64>(1, item: 0.0)
    /**
     * if true, the white hole inside the chart will be drawn
     */
    private var mDrawHole: Bool = true
    /**
     * if true, the hole will see-through to the inner tips of the slices
     */
    private var mDrawSlicesUnderHole: Bool = false;
    /**
     * if true, the values inside the piechart are drawn as percent values
     */
    private var mUsePercentValues: Bool = false;
    /**
     * if true, the slices of the piechart are rounded
     */
    private var mDrawRoundedSlices: Bool = false;
    /**
     * variable for the text that is drawn in the center of the pie-chart
     */
    private var mCenterText: String = "";

    private var mCenterTextOffset: MPPointF = MPPointF.getInstance(0.0, 0.0)
    /**
     * indicates the size of the hole in the center of the piechart, default:
     * radius / 2
     */
    private var mHoleRadiusPercent: Float64 = 50.0;
    /**
     * the radius of the transparent circle next to the chart-hole in the center
     */
    protected var mTransparentCircleRadiusPercent: Float64 = 55.0;
    /**
     * if enabled, centertext is drawn
     */
    private var mDrawCenterText: Bool = true
    private var mCenterTextRadiusPercent: Float64 = 100.0
    protected var mMaxAngle: Float64 = 360.0
    /**
     * Minimum angle to draw slices, this only works if there is enough room for all slices to have
     * the minimum angle, default 0f.
     */
    private var mMinAngleForSlices: Float64 = 0.0
    public var context2d: ?CanvasRenderingContext2D = Option<CanvasRenderingContext2D>.None

    public init() {
        super();
        this.mAnimator = ChartAnimator(this)
        if (this.mAnimator.isSome()) {
            this.mRenderer = PieChartRenderer(this, this.mAnimator(), this.mViewPortHandler)
        }
        this.mXAxis = None
        let pieHigh: PieHighlighter = PieHighlighter(this);
        this.mHighlighter = pieHigh as IHighlighter
    }

    public func invalidate() {
        if (this.context2d.isSome()) {
            this.onDraw(this.context2d());
        }
    }

    public func setContext2D(context2d: CanvasRenderingContext2D) {
        this.context2d = context2d
    }

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64) {
        super.onSizeChanged(newWidth, newHeight, oldWidth, oldHeight);
    }

    public func onDraw(canvas: CanvasRenderingContext2D): Unit {
        super.onDraw(canvas);

        if (this.mData.isNone()) {
            return;
        }

        this.mRenderer?.drawData(canvas)

        if (this.valuesToHighlight() && this.mIndicesToHighlight.isSome()) {
            this.mRenderer?.drawHighlighted(canvas, this.mIndicesToHighlight())
        }

        this.mRenderer?.drawExtras(canvas)

        this.mRenderer?.drawValues(canvas, isHorizontalFlip: true)

        this.mLegendRenderer?.renderLegend(canvas)

        this.drawDescription(canvas);

        this.drawMarkers(canvas);
    }

    public func calculateOffsets(): Unit {
        super.calculateOffsets();

        // prevent nullpointer when no data set
        if (let Some(d) <- this.mData) {
            let diameter: Float64 = this.getDiameter();
            let radius: Float64 = diameter / 2.0;

            let c: ?MPPointF = this.getCenterOffsets();
            if (c.isNone()) {
                return;
            }

            let shift: Float64 = (this.mData() as PieData)().getDataSet().getSelectionShift();

            // create the circle box that will contain the pie-chart (the bounds of
            // the pie-chart)
            this.mCircleBox.set(
                c().x - radius + shift,
                c().y - radius + shift,
                c().x + radius - shift,
                c().y + radius - shift
            );

            MPPointF.recycleInstance(c());
        } else {
            return
        }
    }

    protected func calcMinMax(): Unit {
        this.calcAngles();
    }

    public func getMarkerPosition(highlight: Highlight): Array<Float64> {
        let center: MPPointF = this.getCenterCircleBox();
        var r: Float64 = this.getRadius();

        var off: Float64 = r / 10.0 * 3.6;

        if (this.isDrawHoleEnabled()) {
            off = (r - (r / 100.0 * this.getHoleRadius())) / 2.0
        }

        r -= off // offset to keep things inside the chart

        let rotationAngle: Float64 = this.getRotationAngle();

        let entryIndex: Int64 = Int64(round(highlight.getX()));

        // offset needed to center the drawn text in the slice
        let offset: Float64 = this.mDrawAngles[entryIndex] / 2.0;

        if (this.mAnimator.isNone()) {
            return [];
        }
        // calculate the text position
        let x: Float64 = /*(float)*/
            (r
            * cos(
            MyMath.toRadians((rotationAngle + this.mAbsoluteAngles[entryIndex] - offset)
            * this.mAnimator().getPhaseY())) + center.x);
        let y: Float64 = /* (float)*/
            (r
            * sin(
            MyMath.toRadians((rotationAngle + this.mAbsoluteAngles[entryIndex] - offset)
            * this.mAnimator().getPhaseY())) + center.y);

        MPPointF.recycleInstance(center);
        return [x, y] /*new float[]{x, y}*/
            ;
    }

    /**
     * calculates the needed angles for the chart slices
     */
    private func calcAngles(): Unit {
        if (let Some(d: PieData) <- this.mData) {
            let entryCount: Int64 = d.getEntryCount();

            if (this.mDrawAngles.size != entryCount) {
                this.mDrawAngles = Array<Float64>(entryCount, item: 0.0) //new float[entryCount];
            } else {
                for (i in 0..entryCount) {
                    this.mDrawAngles[i] = 0.0
                }
            }
            if (this.mAbsoluteAngles.size != entryCount) {
                this.mAbsoluteAngles = Array<Float64>(entryCount, item: 0.0) //new float[entryCount];
            } else {
                for (i in 0..entryCount) {
                    this.mAbsoluteAngles[i] = 0.0
                }
            }

            let yValueSum: Float64 = d.getYValueSum();

            let dataSets: ArrayList<IPieDataSet> = d.getDataSets();

            let hasMinAngle: Bool = this.mMinAngleForSlices != 0.0 && Float64(entryCount) * this.mMinAngleForSlices <=
                this.mMaxAngle;
            let minAngles: Array<Float64> = Array<Float64>(entryCount, item: 0.0) //new float[entryCount];

            var cnt: Int64 = 0;
            var offset: Float64 = 0.0;
            var diff: Float64 = 0.0;

            for (i in 0..d.getDataSetCount()) {
                let set: IPieDataSet = dataSets.get(i)();

                for (j in 0..set.getEntryCount()) {
                    let drawAngle: Float64 = this.calcAngle(abs(set.getEntryForIndex(j).getY()), yValueSum);

                    if (hasMinAngle) {
                        let temp: Float64 = drawAngle - this.mMinAngleForSlices;
                        if (temp <= 0.0) {
                            minAngles[cnt] = this.mMinAngleForSlices
                            offset += -temp
                        } else {
                            minAngles[cnt] = drawAngle
                            diff += temp
                        }
                    }

                    this.mDrawAngles[cnt] = drawAngle

                    if (cnt == 0) {
                        this.mAbsoluteAngles[cnt] = this.mDrawAngles[cnt]
                    } else {
                        this.mAbsoluteAngles[cnt] = this.mAbsoluteAngles[cnt - 1] + this.mDrawAngles[cnt]
                    }

                    cnt++;
                }
            }

            if (hasMinAngle) {
                // Correct bigger slices by relatively reducing their angles based on the total angle needed to subtract
                // This requires that `entryCount * mMinAngleForSlices <= mMaxAngle` be true to properly work!
                for (i in 0..entryCount) {
                    minAngles[i] -= (minAngles[i] - this.mMinAngleForSlices) / diff * offset
                    if (i == 0) {
                        this.mAbsoluteAngles[0] = minAngles[0]
                    } else {
                        this.mAbsoluteAngles[i] = this.mAbsoluteAngles[i - 1] + minAngles[i]
                    }
                }

                this.mDrawAngles = minAngles
            }
        } else {
            return
        }
    }

    /**
     * Checks if the given index is set to be highlighted.
     *
     * @param index
     * @return
     */
    public func needsHighlight(index: Float64): Bool {

        // no highlight
        if (!this.valuesToHighlight()) {
            return false;
        }

        if (this.mIndicesToHighlight.isSome()) {
            for (i in 0..this.mIndicesToHighlight().size) {
                // check if the xvalue for the given dataset needs highlight
                if (round(Float64(this.mIndicesToHighlight()[i].getX())) == index) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * calculates the needed angle for a given value
     *
     * @param value
     * @return
     */
    private func calcAngleSum(value: Float64): Float64 {
        if (let Some(d: PieData) <- this.mData) {
            return this.calcAngle(value, d.getYValueSum());
        } else {
            return -1.0;
        }
    }

    /**
     * calculates the needed angle for a given value
     *
     * @param value
     * @param yValueSum
     * @return
     */
    private func calcAngle(value: Float64, yValueSum: Float64): Float64 {
        return value / yValueSum * this.mMaxAngle;
    }

    public func getIndexForAngle(angle: Float64): Int64 {

        // take the current angle of the chart into consideration
        let a: Float64 = Utils.getNormalizedAngle(angle - this.getRotationAngle());

        for (i in 0..this.mAbsoluteAngles.size) {
            if (this.mAbsoluteAngles[i] > a) {
                return i;
            }
        }

        return -1; // return -1 if no index found
    }

    /**
     * Returns the index of the DataSet this x-index belongs to.
     *
     * @param xIndex
     * @return
     */
    public func getDataSetIndexForIndex(xIndex: Float64): Int64 {
        if (let Some(d: PieData) <- this.mData) {
            let dataSets: ArrayList<IPieDataSet> = d.getDataSets();

            for (i in 0..dataSets.size) {
                if (dataSets[i].getEntryForXValue(xIndex, Float64.NaN, rounding: Rounding.CLOSEST).isSome()) {
                    return i;
                }
            }
            return -1;
        } else {
            return -1;
        }
    }

    /**
     * returns an integer array of all the different angles the chart slices
     * have the angles in the returned array determine how much space (of 360°)
     * each slice takes
     *
     * @return
     */
    public func getDrawAngles(): Array<Float64> {
        return this.mDrawAngles;
    }

    /**
     * returns the absolute angles of the different chart slices (where the
     * slices end)
     *
     * @return
     */
    public func getAbsoluteAngles(): Array<Float64> {
        return this.mAbsoluteAngles;
    }

    /**
     * Sets the color for the hole that is drawn in the center of the PieChart
     * (if enabled).
     *
     * @param color
     */
    public func setHoleColor(color: UInt32): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)?.getPaintHole().setColor(Color(color))
    }

    /**
     * Enable or disable the visibility of the inner tips of the slices behind the hole
     */
    public func setDrawSlicesUnderHole(enable: Bool): Unit {
        this.mDrawSlicesUnderHole = enable
    }

    /**
     * Returns true if the inner tips of the slices are visible behind the hole,
     * false if not.
     *
     * @return true if slices are visible behind the hole.
     */
    public func isDrawSlicesUnderHoleEnabled(): Bool {
        return this.mDrawSlicesUnderHole;
    }

    /**
     * set this to true to draw the pie center empty
     *
     * @param enabled
     */
    public func setDrawHoleEnabled(enabled: Bool): Unit {
        this.mDrawHole = enabled
    }

    /**
     * returns true if the hole in the center of the pie-chart is set to be
     * visible, false if not
     *
     * @return
     */
    public func isDrawHoleEnabled(): Bool {
        return this.mDrawHole;
    }

    /**
     * Sets the text String that is displayed in the center of the PieChart.
     *
     * @param text
     */
    public func setCenterText(text: String /*CharSequence*/
        ): Unit {
        this.mCenterText = text
    }

    /**
     * returns the text that is drawn in the center of the pie-chart
     *
     * @return
     */
    public func getCenterText(): String /*CharSequence*/
    {
        return this.mCenterText;
    }

    /**
     * set this to true to draw the text that is displayed in the center of the
     * pie chart
     *
     * @param enabled
     */
    public func setDrawCenterText(enabled: Bool): Unit {
        this.mDrawCenterText = enabled
    }

    /**
     * returns true if drawing the center text is enabled
     *
     * @return
     */
    public func isDrawCenterTextEnabled(): Bool {
        return this.mDrawCenterText;
    }

    protected func getRequiredLegendOffset(): Float64 {
        if (this.mLegendRenderer.isSome()) {
            return this.mLegendRenderer().getLabelPaint().getTextSize() * 2.0;
        }
        return 0.0;
    }

    protected func getRequiredBaseOffset(): Float64 {
        return 0.0;
    }

    public func getRadius(): Float64 {
        return min(this.mCircleBox.width() / 2.0, this.mCircleBox.height() / 2.0);
    }

    /**
     * returns the circlebox, the boundingbox of the pie-chart slices
     *
     * @return
     */
    public func getCircleBox(): MyRect {
        return this.mCircleBox;
    }

    /**
     * returns the center of the circlebox
     *
     * @return
     */
    public func getCenterCircleBox(): MPPointF {
        return MPPointF.getInstance(this.mCircleBox.centerX(), this.mCircleBox.centerY());
    }

    /**
     * sets the typeface for the center-text paint
     *
     * @param t
     */
    public func setCenterTextTypeface(t: FontFamily): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintCenterText().setFontFamily(t);
    }

    /**
     * Sets the size of the center text of the PieChart in vp.
     *
     * @param sizeDp
     */
    public func setCenterTextSize(sizeDp: Float64): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintCenterText().setTextSize(Utils.handleDataValues(sizeDp));
    }

    /**
     * Sets the size of the center text of the PieChart in pixels.
     *
     * @param sizePixels
     */
    public func setCenterTextSizePixels(sizePixels: Float64): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintCenterText().setTextSize(sizePixels);
    }

    /**
     * Sets the offset the center text should have from it's original position in vp. Default x = 0, y = 0
     *
     * @param x
     * @param y
     */
    public func setCenterTextOffset(x: Float64, y: Float64): Unit {
        this.mCenterTextOffset.x = Utils.handleDataValues(x)
        this.mCenterTextOffset.y = Utils.handleDataValues(y)
    }

    /**
     * Returns the offset on the x- and y-axis the center text has in vp.
     *
     * @return
     */
    public func getCenterTextOffset(): MPPointF {
        return MPPointF.getInstance(this.mCenterTextOffset.x, this.mCenterTextOffset.y);
    }

    /**
     * Sets the color of the center text of the PieChart.
     *
     * @param color
     */
    public func setCenterTextColor(color: UInt32): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintCenterText().setColor(Color(color));
    }

    /**
     * sets the radius of the hole in the center of the piechart in percent of
     * the maximum radius (max = the radius of the whole chart), default 50%
     *
     * @param percent
     */
    public func setHoleRadius(percent: Float64): Unit {
        this.mHoleRadiusPercent = percent
    }

    /**
     * Returns the size of the hole radius in percent of the total radius.
     *
     * @return
     */
    public func getHoleRadius(): Float64 {
        return this.mHoleRadiusPercent;
    }

    /**
     * Sets the color the transparent-circle should have.
     *
     * @param color
     */
    public func setTransparentCircleColor(color: UInt32): Unit {
        if (this.mRenderer.isNone()) {
            return;
        }
        let p: Paint = ( /*(PieChartRenderer) */
            this.mRenderer as PieChartRenderer)().getPaintTransparentCircle();
        let alpha: Float64 = p.getGlobalAlpha();
        p.setColor(Color(color));

        p.setGlobalAlpha(alpha);
    }

    /**
     * sets the radius of the transparent circle that is drawn next to the hole
     * in the piechart in percent of the maximum radius (max = the radius of the
     * whole chart), default 55% -> means 5% larger than the center-hole by
     * default
     *
     * @param percent
     */
    public func setTransparentCircleRadius(percent: Float64): Unit {
        this.mTransparentCircleRadiusPercent = percent
    }

    public func getTransparentCircleRadius(): Float64 {
        return this.mTransparentCircleRadiusPercent;
    }

    /**
     * Sets the amount of transparency the transparent circle should have 0 = fully transparent,
     * 255 = fully opaque.
     * Default value is 100.
     *
     * @param alpha 0-255
     */
    public func setTransparentCircleAlpha(alpha: Float64): Unit {
        if (this.mRenderer.isNone()) {
            return;
        }
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintTransparentCircle().setGlobalAlpha(alpha / 255.0);
    }

    /**
     * Set this to true to draw the entry labels into the pie slices (Provided by the getLabel() method of the PiEntry class).
     * Deprecated -> use setDrawEntryLabels(...) instead.
     *
     * @param enabled
     */
    // @Deprecated
    public func setDrawSliceText(enabled: Bool): Unit {
        this.mDrawEntryLabels = enabled
    }

    /**
     * Set this to true to draw the entry labels into the pie slices (Provided by the getLabel() method of the PiEntry class).
     *
     * @param enabled
     */
    public func setDrawEntryLabels(enabled: Bool): Unit {
        this.mDrawEntryLabels = enabled
    }

    /**
     * Returns true if drawing the entry labels is enabled, false if not.
     *
     * @return
     */
    public func isDrawEntryLabelsEnabled(): Bool {
        return this.mDrawEntryLabels;
    }

    /**
     * Sets the color the entry labels are drawn with.
     *
     * @param color
     */
    public func setEntryLabelColor(color: UInt32): Unit {
        ( /*(PieChartRenderer) */
            this.mRenderer as PieChartRenderer)().getPaintEntryLabels().setColor(Color(color));
    }

    /**
     * Sets a custom Typeface for the drawing of the entry labels.
     *
     * @param tf
     */
    public func setEntryLabelTypeface(tf: FontFamily): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintEntryLabels().setFontFamily(tf);
    }

    /**
     * Sets the size of the entry labels in vp. Default: 14vp
     *
     * @param size
     */
    public func setEntryLabelTextSize(size: Float64): Unit {
        ( /*(PieChartRenderer)*/
            this.mRenderer as PieChartRenderer)().getPaintEntryLabels().setTextSize(Utils.handleDataValues(size));
    }

    /**
     * Sets whether to draw slices in a curved fashion, only works if drawing the hole is enabled
     * and if the slices are not drawn under the hole.
     *
     * @param enabled draw curved ends of slices
     */
    public func setDrawRoundedSlices(enabled: Bool): Unit {
        this.mDrawRoundedSlices = enabled
    }

    /**
     * Returns true if the chart is set to draw each end of a pie-slice
     * "rounded".
     *
     * @return
     */
    public func isDrawRoundedSlicesEnabled(): Bool {
        return this.mDrawRoundedSlices;
    }

    /**
     * If this is enabled, values inside the PieChart are drawn in percent and
     * not with their original value. Values provided for the IValueFormatter to
     * format are then provided in percent.
     *
     * @param enabled
     */
    public func setUsePercentValues(enabled: Bool): Unit {
        this.mUsePercentValues = enabled
    }

    /**
     * Returns true if using percentage values is enabled for the chart.
     *
     * @return
     */
    public func isUsePercentValuesEnabled(): Bool {
        return this.mUsePercentValues;
    }

    /**
     * the rectangular radius of the bounding box for the center text, as a percentage of the pie
     * hole
     * default 1.f (100%)
     */
    public func setCenterTextRadiusPercent(percent: Float64): Unit {
        this.mCenterTextRadiusPercent = percent
    }

    /**
     * the rectangular radius of the bounding box for the center text, as a percentage of the pie
     * hole
     * default 1.f (100%)
     */
    public func getCenterTextRadiusPercent(): Float64 {
        return this.mCenterTextRadiusPercent;
    }

    public func getMaxAngle(): Float64 {
        return this.mMaxAngle;
    }

    /**
     * Sets the max angle that is used for calculating the pie-circle. 360f means
     * it's a full PieChart, 180f results in a half-pie-chart. Default: 360f
     *
     * @param maxangle min 90, max 360
     */
    public func setMaxAngle(maxangle: Float64): Unit {
        var m: Float64 = maxangle
        if (maxangle > 360.0) {
            m = 360.0
        }

        if (maxangle < 90.0) {
            m = 90.0
        }

        this.mMaxAngle = m
    }

    /**
     * The minimum angle slices on the chart are rendered with, default is 0f.
     *
     * @return minimum angle for slices
     */
    public func getMinAngleForSlices(): Float64 {
        return this.mMinAngleForSlices;
    }

    /**
     * Set the angle to set minimum size for slices, you must call {@link #notifyDataSetChanged()}
     * and {@link #invalidate()} when changing this, only works if there is enough room for all
     * slices to have the minimum angle.
     *
     * @param minAngle minimum 0, maximum is half of {@link #setMaxAngle(float)}
     */
    public func setMinAngleForSlices(minAngle: Float64): Unit {
        var m = minAngle
        if (minAngle > (this.mMaxAngle / 2.0)) {
            m = this.mMaxAngle / 2.0
        } else if (minAngle < 0.0) {
            m = 0.0
        }

        this.mMinAngleForSlices = m
    }

    protected func onDetachedFromWindow(): Unit {
        // releases the bitmap in the renderer to avoid oom error
        if (this.mRenderer.isSome() && this.mRenderer is PieChartRenderer) {
            (this.mRenderer as PieChartRenderer)().releaseBitmap();
        }
        // super.onDetachedFromWindow();
    }
}
