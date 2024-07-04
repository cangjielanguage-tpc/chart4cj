/**
 * Created on 2024/6/26
 */
package core.waterfall

public interface IWaterfallDataSet <: IBarLineScatterCandleBubbleDataSet<WaterfallEntry> {

    public func getFills(): ?ArrayList<Fill>

    public func getFill(index: Int64): Fill

    public func isStacked(): Bool

    public func getStackSize(): Int64

    public func getBarShadowColor(): UInt32

    public func getBarBorderWidth(): Float64

    public func getBarBorderColor(): UInt32

    public func getHighLightAlpha(): Float64

    public func getStackLabels(): Array<String>
}

