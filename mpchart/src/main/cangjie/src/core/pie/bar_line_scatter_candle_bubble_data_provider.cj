/**
 * Created on 2024/5/10
 */
package core.pie

public interface BarLineScatterCandleBubbleDataProvider<D, S, E> <: ChartInterface<D, S, E> where D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos {
    func getTransformer(axis: AxisDependency): ?Transformer

    func isInverted(axis: AxisDependency): Bool

    func getLowestVisibleX(): Float64

    func getHighestVisibleX(): Float64

    func getData(): ?D
}
