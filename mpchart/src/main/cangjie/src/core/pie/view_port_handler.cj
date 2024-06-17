/**
 * Created on 2024/4/17
 */
package core.pie

public open class ViewPortHandler {
    public var mMatrixTouch: Matrix = Matrix()
    /**
     * this rectangle defines the area in which graph values can be drawn
     */
    protected var mContentRect = MyRect()
    protected var mChartWidth: Float64 = 0.0
    protected var mChartHeight: Float64 = 0.0
    /**
     * minimum scale value on the y-axis
     */
    private var mMinScaleY: Float64 = 1.0
    /**
     * maximum scale value on the y-axis
     */
    private var mMaxScaleY: Float64 = Float64.Max
    /**
     * minimum scale value on the x-axis
     */
    private var mMinScaleX: Float64 = 1.0
    /**
     * maximum scale value on the x-axis
     */
    private var mMaxScaleX: Float64 = Float64.Max
    /**
     * contains the current scale factor of the x-axis
     */
    private var mScaleX: Float64 = 1.0
    /**
     * contains the current scale factor of the y-axis
     */
    private var mScaleY: Float64 = 1.0
    /**
     * current translation (drag distance) on the x-axis
     */
    private var mTransX: Float64 = 0.0
    /**
     * current translation (drag distance) on the y-axis
     */
    private var mTransY: Float64 = 0.0
    /**
     * offset that allows the chart to be dragged over its bounds on the x-axis
     */
    private var mTransOffsetX: Float64 = 0.0
    /**
     * offset that allows the chart to be dragged over its bounds on the x-axis
     */
    private var mTransOffsetY: Float64 = 0.0
    public init() {
    }
    /**
     * Sets the width and height of the chart.
     *
     * @param width
     * @param height
     */
    public func setChartDimens(width: Float64, height: Float64): Unit {
        let offsetLeft = this.offsetLeft()
        let offsetTop = this.offsetTop()
        let offsetRight = this.offsetRight()
        let offsetBottom = this.offsetBottom()

        this.mChartHeight = height
        this.mChartWidth = width

        this.restrainViewPort(offsetLeft, offsetTop, offsetRight, offsetBottom)
    }

    public func hasChartDimens(): Bool {
        if (this.mChartHeight > 0.0 && this.mChartWidth > 0.0) {
            return true
        } else {
            return false
        }
    }

    public func restrainViewPort(offsetLeft: Float64, offsetTop: Float64, offsetRight: Float64, offsetBottom: Float64) {
        this.mContentRect.set(offsetLeft, offsetTop, this.mChartWidth - offsetRight, this.mChartHeight - offsetBottom)
    }

    public func offsetLeft(): Float64 {
        return this.mContentRect.left
    }

    public func offsetRight(): Float64 {
        return this.mChartWidth - this.mContentRect.right
    }

    public func offsetTop(): Float64 {
        return this.mContentRect.top
    }

    public func offsetBottom(): Float64 {
        return this.mChartHeight - this.mContentRect.bottom
    }

    public func contentTop(): Float64 {
        return this.mContentRect.top
    }

    public func contentLeft(): Float64 {
        return this.mContentRect.left
    }

    public func contentRight(): Float64 {
        return this.mContentRect.right
    }

    public func contentBottom(): Float64 {
        return this.mContentRect.bottom
    }

    public func contentWidth(): Float64 {
        return this.mContentRect.width()
    }

    public func contentHeight(): Float64 {
        return this.mContentRect.height()
    }

    public func getContentRect(): MyRect {
        return this.mContentRect
    }

    public func getContentCenter(): MPPointF {
        return MPPointF.getInstance(this.mContentRect.centerX(), this.mContentRect.centerY())
    }

    public func getChartHeight(): Float64 {
        return this.mChartHeight
    }

    public func getChartWidth(): Float64 {
        return this.mChartWidth
    }

    /**
     * Returns the smallest extension of the content rect (width or height).
     *
     * @return
     */
    public func getSmallestContentExtension(): Float64 {
        return min(this.mContentRect.width(), this.mContentRect.height())
    }

    /**
     * ################ ################ ################ ################
     */
    /** CODE BELOW THIS RELATED TO SCALING AND GESTURES */

    /**
     * Zooms in by 1.4f, x and y are the coordinates (in pixels) of the zoom
     * center.
     *
     * @param x
     * @param y
     */
    public func zoomIn(x: Float64, y: Float64, outputMatrix: ?Matrix): Matrix {
        var save: Matrix = match (outputMatrix) {
            case Some(matrix) => matrix
            case None => Matrix()
        }
        save.reset()
        save.set(this.mMatrixTouch)
        save.postScale(1.4, 1.4, centerX: x, centerY: y)
        return save
    }

