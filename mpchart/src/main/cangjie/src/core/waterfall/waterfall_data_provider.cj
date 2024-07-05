/**
 * Created on 2024/5/28
 */
package core.waterfall

public interface WaterfallDataProvider <: BarLineScatterCandleBubbleDataProvider<WaterfallData,IWaterfallDataSet, WaterfallEntry> {
    func getWaterfallData(): ?WaterfallData
    func isDrawBarShadowEnabled(): Bool

    func isDrawValueAboveBarEnabled(): Bool

    func isHighlightFullBarEnabled(): Bool
}
