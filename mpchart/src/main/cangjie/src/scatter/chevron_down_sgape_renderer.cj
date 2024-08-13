/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.scatter

public class ChevronDownShapeRenderer <: IShapeRenderer {
    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: Paint): Unit {
        let shapeHalf: Float64 = dataSet.getScatterShapeSize() / 2.0

        renderPaint.setStyle(Style.STROKE)
        renderPaint.setStrokeWidth(Utils.handleDataValues(1.0))
        Utils.resetContext2DStyle(c, renderPaint)
        c.beginPath()
        c.moveTo(posX, posY + (2.0 * shapeHalf))
        c.lineTo(posX + (2.0 * shapeHalf), posY)

        c.moveTo(posX, posY + (2.0 * shapeHalf))
        c.lineTo(posX - (2.0 * shapeHalf), posY)
        c.stroke()
        c.closePath()
    }
}
