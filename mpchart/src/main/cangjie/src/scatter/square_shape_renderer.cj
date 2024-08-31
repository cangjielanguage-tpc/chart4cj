/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.scatter

public class SquareShapeRenderer <: IShapeRenderer {
    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: Paint): Unit {
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

            let left = posX - shapeHoleSizeHalf - shapeStrokeSizeHalf
            let top = posY - shapeHoleSizeHalf - shapeStrokeSizeHalf
            let right = posX + shapeHoleSizeHalf + shapeStrokeSizeHalf
            let bottom = posY + shapeHoleSizeHalf + shapeStrokeSizeHalf

            c.strokeRect(left, top, right - left, bottom - top)
            c.closePath()

            if (shapeHoleColor != ColorTemplate.COLOR_NONE) {
                renderPaint.setStyle(Style.FILL)

                renderPaint.setColor(Color(shapeHoleColor))

                Utils.resetContext2DStyle(c, renderPaint)
                c.beginPath()

                let left = posX - shapeHoleSizeHalf
                let top = posY - shapeHoleSizeHalf
                let right = posX + shapeHoleSizeHalf
                let bottom = posY + shapeHoleSizeHalf

                c.fillRect(left, top, right - left, bottom - top)
                c.closePath()
            }
        } else {
            renderPaint.setStyle(Style.FILL)

            Utils.resetContext2DStyle(c, renderPaint)
            c.beginPath()

            let left = posX - shapeHalf
            let top = posY - shapeHalf
            let right = posX + shapeHalf
            let bottom = posY + shapeHalf

            c.fillRect(left, top, right - left, bottom - top)
            c.closePath()
        }
    }
}
