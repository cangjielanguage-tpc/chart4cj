/**
 * Created on 2024/5/24
 */
package core.pie

public interface IBubbleDataSet <: IBarLineScatterCandleBubbleDataSet<BubbleEntry> {

    /**
     * Sets the width of the circle that surrounds the bubble when highlighted,
     * in vp.
     *
     * @param width
     */
    public func setHighlightCircleWidth(width: Float64): Unit

    public func getMaxSize(): Float64

    public func isNormalizeSizeEnabled(): Bool

    /**
     * Returns the width of the highlight-circle that surrounds the bubble
     * @return
     */
    public func getHighlightCircleWidth(): Float64
}
