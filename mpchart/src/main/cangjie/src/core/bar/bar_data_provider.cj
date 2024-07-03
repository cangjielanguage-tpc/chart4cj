/**
 * Created on 2024/5/28
 */
package core.bar

public interface BarDataProvider <: BarLineScatterCandleBubbleDataProvider<BarData, IBarDataSet, BarEntry> {
    func getBarData(): ?BarData

    func isDrawBarShadowEnabled(): Bool

    func isDrawValueAboveBarEnabled(): Bool

    func isHighlightFullBarEnabled(): Bool
}
