/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.scatter

public class CircleShapeRenderer <: IShapeRenderer {
    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: ChartPaint): Unit {
        let shapeSize: Float64 = dataSet.getScatterShapeSize()
        let shapeHalf: Float64 = shapeSize / 2.0
        let shapeHoleSizeHalf: Float64 = Utils.handleDataValues(dataSet.getScatterShapeHoleRadius())
        let shapeHoleSize: Float64 = shapeHoleSizeHalf * 2.0
        let shapeStrokeSize: Float64 = (shapeSize - shapeHoleSize) / 2.0
        let shapeStrokeSizeHalf: Float64 = shapeStrokeSize / 2.0

        let shapeHoleColor: UInt32 = dataSet.getScatterShapeHoleColor()

        if (shapeSize > 0.0) {
            renderPaint.setStyle(Style.STROKE)
            renderPaint.setStrokeWidth(shapeStrokeSize)

            Utils.resetContext2DStyle(c, renderPaint)
            c.beginPath()
            let path: Path2D = Path2D()
            path.arc(posX, posY, shapeHoleSizeHalf + shapeStrokeSizeHalf, 0.0, 2.0 * Float64.getPI())
            c.stroke(path)
            c.closePath()

            if (shapeHoleColor != ColorTemplate.COLOR_NONE) {
                renderPaint.setStyle(Style.FILL)

                renderPaint.setColor(Color(shapeHoleColor))

                Utils.resetContext2DStyle(c, renderPaint)
                c.beginPath()
                let path: Path2D = Path2D()
                path.arc(posX, posY, shapeHoleSizeHalf, 0.0, 2.0 * Float64.getPI())
                //TODO c.fill(path)
                c.stroke(path)
                c.closePath()
            }
        } else {
            renderPaint.setStyle(Style.FILL)

            Utils.resetContext2DStyle(c, renderPaint)
            c.beginPath()
            c.arc(posX, posY, shapeHalf, 0.0, 2.0 * Float64.getPI())
            c.stroke()
            c.closePath()
        }
    }
}
