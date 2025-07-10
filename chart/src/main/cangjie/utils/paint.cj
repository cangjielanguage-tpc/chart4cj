/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.utils

public open class ChartPaint {
    public var styleType: Style = Style.FILL_AND_STROKE
    public var globalAlpha: ?Float64 = Option<Float64>.None
    var globalCompositeOperation: String = "source-over"

    var fillStyle: Color = Color.WHITE
    var fillStyle1: String = "#ffffff"
    var fillStyle2: ?CanvasGradient = Option<CanvasGradient>.None
    //var fillStyle3: CanvasPattern

    var strokeStyle: Color = Color.BLACK
    var strokeStyle1: String = "#000000"
    var strokeStyle2: CanvasGradient = CanvasRenderingContext2D(RenderingContextSettings(antialias: true)).createLinearGradient(0,0,0,0)
    // var strokeStyle3: CanvasPattern

    var filter: String = "none"
    var imageSmoothingEnabled: Bool = true
    var imageSmoothingQuality: QualityType = Low
    var lineCap: LineCapStyle = Butt
    var lineDashOffset: Float64 = 0.0
    var lineJoin: LineJoinStyle = Miter
    var lineWidth: Float64 = 1.0
    var miterLimit: Int64 = 10
    var shadowBlur: Float64 = 0.0
    var shadowColor: UInt32 = 0x00000000
    var shadowOffsetX: Float64 = 0.0
    var shadowOffsetY: Float64 = 0.0
    var direction: Direction = Direction.Auto
    var fontStyle: FontStyle = FontStyle.Normal
    var fontWeight: FontWeight  = FontWeight.Normal
    var fontSize: Float64 = 14.0
    var fontSizeUnit: FontSizeUnit = FontSizeUnit.VP
    var fontFamily: String  = "sans-serif"
    var font: (FontStyle, FontWeight, Length, String) = (FontStyle.Normal, FontWeight.Normal, 14.px, "sans-serif")
    var textAlign: TextAlignStyle = Left
    var textBaseline: TextBaseline = Alphabetic
    var lineDash: Array<Int64> = Array<Int64>()
    var dashPathEffect: ?DashPathEffect = Option<DashPathEffect>.None

    public init() {}

    public init(paint: ChartPaint) {
        this.styleType = paint.styleType
        this.globalAlpha = paint.globalAlpha
        this.globalCompositeOperation = paint.globalCompositeOperation

        this.fillStyle = paint.fillStyle
        this.fillStyle1 = paint.fillStyle1
        this.fillStyle2 = paint.fillStyle2
        //this.fillStyle3 = paint.fillStyle3

        this.strokeStyle = paint.strokeStyle
        this.strokeStyle1 = paint.strokeStyle1
        this.strokeStyle2 = paint.strokeStyle2
        // this.strokeStyle3 = paint.strokeStyle3

        this.filter = paint.filter
        this.imageSmoothingEnabled = paint.imageSmoothingEnabled
        this.imageSmoothingQuality = paint.imageSmoothingQuality
        this.lineCap = paint.lineCap
        this.lineDashOffset = paint.lineDashOffset
        this.lineJoin = paint.lineJoin
        this.lineWidth = paint.lineWidth
        this.miterLimit = paint.miterLimit
        this.shadowBlur = paint.shadowBlur
        this.shadowColor = paint.shadowColor
        this.shadowOffsetX = paint.shadowOffsetX
        this.shadowOffsetY = paint.shadowOffsetY
        this.direction = paint.direction
        this.fontStyle = paint.fontStyle
        this.fontWeight = paint.fontWeight
        this.fontSize = paint.fontSize
        this.fontSizeUnit = paint.fontSizeUnit
        this.fontFamily = paint.fontFamily
        this.font = paint.font
        this.textAlign = paint.textAlign
        this.textBaseline = paint.textBaseline
        this.lineDash = paint.lineDash
        this.dashPathEffect = paint.dashPathEffect
    }

    public func setColor(color: Color) {
        this.fillStyle = color
        this.strokeStyle = color
    }

    public func setColor(color: String) {
        this.fillStyle1 = color
        this.strokeStyle1 = color
    }

    public func setColor(color: CanvasGradient) {
        this.fillStyle2 = color
        this.strokeStyle2 = color
    }

