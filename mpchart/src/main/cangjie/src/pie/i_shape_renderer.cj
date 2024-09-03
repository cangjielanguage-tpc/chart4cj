/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public interface IShapeRenderer {
    /**
     * Renders the provided ScatterDataSet with a shape.
     *
     * @param c               Canvas object for drawing the shape
     * @param dataSet         The DataSet to be drawn
     * @param viewPortHandler Contains information about the current state of the view
     * @param posX            Position to draw the shape at
     * @param posY            Position to draw the shape at
     * @param renderPaint     ChartPaint object used for styling and drawing
     */
    func renderShape(context2d: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: ChartPaint): Unit
}
