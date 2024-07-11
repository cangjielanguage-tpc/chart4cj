/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.components

public class GridLineConfig {
    var lineColor: UInt32 = 0
    var position: Float64 = 0.0
    var lineWidth: Float64 = 0.0
    var dashPathEffect: ?DashPathEffectConfig

    public init(position: Float64, lineColor: UInt32, lineWidth: Float64, dashPathEffect: ?DashPathEffectConfig) {
        this.lineColor = lineColor
        this.position = position
        this.lineWidth = lineWidth
        this.dashPathEffect = dashPathEffect
    }

    public func getPosition(): Float64 {
        this.position
    }
    public func getLineWidth(): Float64 {
        this.lineWidth
    }
    public func getLineColor(): UInt32 {
        this.lineColor
    }
    public func getDashPathEffect(): ?DashPathEffectConfig {
        this.dashPathEffect
    }
}
