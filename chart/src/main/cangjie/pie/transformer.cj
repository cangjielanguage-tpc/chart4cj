/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public open class Transformer {
    public var mMatrixValueToPx: Matrix = Matrix()
    /**
     * matrix for handling the different offsets of the chart
     */
    protected var mMatrixOffset: Matrix = Matrix()
    protected var mViewPortHandler: ViewPortHandler
    protected var resultPath: Path2D = Path2D()

    public init(viewPortHandler: ViewPortHandler) {
        this.mViewPortHandler = viewPortHandler
    }
    /**
     * Prepares the matrix that transforms values to pixels. Calculates the
     * scale factors from the charts size and offsets.
     *
     * @param xChartMin
     * @param deltaX
     * @param deltaY
     * @param yChartMin
     */
    public func prepareMatrixValuePx(xChartMin: Float64, deltaX: Float64, deltaY: Float64, yChartMin: Float64) {
        var scaleX: Float64 = this.mViewPortHandler.contentWidth() / deltaX
        var scaleY: Float64 = this.mViewPortHandler.contentHeight() / deltaY

        if (scaleX == Float64.Max) {
            scaleX = 0.0
        }
        if (scaleY == Float64.Max) {
            scaleY = 0.0
        }

        // setup all matrices
        this.mMatrixValueToPx.reset()
        this.mMatrixValueToPx.postTranslate(-xChartMin, -yChartMin)
        this.mMatrixValueToPx.postScale(scaleX, -scaleY)
    }

    /**
     * Prepares the matrix that contains all offsets.
     *
     * @param inverted
     */
    public open func prepareMatrixOffset(inverted: Bool) {
        this.mMatrixOffset.reset()

        if (!inverted) {
            this.mMatrixOffset.postTranslate(
                this.mViewPortHandler.offsetLeft(),
                this.mViewPortHandler.getChartHeight() - this.mViewPortHandler.offsetBottom()
            )
        } else {
            this.mMatrixOffset.setTranslate(this.mViewPortHandler.offsetLeft(), -this.mViewPortHandler.offsetTop())
            this.mMatrixOffset.postScale(1.0, -1.0)
        }
    }

    protected var valuePointsForGenerateTransformedValuesScatter: ArrayList<Float64> = ArrayList<Float64>(1)

     public func generateTransformedValuesScatter(data: IScatterDataSet, phaseX: Float64, phaseY: Float64, from: Int64, to: Int64): Array<Float64> {

         let count: Int64  = Int64(floor((Float64 (to - from) * phaseX + 1.0) * 2.0))

         if (this.valuePointsForGenerateTransformedValuesScatter.size != count) {
            this.valuePointsForGenerateTransformedValuesScatter = ArrayList<Float64>(count)
         }
         let valuePoints: ArrayList<Float64> = this.valuePointsForGenerateTransformedValuesScatter

         for (j in 0..count:2) {

            let e: ?EntryOhos = data.getEntryForIndex(j / 2 + from)

            if (let Some(e) <- e) {
                valuePoints.replaceOrAppend(j, e.getX())
                valuePoints.replaceOrAppend(j + 1, e.getY() * phaseY)
            } else {
                valuePoints.replaceOrAppend(j, 0.0)
                valuePoints.replaceOrAppend(j + 1, 0.0)
            }
         }

         var tmpArray = valuePoints.toArray()
         this.getValueToPixelMatrix().mapPoints(tmpArray);
         return tmpArray
     }

    public var mMBuffer1: Matrix = Matrix()
    public func getValueToPixelMatrix(): Matrix {
        mMBuffer1.set(mMatrixValueToPx)
        mMBuffer1.postConcat(mViewPortHandler.mMatrixTouch)
        mMBuffer1.postConcat(mMatrixOffset)
        return mMBuffer1
    }

    protected var valuePointsForGenerateTransformedValuesBubble: Array<Float64> = Array<Float64>(1, item: 0.0)

    /**
     * Transforms an List of Entry into a float array containing the x and
     * y values transformed with all matrices for the BUBBLECHART.
     *
     * @param data
     * @return
     */
    public func generateTransformedValuesBubble(data: IBubbleDataSet, phaseY: Float64, froms: Int64, tos: Int64): Array<Float64> {
        let count = (tos - froms + 1) * 2

        if (this.valuePointsForGenerateTransformedValuesBubble.size != count) {
            this.valuePointsForGenerateTransformedValuesBubble = Array<Float64>(count, item: 0.0)
        }
        let valuePoints: Array<Float64> = this.valuePointsForGenerateTransformedValuesBubble

        for (j in 0..count : 2) {
            let e: ?BubblesEntry = data.getEntryForIndex(j / 2 + froms)

            match (e) {
                case Some(entryOhos) =>
                    valuePoints[j] = entryOhos.getX()
                    valuePoints[j + 1] = entryOhos.getY() * phaseY
                case None =>
                    valuePoints[j] = 0.0
                    valuePoints[j + 1] = 0.0
            }
        }

        this.getValueToPixelMatrix().mapPoints(valuePoints)

        return valuePoints
    }

    protected var valuePointsForGenerateTransformedValuesLine: ArrayList<Float64> = ArrayList<Float64>(1)

    /**
     * Transforms an List of Entry into a float array containing the x and
     * y values transformed with all matrices for the LINECHART.
     *
     * @param data
     * @return
     */
    public func generateTransformedValuesLine(data: ILineDataSet, phaseX: Float64, phaseY: Float64, min: Int64,
        max: Int64): Array<Float64> {
        let count: Int64 = Int64(floor(((Float64(max - min) * phaseX) + 1.0) * 2.0))
        if (this.valuePointsForGenerateTransformedValuesLine.size != count) {
            this.valuePointsForGenerateTransformedValuesLine = ArrayList<Float64>(count)
        }
        let valuePoints: ArrayList<Float64> = this.valuePointsForGenerateTransformedValuesLine

        for (j in 0..count : 2) {
            let e: ?EntryOhos = data.getEntryForIndex(j / 2 + min)
            match (e) {
                case Some(entryOhos) =>
                    valuePoints.replaceOrAppend(j, entryOhos.getX())
                    valuePoints.replaceOrAppend(j + 1, entryOhos.getY() * phaseY)

                case None =>
                    valuePoints.replaceOrAppend(j, 0.0)
                    valuePoints.replaceOrAppend(j + 1, 0.0)
            }
        }

        var tmpArray = valuePoints.toArray()
        this.getValueToPixelMatrix().mapPoints(tmpArray);
        return tmpArray
    }

    protected var valuePointsForGenerateTransformedValuesCandle: ArrayList<Float64> = ArrayList<Float64>(1)

    /**
     * Transforms an List of Entry into a float array containing the x and
     * y values transformed with all matrices for the CANDLESTICKCHART.
     *
     * @param data
     * @return
     */
    public func generateTransformedValuesCandle(data: ICandleDataSet, phaseX: Float64, phaseY: Float64,
        fromValue: Int64, toValue: Int64): Array<Float64> {
        let count: Int64 = Int64(floor((Float64(toValue - fromValue) * (phaseX) + 1.0) * 2.0))

        if (this.valuePointsForGenerateTransformedValuesCandle.size != count) {
            this.valuePointsForGenerateTransformedValuesCandle = ArrayList<Float64>(count)
        }
        let valuePoints: ArrayList<Float64> = this.valuePointsForGenerateTransformedValuesCandle

        for (j in 0..count : 2) {
            let e: ?CandleEntry = data.getEntryForIndex(j / 2 + fromValue)
            match (e) {
                case Some(entryOhos) =>
                    valuePoints.replaceOrAppend(j, entryOhos.getX())
                    valuePoints.replaceOrAppend(j + 1, entryOhos.getHigh() * phaseY)

                case None =>
                    valuePoints.replaceOrAppend(j, 0.0)
                    valuePoints.replaceOrAppend(j + 1, 0.0)
            }
        }

        var tmpArray = valuePoints.toArray()
        this.getValueToPixelMatrix().mapPoints(tmpArray);
        return tmpArray
    }

    /**
     * Transform an array of points with all matrices. VERY IMPORTANT: Keep
     * matrix order "value-touch-offset" when transforming.
     *
     * @param pts
     */
    public func pointValuesToPixel(pts: Array<Float64>) {
        this.mMatrixValueToPx.mapPoints(pts)
        this.mViewPortHandler.getMatrixTouch().mapPoints(pts)
        this.mMatrixOffset.mapPoints(pts)
    }

    /**
     * Transform a rectangle with all matrices.
     *
     * @param r
     */
    public func rectValueToPixel(r: ChartRect) {
        this.mMatrixValueToPx.mapRect(r)
        this.mViewPortHandler.getMatrixTouch().mapRect(r)
        this.mMatrixOffset.mapRect(r)
    }

    /**
     * Transform a rectangle with all matrices with potential animation phases.
     *
     * @param r
     * @param phaseY
     */
    public func rectToPixelPhase(r: ChartRect, phaseY: Float64) {

        // multiply the height of the rect with the phase
        r.top *= phaseY
        r.bottom *= phaseY

        this.mMatrixValueToPx.mapRect(r)
        this.mViewPortHandler.getMatrixTouch().mapRect(r)
        this.mMatrixOffset.mapRect(r)
    }

    public func rectToPixelPhaseHorizontal(r: ChartRect, phaseY: Float64) {

        // multiply the height of the rect with the phase
        r.left *= phaseY
        r.right *= phaseY

        this.mMatrixValueToPx.mapRect(r)
        this.mViewPortHandler.getMatrixTouch().mapRect(r)
        this.mMatrixOffset.mapRect(r)
    }

    /**
     * Transform a rectangle with all matrices with potential animation phases.
     *
     * @param r
     */
    public func rectValueToPixelHorizontal(r: ChartRect, phaseY: ?Float64) {
        if (phaseY.isSome()) {
            r.left *= phaseY()
            r.right *= phaseY()
        }
        this.mMatrixValueToPx.mapRect(r)
        this.mViewPortHandler.getMatrixTouch().mapRect(r)
        this.mMatrixOffset.mapRect(r)
    }

    /**
     * transforms multiple rects with all matrices
     *
     * @param rects
     */
    public func rectValuesToPixel(rects: Array<ChartRect>) {
        let m: Matrix = this.getValueToPixelMatrix()

        for (i in 0..rects.size) {
            m.mapRect(rects[i])
        }
    }

    protected var mPixelToValueMatrixBuffer: Matrix = Matrix()

    /**
     * Transforms the given array of touch positions (pixels) (x, y, x, y, ...)
     * into values on the chart.
     *
     * @param pixels
     */
    public func pixelsToValue(pixels: Array<Float64>) {
        let tmp: Matrix = this.mPixelToValueMatrixBuffer
        tmp.reset()

        // invert all matrixes to convert back to the original value
        this.mMatrixOffset.invert(tmp)
        tmp.mapPoints(pixels)

        this.mViewPortHandler.getMatrixTouch().invert(tmp)
        tmp.mapPoints(pixels)

        this.mMatrixValueToPx.invert(tmp)
        tmp.mapPoints(pixels)
    }

    /**
     * buffer for performance
     */
    var ptsBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    /**
     * Returns a recyclable MPPointD instance.
     * returns the x and y values in the chart at the given touch point
     * (encapsulated in a MPPointD). This method transforms pixel coordinates to
     * coordinates / values in the chart. This is the opposite method to
     * getPixelForValues(...).
     *
     * @param x
     * @param y
     * @return
     */
    public func getValuesByTouchPoint(x: Float64, y: Float64, outputPoint: ?MPPointD): MPPointD {
        let result: MPPointD = match (outputPoint) {
            case Some(out) => out
            case None => MPPointD.getInstance(0.0, 0.0)
        }

        this.ptsBuffer[0] = x
        this.ptsBuffer[1] = y

        this.pixelsToValue(this.ptsBuffer)

        result.x = this.ptsBuffer[0]
        result.y = this.ptsBuffer[1]

        return result
    }

    /**
     * Returns a recyclable MPPointD instance.
     * Returns the x and y coordinates (pixels) for a given x and y value in the chart.
     *
     * @param x
     * @param y
     * @return
     */
    public func getPixelForValues(x: Float64, y: Float64): MPPointD {
        this.ptsBuffer[0] = x
        this.ptsBuffer[1] = y

        this.pointValuesToPixel(this.ptsBuffer)

        let xPx: Float64 = this.ptsBuffer[0]
        let yPx: Float64 = this.ptsBuffer[1]

        return MPPointD.getInstance(xPx, yPx)
    }

    public func getValueMatrix(): Matrix {
        return this.mMatrixValueToPx
    }

    public func getOffsetMatrix(): Matrix {
        return this.mMatrixOffset
    }

    var mMBuffer2: Matrix = Matrix()

    public func getPixelToValueMatrix(): Matrix {
        getValueToPixelMatrix().invert(mMBuffer2)
        return mMBuffer2
    }
}