    //    public func setColor(color: CanvasPattern) {
    //            this.fillStyle3 = color
    //            this.strokeStyle3 = color
    //    }

    public func getColor(): Color {
        return this.fillStyle
    }

    public func getColor1(): String {
        return this.fillStyle1
    }

    public func getColor2(): ?CanvasGradient {
        return this.fillStyle2
    }

    //    public func getColor3(): CanvasPattern {
    //            return this.fillStyle3
    //        }

    public func setStyle(styleType: Style) {
        this.styleType = styleType
    }

    public func getStyle(): Style {
        return this.styleType
    }

    public func setGlobalAlpha(alpha: Float64) {
        this.globalAlpha = alpha
    }

    public func getGlobalAlpha(): ?Float64 {
        return this.globalAlpha
    }

    public func setGlobalCompositeOperation(composite: String) {
        this.globalCompositeOperation = composite
    }

    public func getGlobalCompositeOperation(): String {
        return this.globalCompositeOperation
    }

    public func setFillStyle(fillStyle: Color) {
        this.fillStyle = fillStyle
    }

    public func setFillStyle(fillStyle: String) {
        this.fillStyle1 = fillStyle
    }

    public func setFillStyle(fillStyle: CanvasGradient) {
        this.fillStyle2 = fillStyle
    }

    //    public func setFillStyle(fillStyle: CanvasPattern) {
    //            this.fillStyle = fillStyle3
    //        }

    public func getFillStyle(): Color {
        return this.fillStyle
    }

    public func getFillStyle1(): String {
        return this.fillStyle1
    }

    public func getFillStyle2(): ?CanvasGradient {
        return this.fillStyle2
    }

    //    public func getFillStyle3(): CanvasPattern {
    //            return this.fillStyle3
    //        }

    public func setStrokeStyle(strokeStyle: Color) {
        this.strokeStyle = strokeStyle
    }
    public func setStrokeStyle(strokeStyle: String) {
        this.strokeStyle1 = strokeStyle
    }
    public func setStrokeStyle(strokeStyle: CanvasGradient) {
        this.strokeStyle2 = strokeStyle
    }
    //    public func setStrokeStyle(strokeStyle: CanvasPattern) {
    //            this.strokeStyle3 = strokeStyle
    //        }

    public func getStrokeStyle(): Color {
        return this.strokeStyle
    }
    public func getStrokeStyle1(): String {
        return this.strokeStyle1
    }
    public func getStrokeStyle2(): CanvasGradient {
        return this.strokeStyle2
    }
    //    public func getStrokeStyle3(): CanvasPattern {
    //            return this.strokeStyle3
    //        }

    public func setFilter(filterType: String) {
        this.filter = filterType
    }

    public func getFilter(): String {
        return this.filter
    }

    public func setImageSmoothingEnabled(enable: Bool) {
        this.imageSmoothingEnabled = enable
    }

    public func getImageSmoothingEnabled(): Bool {
        return this.imageSmoothingEnabled
    }

    public func setImageSmoothingQuality(quality: QualityType) {
        this.imageSmoothingQuality = quality
    }

    public func getImageSmoothingQuality(): QualityType {
        return this.imageSmoothingQuality
    }

    public func setLineCap(lineCap: LineCapStyle) {
        this.lineCap = lineCap
    }

    public func getLineCap(): LineCapStyle {
        return this.lineCap
    }

    public func setLineDashOffset(offset: Float64) {
        this.lineDashOffset = offset
    }

    public func getLineDashOffset(): Float64 {
        return this.lineDashOffset
    }

    public func setLineJoin(lineJoin: LineJoinStyle) {
        this.lineJoin = lineJoin
    }

    public func getLineJoin(): LineJoinStyle {
        return this.lineJoin
    }

    public func setStrokeWidth(lineWidth: Float64) {
        this.lineWidth = lineWidth
    }

    public func getStrokeWidth(): Float64 {
        return this.lineWidth
    }

    public func setMiterLimit(miterLimit: Int64) {
        this.miterLimit = miterLimit
    }

    public func getMiterLimit(): Int64 {
        return this.miterLimit
    }

    public func setShadowBlur(shadowBlur: Float64) {
        this.shadowBlur = shadowBlur
    }

