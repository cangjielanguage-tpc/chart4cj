/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package mpchart.pie

public class Fill {
    /**
     * the type of fill
     */
    private var mType: FillType = FillType.EMPTY
    /**
     * the color that is used for filling
     */
    private var mColor: UInt32 = 0xffffff //UInt32.parse("0x" + hex.replace("#", ""))
    private var mFinalColor: UInt32 = 0x000000
    /**
     * the drawable to be used for filling
     */
    protected var mDrawable: ?ChartPixelMap = Option<ChartPixelMap>.None
    private var mGradientColors: ?Array<UInt32> = Option<Array<UInt32>>.None
    private var mGradientPositions: ?Array<Float64> = Option<Array<Float64>>.None
    /**
     * transparency used for filling
     */
    private var mAlpha: Float64 = 255.0

    init() {}

    public init(color: UInt32, endColor: UInt32) {
        this.mType = FillType.LINEAR_GRADIENT
        this.mGradientColors = [color, endColor]
    }

    public init(color: Array<UInt32>, endColor: Array<Float64>) {
        this.mType = FillType.LINEAR_GRADIENT
        this.mGradientColors = color
        this.mGradientPositions = endColor
    }

    public init(color: ChartPixelMap) {
        this.mType = FillType.DRAWABLE
        this.mDrawable = color
    }

    public init(color: Array<UInt32>) {
        this.mType = FillType.LINEAR_GRADIENT
        this.mGradientColors = color
    }

    public init(color: UInt32) {
        this.mType = FillType.COLOR
        this.mColor = color
        this.calculateFinalColor()
    }

    public func getType(): FillType {
        return this.mType
    }

    public func setType(types: FillType): Unit {
        this.mType = types
    }

    public func getColor(): UInt32 {
        return this.mColor
    }

    public func setColor(color: UInt32): Unit {
        this.mColor = color
        this.calculateFinalColor()
    }

    public func getGradientColors(): ?Array<UInt32> {
        return this.mGradientColors
    }

    public func getGradientPositions(): ?Array<Float64> {
        return this.mGradientPositions
    }

    public func setGradientPositions(positions: Array<Float64>): Unit {
        this.mGradientPositions = positions
    }

    public func setGradientColors(color: Array<UInt32>): Unit {
        this.mGradientColors = color
    }

    public func setGradientColors(color: UInt32, endColor: UInt32): Unit {
        this.mGradientColors = [color, endColor]
    }

    public func getAlpha(): Float64 {
        return this.mAlpha
    }

    public func setAlpha(alpha: Float64): Unit {
        this.mAlpha = alpha
        this.calculateFinalColor()
    }

    private func calculateFinalColor(): Unit {
        if (this.mColor == 0) {
            this.mFinalColor = 0
        } else {
            let alpha: Int64 = Int64(floor((Float64(this.mColor >> 24) / 255.0) * (this.mAlpha / 255.0) * 255.0))
            this.mFinalColor = UInt32((alpha << 24) | Int64(this.mColor & 0xffffff))
        }
    }