    public func zoomOut(x: Float64, y: Float64, outputMatrix: ?Matrix): ?Matrix {
        var outputMatrixx: Matrix = match (outputMatrix) {
            case Some(matrix) => matrix
            case None => Matrix()
        }
        outputMatrixx.reset()
        outputMatrixx.set(this.mMatrixTouch)
        outputMatrixx.postScale(0.7, 0.7, centerX: x, centerY: y)
        return outputMatrixx
    }

    /**
     * Zooms out to original size.
     * @param outputMatrix
     */
    public func resetZoom(outputMatrix: Matrix): Unit {
        outputMatrix.reset()
        outputMatrix.set(this.mMatrixTouch)
        outputMatrix.postScale(1.0, 1.0, centerX: 0.0, centerY: 0.0)
    }

    /**
     * Post-scales by the specified scale factors.
     *
     * @param scaleX
     * @param scaleY
     * @return
     */
    public func zoom(scaleX: Float64, scaleY: Float64, x: ?Float64, y: ?Float64, outputMatrix: ?Matrix): ?Matrix {
        var save: Matrix = match (outputMatrix) {
            case Some(matrix) => matrix
            case None => Matrix()
        }
        save.reset()
        save.set(this.mMatrixTouch)

        if (x.isSome() && y.isSome()) {
            save.postScale(scaleX, scaleY, centerX: x(), centerY: y())
        } else {
            save.postScale(scaleX, scaleY)
        }
        return save
    }

    /**
     * Sets the scale factor to the specified values.
     *
     * @param scaleX
     * @param scaleY
     * @return
     */
    public func setZoom(scaleX: Float64, scaleY: Float64, x: ?Float64, y: ?Float64): Matrix {
        let save: Matrix = Matrix()
        save.reset()
        save.set(this.mMatrixTouch)
        if (x.isSome() && y.isSome()) {
            save.setScale(scaleX, scaleY, centerX: x(), centerY: y())
        } else {
            save.setScale(scaleX, scaleY)
        }
        return save
    }

    protected var valsBufferForFitScreen: Array<Float64> = Array<Float64>(9, item: 0.0)

    /**
     * Resets all zooming and dragging and makes the chart fit exactly it's
     * bounds.  Output Matrix is available for those who wish to cache the object.
     */
    public func fitScreen(outputMatrix: ?Matrix): Matrix {
        var save: Matrix = match (outputMatrix) {
            case Some(matrix) => matrix
            case None => Matrix()
        }

        this.mMinScaleX = 1.0
        this.mMinScaleY = 1.0

        save.set(this.mMatrixTouch)

        let vals: Array<Float64> = save.getValues()
        // reset all translations and scaling
        vals[Matrix.MTRANS_X] = 0.0
        vals[Matrix.MTRANS_Y] = 0.0
        vals[Matrix.MSCALE_X] = 1.0
        vals[Matrix.MSCALE_Y] = 1.0

        save.setValues(vals)

        return save
    }

    /**
     * Post-translates to the specified points.  Less Performant.
     *
     * @param transformedPts
     * @return
     */
    public func translate(transformedPts: Array<Float64>, outputMatrix: ?Matrix): Matrix {
        var save: Matrix = match (outputMatrix) {
            case Some(matrix) => matrix
            case None => Matrix()
        }

        save.reset()
        save.set(this.mMatrixTouch)
        let x: Float64 = transformedPts[0] - this.offsetLeft()
        let y: Float64 = transformedPts[1] - this.offsetTop()
        save.postTranslate(-x, -y)
        return save
    }

    protected var mCenterViewPortMatrixBuffer: Matrix = Matrix()

    /**
     * Centers the viewport around the specified position (x-index and y-value)
     * in the chart. Centering the viewport outside the bounds of the chart is
     * not possible. Makes most sense in combination with the
     * setScaleMinima(...) method.
     *
     * @param transformedPts the position to center view viewport to
     * @param view
     * @return save
     */
    public func centerViewPort(transformedPts: Array<Float64>,
        view: ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>) {
        let save: Matrix = this.mCenterViewPortMatrixBuffer
        save.reset()
        save.set(this.mMatrixTouch)

        let x: Float64 = transformedPts[0] - this.offsetLeft()
        let y: Float64 = transformedPts[1] - this.offsetTop()

        save.postTranslate(-x, -y)

        this.refresh(save, view, true)
    }

    /**
     * buffer for storing the 9 matrix values of a 3x3 matrix
     */
    protected var matrixBuffer: Array<Float64> = Array<Float64>(9, item: 0.0)

