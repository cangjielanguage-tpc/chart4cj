/**
 * Created on 2024/6/27
 */
package core.waterfall

public class WaterfallDataSet <: BarLineScatterCandleBubbleDataSet<WaterfallEntry> & IWaterfallDataSet {
    private var mStackSize: Int64 = 1

    private var mBarShadowColor: UInt32 = 0xd7d7d7
    private var mBarBorderWidth: Float64 = 0.0
    private var mBarBorderColor: UInt32 = 0x000000

    private var mHighLightAlpha: Float64 = 120.0

    private var mEntryCountStacks: Int64 = 0

    private var mStackLabels: Array<String> = Array<String>()
    protected var mFills: ?ArrayList<Fill> = None

    private var enableMaxOrMinHighlightColor: Bool = false;

    private var maxyHighlightColor: UInt32 = 0xFF0000;

    private var minyHighlightColor: UInt32 = 0xFF0000;
    private var yAxisSegmentationColors: Array<WaterfallHighlight> = [];
    private var maxTopHighlightEXIST: Bool = false;
    private var opacity: Float64 = 100.0;
    private var minBottomHighlightEXIST: Bool = false;

    public init(yVals: ArrayList<WaterfallEntry>, label: String) {
        super(yVals, label)
        this.mHighLightColor = 0x000000
        this.calcStackSize(yVals)
        this.calcEntryCountIncludingStacks(yVals)
    }
    private func calcStackSize(yVals: ArrayList<WaterfallEntry>): Unit {
        for (i in 0..yVals.size) {
            let vals: Array<Float64> = yVals[i].getYVals();

            if (vals.size > this.mStackSize) {
                this.mStackSize = vals.size
            }
        }
    }
    private func calcEntryCountIncludingStacks(yVals: ArrayList<WaterfallEntry>): Unit {
        this.mEntryCountStacks = 0

        for (i in 0..yVals.size) {
            let vals: Array<Float64> = yVals[i].getYVals()

            if (vals.size > 0) {
                this.mEntryCountStacks += vals.size
            } else {
                this.mEntryCountStacks++
            }
        }
    }

    public func setEnableMaxOrMinHighlightColor(value: Bool) {
        this.enableMaxOrMinHighlightColor = value
    }

    public func getEnableMaxOrMinHighlightColor(): Bool {
        return this.enableMaxOrMinHighlightColor;
    }

    public func setMaxyHighlightColor(value: UInt32) {
        this.maxyHighlightColor = value
    }

    public func getMaxyHighlightColor(): UInt32 {
        return this.maxyHighlightColor;
    }

    public func setMinyHighlightColor(value: UInt32) {
        this.minyHighlightColor = value
    }

    public func getMinyHighlightColor(): UInt32 {
        return this.minyHighlightColor;
    }

    public func setYAxisSegmentationColors(value: Array<WaterfallHighlight>) {
        this.yAxisSegmentationColors = value
    }

    public func getYAxisSegmentationColors(): Array<WaterfallHighlight> {
        return this.yAxisSegmentationColors;
    }

    /**
     * 设置所有高亮点的颜色。
     * @param color - 要设置的颜色，可以是数字或字符串。
     */
    public func setDotsColors(color: UInt32): Unit {
        if (let Some(m: ArrayList<WaterfallEntry>) <- this.mEntries) {
            for (value in m) {
                var h: Array<WaterfallHighlight> = value.getHighlights()
                for (highlight in h) {
                    highlight.setColor(color);
                }
            }
        }
    }

    /**
     * 获取所有高亮点的颜色。
     * @returns 包含所有高亮点颜色的数组，元素可以是字符串或数字。
     */
    public func getDotsColors(): Array<UInt32> {
        var colors: ArrayList<UInt32> = ArrayList<UInt32>();
        if (let Some(m: ArrayList<WaterfallEntry>) <- this.mEntries) {
            for (value in m) {
                let entry = value.getHighlights();
                for (highlight in entry) {
                    colors.append(highlight.getColor());
                }
            }
        }
        return colors.toArray();
    }

    public func setMaxTopHighlightEXIST(value: Bool) {
        this.maxTopHighlightEXIST = value
    }

    public func getMaxTopHighlightEXIST(): Bool {
        return this.maxTopHighlightEXIST;
    }

    public func setMinBottomHighlightEXIST(value: Bool) {
        this.minBottomHighlightEXIST = value
    }

    public func getMinBottomHighlightEXIST(): Bool {
        return this.minBottomHighlightEXIST;
    }

    public func setOpacity(value: Float64) {
        this.opacity = value
    }

    public func getOpacity(): String {
        return "opacity(${this.opacity}%)";
    }

    public func setMaxTopHighLightEXIST(value: Bool) {
        this.maxTopHighlightEXIST = value
    }

    public func myCalcMinMax(e: WaterfallEntry): Unit {
        if (e.getY().isNaN()) {
            if (e.getMinY() < this.mYMin) {
                this.mYMin = e.getMinY()
            }

            if (e.getMaxY() > this.mYMax) {
                this.mYMax = e.getMaxY()
            }

            this.calcMinMaxX(e);
        }
    }

    public func setBarBorderColor(color: UInt32): Unit {
        this.mBarBorderColor = color
    }

    public func getBarBorderColor(): UInt32 {
        return this.mBarBorderColor
    }

    public func setBarBorderWidth(width: Float64): Unit {
        this.mBarBorderWidth = width
    }

    public func getBarBorderWidth(): Float64 {
        return this.mBarBorderWidth
    }

    public func setHighLightAlpha(alpha: Float64): Unit {
        this.mHighLightAlpha = alpha
    }

    public func getHighLightAlpha(): Float64 {
        return this.mHighLightAlpha
    }

    public func setStackLabels(labels: Array<String>): Unit {
        this.mStackLabels = labels
    }

    public func getStackLabels(): Array<String> {
        return this.mStackLabels
    }

    public func setBarShadowColor(color: UInt32): Unit {
        this.mBarShadowColor = color
    }

    public func getBarShadowColor(): UInt32 {
        return this.mBarShadowColor
    }

    public func getStackSize(): Int64 {
        return this.mStackSize
    }

    public func isStacked(): Bool {
        return if (this.mStackSize > 1) {
            true
        } else {
            false
        }
    }

    public func copy(): DataSet<WaterfallEntry> {
        let entries = ArrayList<WaterfallEntry>()

        if (let Some(m) <- this.mEntries) {
            for (i in 0..m.size) {
                entries.append(m[i].copy())
            }
        }
        let copied = WaterfallDataSet(entries, this.getLabel())
        this.copyTo(copied)
        return copied
    }

    public func getFill(index: Int64): Fill {
        if (let Some(f) <- this.mFills) {
            return f[Int64(index % f.size)]
        }
        return Fill()
    }
    public func getFills(): ?ArrayList<Fill> {
        if (let Some(val) <- this.mFills) {
            return val
        } else {
            return None
        }
    }

    public operator func ==(s: Any): Bool {
        return match (s) {
            case v: BarDataSet => refEq(this, v)
            case _ => false
        }
    }

    public operator func !=(s: Any): Bool {
        return !(this == s)
    }
}
