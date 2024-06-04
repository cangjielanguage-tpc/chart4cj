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
    init() {
        super()
    }

    init(sets: Array<S>) {
        super(sets)
    }

    init(sets: ArrayList<S>) {
        super(sets)
    }
}