    /**
     * call this method to refresh the graph with a given matrix
     *
     * @param newMatrix
     * @return
     */
    public func refresh(newMatrix: Matrix,
        chart: ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>, invalidate: Bool): Matrix {
        this.mMatrixTouch.set(newMatrix)

        // make sure scale and translation are within their bounds
        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)

        if (invalidate) {
            chart.invalidate()
        }

        newMatrix.set(this.mMatrixTouch)
        return newMatrix
    }

    /**
     * limits the maximum scale and X translation of the given matrix
     *
     * @param matrix
     */
    public func limitTransAndScale(matrix: Matrix, content: ?MyRect) {
        this.matrixBuffer = matrix.getValues()

        let curTransX: Float64 = this.matrixBuffer[Matrix.MTRANS_X]
        let curScaleX: Float64 = this.matrixBuffer[Matrix.MSCALE_X]

        let curTransY: Float64 = this.matrixBuffer[Matrix.MTRANS_Y]
        let curScaleY: Float64 = this.matrixBuffer[Matrix.MSCALE_Y]

        // min scale-x is 1f
        this.mScaleX = min(max(this.mMinScaleX, curScaleX), this.mMaxScaleX)

        // min scale-y is 1f
        this.mScaleY = min(max(this.mMinScaleY, curScaleY), this.mMaxScaleY)

        var width: Float64 = 0.0
        var height: Float64 = 0.0

        if (content.isSome()) {
            width = content().width()
            height = content().height()
        }

        let maxTransX: Float64 = -width * (this.mScaleX - 1.0)
        this.mTransX = min(max(curTransX, maxTransX - this.mTransOffsetX), this.mTransOffsetX)

        let maxTransY: Float64 = height * (this.mScaleY - 1.0)
        this.mTransY = max(min(curTransY, maxTransY + this.mTransOffsetY), -this.mTransOffsetY)

        this.matrixBuffer[Matrix.MTRANS_X] = this.mTransX
        this.matrixBuffer[Matrix.MSCALE_X] = this.mScaleX

        this.matrixBuffer[Matrix.MTRANS_Y] = this.mTransY
        this.matrixBuffer[Matrix.MSCALE_Y] = this.mScaleY

        matrix.setValues(this.matrixBuffer)
    }

    /**
     * Sets the minimum scale factor for the x-axis
     *
     * @param xScale
     */
    public func setMinimumScaleX(xScale: Float64) {
        var xScales: Float64 = xScale
        if (xScales < 1.0) {
            xScales = 1.0
        }
        this.mMinScaleX = xScales

        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)
    }

    /**
     * Sets the maximum scale factor for the x-axis
     *
     * @param xScale
     */
    public func setMaximumScaleX(xScale: Float64) {
        var xScales: Float64 = xScale
        if (xScales == 0.0) {
            xScales = Float64.Max
        }
        this.mMaxScaleX = xScales

        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)
    }

    /**
     * Sets the minimum and maximum scale factors for the x-axis
     *
     * @param minScaleX
     * @param maxScaleX
     */
    public func setMinMaxScaleX(minScaleX: Float64, maxScaleX: Float64) {
        var minScaleXs: Float64 = minScaleX
        var maxScaleXs: Float64 = maxScaleX
        if (minScaleXs < 1.0) {
            minScaleXs = 1.0
        }
        if (maxScaleXs == 0.0) {
            maxScaleXs = Float64.Max
        }

        this.mMinScaleX = minScaleXs
        this.mMaxScaleX = maxScaleXs

        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)
    }

    /**
     * Sets the minimum scale factor for the y-axis
     *
     * @param yScale
     */
    public func setMinimumScaleY(yScale: Float64) {
        var yScales: Float64 = yScale
        if (yScales < 1.0) {
            yScales = 1.0
        }
        this.mMinScaleY = yScales

        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)
    }

    /**
     * Sets the maximum scale factor for the y-axis
     *
     * @param yScale
     */
    public func setMaximumScaleY(yScale: Float64) {
        var yScales: Float64 = yScale
        if (yScales == 0.0) {
            yScales = Float64.Max
        }
        this.mMaxScaleY = yScales

        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)
    }

    public func setMinMaxScaleY(minScaleY: Float64, maxScaleY: Float64) {
        var minScaleYs: Float64 = minScaleY
        var maxScaleYs: Float64 = maxScaleY
        if (minScaleYs < 1.0) {
            minScaleYs = 1.0
        }
        if (maxScaleYs == 0.0) {
            maxScaleYs = Float64.Max
        }
        this.mMinScaleY = minScaleYs
        this.mMaxScaleY = maxScaleYs

        this.limitTransAndScale(this.mMatrixTouch, this.mContentRect)
    }

    /**
     * Returns the charts-touch matrix used for translation and scale on touch.
     *
     * @return
     */
    public func getMatrixTouch(): Matrix {
        return this.mMatrixTouch
    }

    /**
     * ################ ################ ################ ################
     */
    /**
     * BELOW METHODS FOR BOUNDS CHECK
     */
    public func isInBoundsX(x: Float64): Bool {
        return this.isInBoundsLeft(x) && this.isInBoundsRight(x)
    }

    public func isInBoundsY(y: Float64) {
        return this.isInBoundsTop(y) && this.isInBoundsBottom(y)
    }

    public func isInBounds(x: Float64, y: Float64): Bool {
        return this.isInBoundsX(x) && this.isInBoundsY(y)
    }

    public func isInBoundsLeft(x: Float64): Bool {
        return this.mContentRect.left <= x + 1.0
    }

    public func isInBoundsRight(x: Float64): Bool {
        let xx = x * 100.0 / 100.0
        return this.mContentRect.right >= xx - 1.0
    }

    public func isInBoundsTop(y: Float64): Bool {
        return this.mContentRect.top <= y
    }

    public func isInBoundsBottom(y: Float64): Bool {
        let yy = y * 100.0 / 100.0
        return this.mContentRect.bottom >= y
    }

    /**
     * returns the current x-scale factor
     */
    public func getScaleX(): Float64 {
        return this.mScaleX
    }

    /**
     * returns the current y-scale factor
     */
    public func getScaleY(): Float64 {
        return this.mScaleY
    }

    public func getMinScaleX(): Float64 {
        return this.mMinScaleX
    }

    public func getMaxScaleX(): Float64 {
        return this.mMaxScaleX
    }

    public func getMinScaleY(): Float64 {
        return this.mMinScaleY
    }

    public func getMaxScaleY(): Float64 {
        return this.mMaxScaleY
    }

    /**
     * Returns the translation (drag / pan) distance on the x-axis
     *
     * @return
     */
    public func getTransX(): Float64 {
        return this.mTransX
    }

    /**
     * Returns the translation (drag / pan) distance on the y-axis
     *
     * @return
     */
    public func getTransY(): Float64 {
        return this.mTransY
    }

    /**
     * if the chart is fully zoomed out, return true
     *
     * @return
     */
    public func isFullyZoomedOut(): Bool {
        return this.isFullyZoomedOutX() && this.isFullyZoomedOutY()
    }

    /**
     * Returns true if the chart is fully zoomed out on it's y-axis (vertical).
     *
     * @return
     */
    public func isFullyZoomedOutY(): Bool {
        return !(this.mScaleY > this.mMinScaleY || this.mMinScaleY > 1.0)
    }

    /**
     * Returns true if the chart is fully zoomed out on it's x-axis
     * (horizontal).
     *
     * @return
     */
    public func isFullyZoomedOutX(): Bool {
        return !(this.mScaleX > this.mMinScaleX || this.mMinScaleX > 1.0)
    }

    /**
     * Set an offset in vp that allows the user to drag the chart over it's
     * bounds on the x-axis.
     *
     * @param offset
     */
    public func setDragOffsetX(offset: Float64) {
        this.mTransOffsetX = Utils.handleDataValues(offset)
    }

    /**
     * Set an offset in vp that allows the user to drag the chart over it's
     * bounds on the y-axis.
     *
     * @param offset
     */
    public func setDragOffsetY(offset: Float64) {
        this.mTransOffsetY = Utils.handleDataValues(offset)
    }

    /**
     * Returns true if both drag offsets (x and y) are zero or smaller.
     *
     * @return
     */
    public func hasNoDragOffset(): Bool {
        return this.mTransOffsetX <= 0.0 && this.mTransOffsetY <= 0.0
    }

    /**
     * Returns true if the chart is not yet fully zoomed out on the x-axis
     *
     * @return
     */
    public func canZoomOutMoreX(): Bool {
        return this.mScaleX > this.mMinScaleX
    }

    /**
     * Returns true if the chart is not yet fully zoomed in on the x-axis
     *
     * @return
     */
    public func canZoomInMoreX(): Bool {
        return this.mScaleX < this.mMaxScaleX
    }

    /**
     * Returns true if the chart is not yet fully zoomed out on the y-axis
     *
     * @return
     */
    public func canZoomOutMoreY(): Bool {
        return this.mScaleY > this.mMinScaleY
    }

    /**
     * Returns true if the chart is not yet fully zoomed in on the y-axis
     *
     * @return
     */
    public func canZoomInMoreY(): Bool {
        return this.mScaleY < this.mMaxScaleY
    }
}
