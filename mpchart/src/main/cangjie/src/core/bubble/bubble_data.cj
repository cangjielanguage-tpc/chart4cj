/**
 * Created on 2024/5/24
 */
package core.bubble

public class BubbleData <: BarLineScatterCandleBubbleData<IBubbleDataSet, BubbleEntry> {
    public init(sets: ArrayList<IBubbleDataSet>) {
        super(sets)
        this.notifyDataChanged()
    }

    /**
     * Sets the width of the circle that surrounds the bubble when highlighted
     * for all DataSet objects this data object contains, in vp.
     *
     * @param width
     */
    public func setHighlightCircleWidth(width: Float64): Unit {
        let dataSource = this.mDataSets

        for (sets in dataSource) {
            sets.setHighlightCircleWidth(width)
        }
    }
}
