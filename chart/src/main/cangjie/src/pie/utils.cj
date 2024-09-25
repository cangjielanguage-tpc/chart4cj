/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public abstract class Utils {
    private static var scaledDensity: Float64 = 3.3125
    private static let mMinimumFlingVelocity: Int64 = 50
    private static let mMaximumFlingVelocity: Int64 = 8000
    public static let DEG2RAD: Float64 = (Float64.PI / 180.0)
    public static let FDEG2RAD: Float64 = (Float64.PI / 180.0)
    public static let DOUBLE_EPSILON: Float64 = 4.9E-324
    public static let FLOAT_EPSILON: Float64 = 1.4E-45

    /**
     * initialize method, called inside the Chart.init() method.
     *
     * @param context
     */
    public init() {
    }

    public static func handleDataValues(dp: Float64): Float64 {
        return dp
    }

    public static func setScaledDensity(value: Float64) {
        Utils.scaledDensity = value
    }

    /**
     * calculates the approximate width of a text, depending on a demo text
     * avoid repeated calls (e.g. inside drawing methods)
     *
     * @param paint
     * @param demoText
     * @return
     */
    public static func calcTextWidth(paint: ChartPaint, demoText: String): Float64 {
        let context2: MeasureOptions = MeasureOptions(textContent: demoText,
            fontSize: px2fp(vp2px(paint.getTextSize().vp)()))
        let textSize: MeasureSize = Measure.MeasureTextSize(context2)
        return px2vp(textSize.width.px)().value
    }

    private static var mCalcTextHeightRect: ChartRect = ChartRect()

    /**
     * calculates the approximate height of a text, depending on a demo text
     * avoid repeated calls (e.g. inside drawing methods)
     *
     * @param paint
     * @param demoText
     * @return
     */
    public static func calcTextHeight(paint: ChartPaint, demoText: String): Float64 {
        let context2: MeasureOptions = MeasureOptions(textContent: demoText)
        let textSize: MeasureSize = Measure.MeasureTextSize(context2)
        return px2vp(textSize.height.px)().value
    }

    public static func calcTextHeight(c: CanvasRenderingContext2D, paint: ChartPaint, demoText: String): Float64 {
        Utils.resetContext2DStyle(c, paint)
        let textMetrics: TextMetrics = c.measureText(demoText)
        return textMetrics.height
    }

    public static func getLineHeight(paint: ChartPaint, c: ?CanvasRenderingContext2D): Float64 {
        var lineHeight: Float64 = 0.0
        if (let Some(canvas) <- c) {
            Utils.resetContext2DStyle(canvas, paint)
            let textMetrics: TextMetrics = canvas.measureText("Test")
            lineHeight = textMetrics.height
        } else {
            let context2: MeasureOptions = MeasureOptions(textContent: "Test",fontSize: px2fp(vp2px(paint.getTextSize().vp)()))
            let textSize: MeasureSize = Measure.MeasureTextSize(context2)
            lineHeight = px2vp(textSize.height.px)().value
        }
        return lineHeight
    }

    public static func getLineSpacing(paint: ChartPaint, c: ?CanvasRenderingContext2D): Float64 {
        var lineSpacing: Float64 = 0.0
        if (let Some(canvas) <- c) {
            Utils.resetContext2DStyle(canvas, paint)
            let textMetrics: TextMetrics = canvas.measureText("Test")
            lineSpacing = textMetrics.height * 0.3
        } else {
            let context2: MeasureOptions = MeasureOptions(textContent: "Test",
                fontSize: px2fp(vp2px(paint.getTextSize().vp)()))
            let textSize: MeasureSize = Measure.MeasureTextSize(context2)
            lineSpacing = px2vp(textSize.height.px)().value * 0.3
        }
        return lineSpacing
    }

    public static func calcTextSize(paint: ChartPaint, demoText: String): FSize {
        let context2: MeasureOptions = MeasureOptions(textContent: demoText,
            fontSize: px2fp(vp2px(paint.getTextSize().vp)()))
        let textSize: MeasureSize = Measure.MeasureTextSize(context2)
        let width: Float64 = px2vp(textSize.width.px)().value
        let height: Float64 = px2vp(textSize.height.px)().value
        let fsize: FSize = FSize(width, height)
        return fsize
    }

    private static var mDefaultValueFormatter: IValueFormatter = Utils.generateDefaultValueFormatter()

    private static func generateDefaultValueFormatter(): IValueFormatter {
        let formatter: DefaultValueFormatter = DefaultValueFormatter(1)
        return formatter
    }

    public static func getDefaultValueFormatter(): IValueFormatter {
        return Utils.mDefaultValueFormatter
    }

    /**
     * rounds the given Float64 to the next significant Float64
     *
     * @param Float64
     * @return
     */
    public static func roundToNextSignificant(number: Float64): Float64 {
        if (number == Float64.Max || number.isNaN() || number == 0.0 || number == Float64.Inf) {
            return 0.0
        }
        var ilog10: Float64
        if (number < 0.0) {
            ilog10 = -log10(number)
        } else {
            ilog10 = log10(number)
        }

        let d: Float64 = ceil(ilog10)
        let pw: Float64 = 1.0 - floor(d)
        let magnitude: Float64 = pow(10.0, pw)
        let shifted: Float64 = number * magnitude
        let shiftedStr: Array<String> = shifted.format(".1").split(".")
        var shiftedNum: Float64 = 0.0
        if(Int32.parse(shiftedStr[1]) >= 5 ) {
             shiftedNum = ceil(shifted)
        } else {
            shiftedNum = floor(shifted)
        }
        return shiftedNum / magnitude
    }

    /**
     * Returns the appropriate Float64 of decimals to be used for the provided
     * Float64.
     *
     * @param Float64
     * @return
     */
    public static func getDecimals(number: Float64): Float64 {
        let i: Float64 = Utils.roundToNextSignificant(number)

        if (i == Float64.Max || i == Float64.Inf || i == 0.0) {
            return 0.0
        }

        return floor(ceil(-log10(i)) + 2.0)
    }

    /**
     * Replacement for the Math.nextUp(...) method that is only available in
     * HONEYCOMB and higher. Dat's some seeeeek sheeet.
     *
     * @param d
     * @return
     */
    public static func nextUp(d: Float64): Float64 {
        var dd = d

        if (dd == Float64.Max) {
            return dd
        } else {
            dd += 0.0
            if (dd >= 0.0) {
                dd += 0.000000001
            } else {
                dd -= 0.000000001
            }
            return dd
        }
    }

    public static func getPosition(center: MPPointF, dist: Float64, angle: Float64, outputPoint: ?MPPointF): MPPointF {
        let p: MPPointF
        if (outputPoint.isNone()) {
            p = MPPointF.getInstance(0.0, 0.0)
        } else {
            p = outputPoint()
        }
        p.x = center.x + dist * cos((angle * Float64.PI / 180.0))
        p.y = center.y + dist * sin((angle * Float64.PI / 180.0))
        return p
    }

    public static func getMinimumFlingVelocity(): Int64 {
        return Utils.mMinimumFlingVelocity
    }

    /**
     * returns an angle between 0.f < 360.f (not less than zero, less than 360)
     */
    public static func getNormalizedAngle(angle: Float64): Float64 {
        var anglee: Float64 = angle
        while (anglee < 0.0) {
            anglee += 360.0
        }

        return anglee - floor(anglee / 360.0) * 360.0
    }

    private static var mDrawableBoundsCache: ChartRect = ChartRect()

    public static func drawImage(canvas: CanvasRenderingContext2D, drawable: ChartPixelMap, x: Float64, y: Float64): Unit {
        let pixelMap = drawable.getIcon()
        if (pixelMap.isSome()) {
            canvas.drawImage(pixelMap(), x, y)
        }
    }

    private static var mFontMetricsBuffer: TextMetrics = TextMetrics()

    public static func drawXAxisValue(c: CanvasRenderingContext2D, text: String, x: Float64, y: Float64,
        paint: ChartPaint, anchor: MPPointF, angleDegrees: Float64, labelPosition: XAxisLabelPosition): Unit {
        var xLabelPosition = labelPosition

        var drawOffsetX: Float64 = 0.0
        var drawOffsetY: Float64 = 0.0

        // 防止计算出来的宽度，高度等数据不准确
        Utils.resetContext2DStyle(c, paint)
        Utils.mFontMetricsBuffer = c.measureText(text)
        let lineHeight = Utils.mFontMetricsBuffer.height

        // To have a consistent point of reference, we always draw left-aligned
        let originalTextAlign: TextAlignStyle = paint.getTextAlign()
        let originalTextBaseLine: TextBaseline = paint.getTextBaseline()

        paint.setTextAlign(TextAlignStyle.Left)
        paint.setTextBaseline(TextBaseline.Top)
        Utils.resetContext2DStyle(c, paint)
        if (angleDegrees != 0.0) {

            // Move the text drawing rect in a way that it always rotates around its center
            drawOffsetX -= Utils.mFontMetricsBuffer.width * 0.5
            drawOffsetY -= lineHeight * 0.5

            var transX: Float64 = x
            var transY: Float64 = y

            // Move the "outer" rect relative to the anchor, assuming its centered
            if (anchor.x != 0.5 || anchor.y != 0.5) {
                let rotatedSize: FSize = Utils.getSizeOfRotatedRectangleByDegrees(
                    Utils.mFontMetricsBuffer.width,
                    lineHeight,
                    angleDegrees
                )
                transX -= rotatedSize.width * (anchor.x - 0.5)
                if (labelPosition.toString() == XAxisLabelPosition.RIGHT.toString()) {
                    transX += rotatedSize.width * 0.5
                } else if (labelPosition.toString() == XAxisLabelPosition.LEFT.toString()) {
                    transX -= rotatedSize.width * 0.5
                }
                transY -= rotatedSize.height * (anchor.y - 0.5)
                FSize.recycleInstance(rotatedSize)
            }
            c.save()
            c.translate(transX, transY)
            c.rotate(angleDegrees * Float64.PI / 180.0)

            match (paint.getStyle()) {
                case Style.STROKE =>
                    c.beginPath()
                    c.strokeText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
                case Style.FILL =>
                    c.beginPath()
                    c.fillText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
                case Style.FILL_AND_STROKE =>
                    c.beginPath()
                    c.fillText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
                case _ =>
                    c.beginPath()
                    c.fillText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
            }
            c.restore()
        } else {
            if (anchor.x != 0.0 || anchor.y != 0.0) {
                drawOffsetX -= Utils.mFontMetricsBuffer.width * anchor.x
                drawOffsetY -= lineHeight * anchor.y
            }

            drawOffsetX += x
            if (labelPosition.toString() == XAxisLabelPosition.RIGHT.toString()) {
                drawOffsetX += Utils.mFontMetricsBuffer.width * 0.5
            } else if (labelPosition.toString() == XAxisLabelPosition.LEFT.toString()) {
                drawOffsetX -= Utils.mFontMetricsBuffer.width * 0.5
            }
            drawOffsetY += y

            match (paint.getStyle()) {
                case Style.STROKE =>
                    c.beginPath()
                    c.strokeText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
                case Style.FILL_AND_STROKE =>
                    c.beginPath()
                    c.fillText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
                case Style.FILL =>
                    c.beginPath()
                    c.fillText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
                case _ =>
                    c.beginPath()
                    c.fillText(text, drawOffsetX, drawOffsetY)
                    c.closePath()
            }
        }
        paint.setTextAlign(originalTextAlign)
        paint.setTextBaseline(originalTextBaseLine)
    }

    public static func getSizeOfRotatedRectangleByDegrees(rectangleWidth: Float64, rectangleHeight: Float64,
        degrees: Float64): FSize {
        let radians: Float64 = degrees * Utils.FDEG2RAD
        return Utils.getSizeOfRotatedRectangleByRadians(rectangleWidth, rectangleHeight, radians)
    }

    public static func getSizeOfRotatedRectangleByRadians(rectangleWidth: Float64, rectangleHeight: Float64,
        radians: Float64): FSize {
        return FSize.getInstance(
            abs(rectangleWidth * cos(radians)) + abs(rectangleHeight * sin(radians)),
            abs(rectangleWidth * sin(radians)) + abs(rectangleHeight * cos(radians))
        )
    }

    public static func getSDKInt(): Int64 {
        return DeviceInfo.sdkApiVersion
    }

    public static func resetContext2DStyle(context2D: CanvasRenderingContext2D, paint: ChartPaint) {
        match (paint.getStyle()) {
            case Style.FILL =>
                let c: Color = paint.getFillStyle()
                context2D.fillStyle(paint.getFillStyle())
            case Style.STROKE => context2D.strokeStyle(paint.getStrokeStyle())
            case Style.FILL_AND_STROKE =>
                context2D.fillStyle(paint.getFillStyle())
                context2D.strokeStyle(paint.getStrokeStyle())
            case _ =>
                context2D.fillStyle(paint.getFillStyle())
                context2D.strokeStyle(paint.getStrokeStyle())
        }

        if (let Some(style2) <- paint.getFillStyle2()) {
            context2D.fillStyle(style2)
        }

        if (let Some(globalAlpha) <- paint.getGlobalAlpha()) {
            context2D.globalAlpha(globalAlpha)
        }
        context2D.lineWidth(paint.getStrokeWidth())
        context2D.textAlign(paint.getTextAlign())
        context2D.textBaseline(paint.getTextBaseline())
        context2D.font(size: Length(paint.getTextSize()))

        let dashEffect: ?DashPathEffect = paint.getDashPathEffect()
        if (let Some(dashE) <- dashEffect) {
            context2D.lineDash(dashE.getDash())
            context2D.lineDashOffset(dashE.getOffset())
        }
    }

    public static func parseInt(num: Float64): Float64 {
        let stringNum = Int64(num)
        return Float64(stringNum)
    }

    public static func isHighLightEquals(highLight1: ?Highlight, highLight2: ?Highlight): Bool {
        if (highLight1.isNone() && highLight2.isNone()) {
            return true
        }

        return highLight1().getX() == highLight2().getX() && highLight1().getY() == highLight2().getY() &&
            highLight1().getStackIndex() == highLight2().getStackIndex()
    }

    public static func equalsIgnoreCase(label: String, anotherString: String) {
        if (label == anotherString) {
            return true
        }
        return label.toLower() == anotherString.toLower()
    }

    /**
     * 绘制顶部圆角矩形
     * @param c 画布对象
     * @param left 矩形左边界的x坐标
     * @param top 矩形上边界的y坐标
     * @param width 矩形的宽度
     * @param height 矩形的高度
     * @param radius 圆角的半径
     * @param cornerType 矩形圆角绘制位置类型，顶部/底部/都有
     */
    public static func fillRoundedRect(c: CanvasRenderingContext2D, left: Float64, top: Float64, width: Float64,
        height: Float64, radius: Float64, cornerType: RoundCornerType) {
        let min: Float64 = min(width, height)
        var newRadius: Float64 = radius
        if (newRadius > min / 2.0) {
            newRadius = min / 2.0
        }

        match (cornerType) {
            case RoundCornerType.DOWN =>
                c.moveTo(left, top)
                c.lineTo(left + width, top)
                c.arcTo(left + width, top + height, left, top + height, newRadius)
                c.lineTo(left + newRadius, top + height)
                c.arcTo(left, top + height, left, top, newRadius)
            case RoundCornerType.BOTH =>
                c.moveTo(left + newRadius, top)
                c.arcTo(left + width, top, left + width, top + height, newRadius)
                c.arcTo(left + width, top + height, left, top + height, newRadius)
                c.arcTo(left, top + height, left, top, newRadius)
                c.arcTo(left, top, left + newRadius, top, newRadius)
            case RoundCornerType.UP =>
                c.moveTo(left + newRadius, top)
                c.arcTo(left + width, top, left + width, top + height, newRadius)
                c.lineTo(left + width, top + height)
                c.lineTo(left, top + height)
                c.arcTo(left, top, left + width, top, newRadius)
            case _ =>
                c.moveTo(left + newRadius, top)
                c.arcTo(left + width, top, left + width, top + height, newRadius)
                c.lineTo(left + width, top + height)
                c.lineTo(left, top + height)
                c.arcTo(left, top, left + width, top, newRadius)
        }
    }

    public static func drawFillRect(isDrawRounded: Bool, c: CanvasRenderingContext2D, paint: ChartPaint, left: Float64,
        top: Float64, right: Float64, bottom: Float64, radius: Float64, cornerType: RoundCornerType) {
        Utils.drawRect(isDrawRounded, c, paint, left, top, right, bottom, radius, true, cornerType)
    }

    public static func drawStrokeRect(isDrawRounded: Bool, c: CanvasRenderingContext2D, paint: ChartPaint,
        left: Float64, top: Float64, right: Float64, bottom: Float64, radius: Float64, cornerType: RoundCornerType) {
        Utils.drawRect(isDrawRounded, c, paint, left, top, right, bottom, radius, false, cornerType)
    }

    private static func drawRect(isDrawRounded: Bool, c: CanvasRenderingContext2D, paint: ChartPaint, left: Float64,
        top: Float64, right: Float64, bottom: Float64, radius: Float64, isFill: Bool, cornerType: RoundCornerType): Unit {
        Utils.resetContext2DStyle(c, paint)
        c.beginPath()
        if (isDrawRounded && radius != 0.0) {
            Utils.fillRoundedRect(c, left, top, right - left, bottom - top, radius, cornerType)
        } else {
            c.rect(left, top, right - left, bottom - top)
        }
        if (isFill) {
            c.fill()
        } else {
            c.stroke()
        }
        c.closePath()
    }
}