    private func FillTypeIsLINEAR_GRADIENT(c: CanvasRenderingContext2D, gradientDirection: FillDirection, left: Float64,
        top: Float64, right: Float64, bottom: Float64): CanvasGradient {
        let x0: Float64 = if (gradientDirection == FillDirection.RIGHT) {
            floor(right)
        } else if (gradientDirection == FillDirection.LEFT) {
            floor(left)
        } else {
            floor(left)
        }

        let y0: Float64 = if (gradientDirection == FillDirection.UP) {
            floor(bottom)
        } else if (gradientDirection == FillDirection.DOWN) {
            floor(top)
        } else {
            floor(top)
        }

        let x1: Float64 = if (gradientDirection == FillDirection.RIGHT) {
            floor(left)
        } else if (gradientDirection == FillDirection.LEFT) {
            floor(right)
        } else {
            floor(left)
        }
        let y1: Float64 = if (gradientDirection == FillDirection.UP) {
            floor(top)
        } else if (gradientDirection == FillDirection.DOWN) {
            floor(bottom)
        } else {
            floor(top)
        }

        let gradient: CanvasGradient = c.createLinearGradient(x0, y0, x1, y1)
        return gradient
    }
    public func fillRect(c: CanvasRenderingContext2D, paint: Paint, left: Float64, top: Float64, right: Float64,
        bottom: Float64, gradientDirection: FillDirection, radius!: Float64 = 0.0,
        cornerType!: RoundCornerType = RoundCornerType.UP): Unit {
        match (this.mType) {
            case FillType.EMPTY => return
            case FillType.COLOR => if (this.isClipPathSupported()) {
                c.save()
                if (radius > 0.0) {
                    Utils.fillRoundedRect(c, left, top, right - left, bottom - top, radius, cornerType)
                } else {
                    c.rect(left, top, right - left, bottom - top)
                }
                c.clip()
                c.fillStyle(this.mFinalColor)
                c.fill()
                c.restore()
            } else {
                // save
                let previous: Style = paint.getStyle()
                let previousColor: Color = paint.getColor()

                // set
                paint.setStyle(Style.FILL)
                paint.setColor(Color(this.mFinalColor))
                Utils.resetContext2DStyle(c, paint)
                c.beginPath()
                if (radius > 0.0) {
                    Utils.fillRoundedRect(c, left, top, right - left, bottom - top, radius, cornerType)
                } else {
                    c.fillRect(left, top, right - left, bottom - top)
                }
                c.closePath()

                // restore
                paint.setColor(previousColor)
                paint.setStyle(previous)
            }

            case FillType.LINEAR_GRADIENT =>
                let gradient: CanvasGradient = FillTypeIsLINEAR_GRADIENT(c, gradientDirection, left, top, right, bottom)
                if (this.mGradientColors.isSome() && this.mGradientColors().size == 2) {
                    for (i in 0..this.mGradientColors().size) {
                        gradient.addColorStop(i, this.mGradientColors()[i])
                    }
                }

                paint.setFillStyle(gradient)
                Utils.resetContext2DStyle(c, paint)
                c.beginPath()
                if (radius > 0.0) {
                    Utils.fillRoundedRect(c, left, top, right - left, bottom - top, radius, cornerType)
                } else {
                    c.rect(left, top, right - left, bottom - top)
                }
                c.fill()
                c.closePath()

            case FillType.DRAWABLE => match (this.mDrawable().getIcon()) {
                case Some(i) => c.drawImage(i, left, top, right - left, bottom - top)
                case _ => return
            }
        }
    }
    /* public func fillPath(c: CanvasRenderingContext2D, /*path: Path2D, */paint: Paint, clipRect: ?MyRect): Unit {
        match (this.mType) {
            case FillType.EMPTY => return

            case FillType.COLOR => if (clipRect.isSome() && this.isClipPathSupported()) {
                c.save()
                c.beginPath()
                //c.fill(path)
                c.clip()
                c.fillStyle(this.mFinalColor)
                c.fill()
                c.closePath()
                c.restore()
            } else {
                // save
                let previous: Style = paint.getStyle()
                let previousColor = paint.getColor()

                // set
                paint.setStyle(Style.FILL)
                paint.setColor(this.mFinalColor)
                Utils.resetContext2DStyle(c, paint)
                c.beginPath()
               // c.fill(path)
                c.closePath()

                // // restore
                paint.setColor(previousColor)
                paint.setStyle(previous)
            }

            case FillType.LINEAR_GRADIENT =>
                if (this.mGradientColors.isNone()) {
                    return
                }
                let gradient = c.createLinearGradient(0, 0, c.width, c.height)
                if (this.mGradientColors && this.mGradientColors().size == 2) {
                    for (i in 0..this.mGradientColors().size) {
                        gradient.addColorStop(i, this.mGradientColors[i])
                    }
                }
                paint.setFillStyle(gradient)
                Utils.resetContext2DStyle(c, paint)
                c.beginPath()
                //c.fill(path)
                c.closePath()

            case FillType.DRAWABLE =>
                if (this.mDrawable.isNone()) {
                    return
                }

                this.ensureClipPathSupported()

                c.save()
                c.beginPath()
                //c.fill(path)
                c.clip()
                c.closePath()
                let leftBounds: Float64 = if (clipRect.isNone()) {
                    0.0
                } else {
                    clipRect().left
                }

                let topBounds: Float64 = if (clipRect.isNone()) {
                    0.0
                } else {
                    clipRect().top
                }

                let rightBounds: Float64 = if (clipRect.isNone()) {
                    c.width
                } else {
                    clipRect().right
                }
                let bottomBounds: Float64 = if (clipRect.isNone()) {
                    c.height
                } else {
                    clipRect().bottom
                }
                match (this.mDrawable().getIcon()) {
                    case Some(i) => c.drawImage(i, leftBounds, topBounds, rightBounds - leftBounds,
                        bottomBounds - topBounds)
                    case _ => ()
                }

                c.restore()
        }
    }*/
    private func isClipPathSupported(): Bool {
        return Utils.getSDKInt() >= 8
    }

    private func ensureClipPathSupported(): Unit {
        if (Utils.getSDKInt() < 8) {
            throw IllegalArgumentException(
                "Fill-drawables not (yet) supported below API level 18, " +
                "this code was run on API level ${Utils.getSDKInt()}.")
        }
    }
}
