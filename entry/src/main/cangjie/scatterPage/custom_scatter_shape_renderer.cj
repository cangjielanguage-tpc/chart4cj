/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scatterPage

import ohos.component.*

public class CustomScatterShapeRenderer <: IShapeRenderer {
    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: ChartPaint): Unit {
        let shapeHalf: Float64 = dataSet.getScatterShapeSize() / 2.0;

        renderPaint.setStyle(Style.STROKE);
        renderPaint.setStrokeWidth(Utils.handleDataValues(1.0));
        Utils.resetContext2DStyle(c, renderPaint);
        c.beginPath();
        c.moveTo(posX - shapeHalf, posY - shapeHalf);
        c.lineTo(posX + shapeHalf, posY + shapeHalf);
        c.stroke();
        c.closePath();
    }
}
