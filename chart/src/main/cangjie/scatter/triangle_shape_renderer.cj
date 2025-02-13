/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.scatter

public class TriangleShapeRenderer <: IShapeRenderer {
    protected var mTrianglePathBuffer: Path2D = Path2D()

    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: ChartPaint): Unit {
        let shapeSize: Float64 = dataSet.getScatterShapeSize()
        let shapeHalf: Float64 = shapeSize / 2.0
        let shapeHoleSizeHalf: Float64 = Utils.handleDataValues(dataSet.getScatterShapeHoleRadius())
        let shapeHoleSize: Float64 = shapeHoleSizeHalf * 2.0
        let shapeStrokeSize: Float64 = (shapeSize - shapeHoleSize) / 2.0

        let shapeHoleColor: UInt32 = dataSet.getScatterShapeHoleColor()

        renderPaint.setStyle(Style.FILL)

        // create a triangle path
        var tri: Path2D = this.mTrianglePathBuffer
        tri = Path2D()

        tri.moveTo(posX, posY - shapeHalf)
        tri.lineTo(posX + shapeHalf, posY + shapeHalf)
        tri.lineTo(posX - shapeHalf, posY + shapeHalf)

        if (shapeSize > 0.0) {
            tri.lineTo(posX, posY - shapeHalf)

            tri.moveTo(posX - shapeHalf + shapeStrokeSize, posY + shapeHalf - shapeStrokeSize)
            tri.lineTo(posX + shapeHalf - shapeStrokeSize, posY + shapeHalf - shapeStrokeSize)
            tri.lineTo(posX, posY - shapeHalf + shapeStrokeSize)
            tri.lineTo(posX - shapeHalf + shapeStrokeSize, posY + shapeHalf - shapeStrokeSize)
        }

        tri.closePath()
        Utils.resetContext2DStyle(c, renderPaint)
        c.beginPath()
        c.stroke(tri)
        c.closePath()
        if (shapeSize > 0.0 && shapeHoleColor != ColorTemplate.COLOR_NONE) {
            renderPaint.setColor(Color(shapeHoleColor))

            tri.moveTo(posX, posY - shapeHalf + shapeStrokeSize)
            tri.lineTo(posX + shapeHalf - shapeStrokeSize, posY + shapeHalf - shapeStrokeSize)
            tri.lineTo(posX - shapeHalf + shapeStrokeSize, posY + shapeHalf - shapeStrokeSize)
            tri.closePath()

            Utils.resetContext2DStyle(c, renderPaint)
            c.beginPath()
            c.stroke(tri)
            c.closePath()
        }
    }
}
