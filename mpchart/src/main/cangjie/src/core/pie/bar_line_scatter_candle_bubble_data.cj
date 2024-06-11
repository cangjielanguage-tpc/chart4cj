/**
 * Created on 2024/5/10
 */
package core.pie

/**
 * Baseclass for all Line, Bar, Scatter, Candle and Bubble data.
 *
 */
public abstract class BarLineScatterCandleBubbleData<S, E> <: ChartData<S, E> where S <: IBarLineScatterCandleBubbleDataSet<E>,
    E <: EntryOhos {
    public init() {
        super()
    }

    public init(sets: Array<S>) {
        super(sets)
    }

    public init(sets: ArrayList<S>) {
        super(sets)
    }
}
