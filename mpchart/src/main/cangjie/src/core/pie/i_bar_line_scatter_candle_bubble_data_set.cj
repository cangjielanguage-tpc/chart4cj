/**
 * Created on 2024/5/10
 */
package core.pie

public abstract class IBarLineScatterCandleBubbleDataSet<E> <: IDataSet<E> where E <: EntryOhos {
    public func getHighLightColor(): UInt32
}
