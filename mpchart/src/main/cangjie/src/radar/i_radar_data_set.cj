/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.radar

public interface IRadarDataSet <: ILineRadarDataSet<RadarEntry> {
    /// flag indicating whether highlight circle should be drawn or not
    func isDrawHighlightCircleEnabled(): Bool

    /// Sets whether highlight circle should be drawn or not
    func setDrawHighlightCircleEnabled(enabled: Bool): Unit

    func getHighlightCircleFillColor(): UInt32

    /// The stroke color for highlight circle.
    /// If Utils.COLOR_NONE, the color of the dataset is taken.
    func getHighlightCircleStrokeColor(): UInt32

    func getHighlightCircleStrokeAlpha(): Float64

    func getHighlightCircleInnerRadius(): Float64

    func getHighlightCircleOuterRadius(): Float64

    func getHighlightCircleStrokeWidth(): Float64
}