    public func getShadowBlur(): Float64 {
        return this.shadowBlur
    }

    public func setShadowColor(shadowColor: UInt32) {
        this.shadowColor = shadowColor
    }

    public func getShadowColor(): UInt32 {
        return this.shadowColor
    }

    public func setShadowOffsetX(shadowOffsetX: Float64) {
        this.shadowOffsetX = shadowOffsetX
    }

    public func getShadowOffsetX(): Float64 {
        return this.shadowOffsetX
    }

    public func setShadowOffsetY(shadowOffsetY: Float64) {
        this.shadowOffsetY = shadowOffsetY
    }

    public func getShadowOffsetY(): Float64 {
        return this.shadowOffsetY
    }

    public func setDirection(direction: Direction) {
        this.direction = direction
    }

    public func getDirection(): Direction {
        return this.direction
    }

    public func setTextSize(textSize: Float64): Unit {
        this.fontSize = textSize
        this.font = (this.fontStyle, this.fontWeight, this.fontSize, this.fontFamily)
    }

    public func getTextSize(): Float64 {
        return this.fontSize
    }

    public func setFontStyle(fontStyle: FontStyle): Unit {
        this.fontStyle = fontStyle
        this.font = (this.fontStyle, this.fontWeight, this.fontSize, this.fontFamily)
    }

    public func getFontStyle(): FontStyle  {
        return this.fontStyle
    }

    public func setFontWeight(fontWeight: FontWeight ): Unit {
        this.fontWeight = fontWeight
        this.font = (this.fontStyle, this.fontWeight, this.fontSize, this.fontFamily)
    }

    public func getFontWeight(): FontWeight {
        return this.fontWeight
    }

    public func setFontFamily(fontFamily: String): Unit {
        this.fontFamily = fontFamily
        this.font = (this.fontStyle, this.fontWeight, this.fontSize, this.fontFamily)
    }

    public func getFontFamily(): String {
        return this.fontFamily
    }

    public func setFont(font: (FontStyle, FontWeight, Length, String)) {
        this.font = font
    }

    public func getFont(): (FontStyle, FontWeight, Length, String) {
        return this.font
    }

    public func setTextAlign(textAlign: TextAlignStyle) {
        this.textAlign = textAlign
    }

    public func getTextAlign(): TextAlignStyle {
        return this.textAlign
    }

    public func setTextBaseline(textBaseline: TextBaseline) {
        this.textBaseline = textBaseline
    }

    public func getTextBaseline(): TextBaseline {
        return this.textBaseline
    }

    public func setLineDash(lineDash: Array<Int64>) {
        this.lineDash = lineDash
    }

    public func getLineDash(): Array<Int64> {
        return this.lineDash
    }

    public func setDashPathEffect(dashEffect: ?DashPathEffect) {
        this.dashPathEffect = dashEffect
    }

    public func getDashPathEffect(): ?DashPathEffect {
        return this.dashPathEffect
    }
}

public class TextPaint <: ChartPaint {
    var text: String = ""

    public init() {
        super()
    }

    public init(paint: TextPaint) {
        super(paint)
        this.text = paint.text
    }

    var translateX: Float64 = 0.0
    var translateY: Float64 = 0.0
    var rotate: Float64 = 0.0

    func setText(value: String) {
        this.text = value
    }

    func getText(): String {
        return this.text
    }

    func setTranslateX(value: Float64) {
        this.translateX = value
    }

    func getTranslateX(): Float64 {
        return this.translateX
    }

    func setTranslateY(value: Float64) {
        this.translateY = value
    }

    func getTranslateY(): Float64 {
        return this.translateY
    }

    func setRotate(value: Float64) {
        this.rotate = value
    }

    func getRotate(): Float64 {
        return this.rotate
    }
}

public class DashPathEffect {
    var dash: Array<Int64>
    var offset: Int64

    public init(dash: Array<Int64>) {
        this.dash = dash
        this.offset = 0
    }

    public func setDash(dash: Array<Int64>) {
        this.dash = dash
    }

    public func getDash(): Array<Int64> {
        return this.dash
    }

    public func setOffset(offset: Int64) {
        this.offset = offset
    }

    public func getOffset(): Int64 {
        return this.offset
    }
}
