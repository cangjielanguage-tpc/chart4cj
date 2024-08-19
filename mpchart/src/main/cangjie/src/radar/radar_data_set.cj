/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package mpchart.radar

public class RadarDataSet <: LineRadarDataSet<RadarEntry> & IRadarDataSet {
    /// flag indicating whether highlight circle should be drawn or not
    protected var mDrawHighlightCircleEnabled: Bool = false
    protected var mHighlightCircleFillColor: UInt32 = 0xffffff
    /// The stroke color for highlight circle.
    /// If Utils.COLOR_NONE, the color of the dataset is taken.
    protected var mHighlightCircleStrokeColor: UInt32 = ColorTemplate.COLOR_NONE
    protected var mHighlightCircleStrokeAlpha: Float64 = floor(0.3 * 255.0)
    protected var mHighlightCircleInnerRadius: Float64 = 3.0
    protected var mHighlightCircleOuterRadius: Float64 = 4.0
    protected var mHighlightCircleStrokeWidth: Float64 = 2.0

    public init(yVals: ArrayList<RadarEntry>, label: String) {
        super(yVals, label)
        this.calcMinMax()
    }

    /// Returns true if highlight circle should be drawn, false if not
    public func isDrawHighlightCircleEnabled(): Bool {
        return this.mDrawHighlightCircleEnabled
    }

    /// Sets whether highlight circle should be drawn or not
    public func setDrawHighlightCircleEnabled(enabled: Bool): Unit {
        this.mDrawHighlightCircleEnabled = enabled
    }

    public func getHighlightCircleFillColor(): UInt32 {
        return this.mHighlightCircleFillColor
    }

    /// Returns the stroke color for highlight circle.
    /// If Utils.COLOR_NONE, the color of the dataset is taken.
    public func getHighlightCircleStrokeColor(): UInt32 {
        return this.mHighlightCircleStrokeColor
    }

    public func getHighlightCircleStrokeAlpha(): Float64 {
        return this.mHighlightCircleStrokeAlpha
    }

    public func getHighlightCircleInnerRadius(): Float64 {
        return this.mHighlightCircleInnerRadius
    }

    public func getHighlightCircleOuterRadius(): Float64 {
        return this.mHighlightCircleOuterRadius
    }

    public func getHighlightCircleStrokeWidth(): Float64 {
        return this.mHighlightCircleStrokeWidth
    }

    public func copy(): DataSet<RadarEntry> {
        let entries: ArrayList<RadarEntry> = ArrayList<RadarEntry>()
        if (let Some(entry) <- this.mEntries) {
            for (i in 0..entry.size) {
                entries.append(entry[i].copy())
            }
        }
        let copied: RadarDataSet = RadarDataSet(entries, this.getLabel())
        this.copyTo(copied)
        return copied
    }

    protected func copyTo(radarDataSet: RadarDataSet): Unit {
        super.copyTo(radarDataSet)
        radarDataSet.mDrawHighlightCircleEnabled = this.mDrawHighlightCircleEnabled
        radarDataSet.mHighlightCircleFillColor = this.mHighlightCircleFillColor
        radarDataSet.mHighlightCircleInnerRadius = this.mHighlightCircleInnerRadius
        radarDataSet.mHighlightCircleStrokeAlpha = this.mHighlightCircleStrokeAlpha
        radarDataSet.mHighlightCircleStrokeColor = this.mHighlightCircleStrokeColor
        radarDataSet.mHighlightCircleStrokeWidth = this.mHighlightCircleStrokeWidth
    }

    public operator func ==(s: Any): Bool {
        return match (s) {
            case v: RadarDataSet => refEq(this, v)
            case _ => false
        }
    }

    public operator func !=(s: Any): Bool {
        return !(this == s)
    }
}
