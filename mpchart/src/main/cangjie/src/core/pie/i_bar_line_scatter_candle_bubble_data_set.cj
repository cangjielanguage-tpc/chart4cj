/**
 * Created on 2024/5/10
 */
package core.pie

public interface  IBarLineScatterCandleBubbleDataSet<E> <: IDataSet<E> where E <: EntryOhos {
    public func getHighLightColor(): UInt32
}
