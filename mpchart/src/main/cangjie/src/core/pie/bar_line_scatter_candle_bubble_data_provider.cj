/**
 * Created on 2024/5/10
 */
package core.pie

public interface BarLineScatterCandleBubbleDataProvider<S, E> <: ChartInterface<S, E> where S <: IDataSet<E>,
    E <: EntryOhos {
    func getTransformer(axis: AxisDependency): ?Transformer

    func isInverted(axis: AxisDependency): Bool

    func getLowestVisibleX(): Float64

    func getHighestVisibleX(): Float64

    func getData(): ?ChartData<S, E> //BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,EntryOhos>
}
