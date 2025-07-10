/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

public open class LineRadarRenderer <: LineScatterCandleRadarRenderer {
    public init(animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
    }

    protected func drawFilledPathWithAlpha(c: CanvasRenderingContext2D, filledPath: Path2D, fillColor: UInt32,
        fillAlpha: Float64) {
        var color: UInt32 = fillColor
        var alpha: Float64 = fillAlpha
        if (fillAlpha > 255.0) {
            alpha = 255.0
        }
        if (fillAlpha < 0.0) {
            alpha = 0.0
        }

        c.fillStyle(
            Color(
            UInt32(ChartColor.argb(fillAlpha / 255.0, Int64(color >> 16) & 0xff, Int64(color >> 8) & 0xff,
                Int64(color) & 0xff))))
        // 使用修改后的颜色值进行绘制,cangjie UI 暂不支持以下接口
        c.fill(filledPath)
    }

    /**
     * Draws the provided path in filled mode with the provided drawable.
     *
     * @param c
     * @param filledPath
     * @param drawable
     */
    protected func drawFilledPath(c: CanvasRenderingContext2D, filledPath: Path2D, drawable: ChartPixelMap) {
        if (this.clipPathSupported()) {
            c.save()
            //cangjie UI 暂不支持以下两个接口
            c.clip(filledPath)

            if (let Some(handle) <- this.mViewPortHandler) {
                c.rect(
                    handle.contentLeft(),
                    handle.contentTop(),
                    handle.contentRight() - handle.contentLeft(),
                    handle.contentBottom() - handle.contentTop()
                )
            }
            c.restore()
        } else {
            throw Exception(
                "Fill-drawables not (yet) supported below API level 18, " +
                "this code was run on API level ${Utils.getSDKInt()}.")
        }
    }

    /**
     * Clip path with hardware acceleration only working properly on API level 18 and above.
     *
     * @return
     */
    private func clipPathSupported(): Bool {
        return Utils.getSDKInt() >= 8
    }

    protected func drawGradientFill(c: CanvasRenderingContext2D, filledPath: Path2D,
        gradientColor: ArrayList<ChartColorStop>, topValue: Float64, bottomValue: Float64) {
        let gradient: CanvasGradient = c.createLinearGradient(0.0, topValue, 0.0, bottomValue)
        for (i in 0..gradientColor.size) {
            let colorStop: ?ChartColorStop = gradientColor.get(i)
            if (let Some(color) <- colorStop) {
                gradient.addColorStop(color[1], Color(color[0]))
            }
        }

        c.fillStyle(gradient)
        //cangjie UI 暂不支持以下接口
        c.fill(filledPath)
    }

    public open func drawData(c: CanvasRenderingContext2D): Unit {}
    public open func drawExtras(c: CanvasRenderingContext2D): Unit {}
    public open func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>): Unit {}
    public open func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool): Unit {}
    public open func initBuffers(): Unit {}
}
