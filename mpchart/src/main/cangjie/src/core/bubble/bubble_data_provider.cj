/**
 * Created on 2024/5/24
 */
package core.bubble

public interface BubbleDataProvider <: BarLineScatterCandleBubbleDataProvider<BubbleData, IBubbleDataSet, BubbleEntry> {
    func getBubbleData(): ?BubbleData
}
