/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public interface IMarker {

    /**
     * @return The desired (general) offset you wish the IMarker to have on the x- and y-axis.
     *         By returning x: -(width / 2) you will center the IMarker horizontally.
     *         By returning y: -(height / 2) you will center the IMarker vertically.
     */
    func getOffset(): MPPointF

    /**
     * @return The offset for drawing at the specific `point`. This allows conditional adjusting of the Marker position.
     *         If you have no adjustments to make, return getOffset().
     *
     * @param posX This is the X position at which the marker wants to be drawn.
     *             You can adjust the offset conditionally based on this argument.
     * @param posY This is the X position at which the marker wants to be drawn.
     *             You can adjust the offset conditionally based on this argument.
     */
    func getOffsetForDrawingAtPoint(posX: Float64, posY: Float64): MPPointF

    /**
     * Draws the IMarker on the given position on the screen with the given Canvas object.
     *
     * @param canvas
     * @param posX
     * @param posY
     */
    func draw(c: CanvasRenderingContext2D, posX: Float64, posY: Float64, e: EntryOhos, highlight: Highlight): Unit
}
