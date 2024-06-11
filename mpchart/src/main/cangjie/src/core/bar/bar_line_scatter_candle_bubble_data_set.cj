/**
 * Created on 2024/5/24
 */
package core.bar

public abstract class BarLineScatterCandleBubbleDataSet<E> <: DataSet<E> where E <: EntryOhos {
    /**
     * default highlight color
     */
    protected var mHighLightColor: UInt32 = 0xffbb73

    public init(yVals: ArrayList<E>, label: String) {
        super(yVals, label)
    }

    /**
     * Sets the color that is used for drawing the highlight indicators. Dont
     * forget to resolve the color using getResources().getColor(...) or
     * Color.rgb(...).
     *
     * @param color
     */
    public func setHighLightColor(color: UInt32): Unit {
        this.mHighLightColor = color
    }

    public func getHighLightColor(): UInt32 {
        return this.mHighLightColor
    }

    protected func copyTo(barLineScatterCandleBubbleDataSet: BarLineScatterCandleBubbleDataSet<E>): Unit {
        super.copyTo(barLineScatterCandleBubbleDataSet)
        barLineScatterCandleBubbleDataSet.mHighLightColor = this.mHighLightColor
    }
}
