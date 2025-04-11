/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.components

public class DashPathEffectConfig {
    var lineLength: Float64  = 0.0
    var spaceLength: Float64 = 0.0
    var phase: Float64 = 0.0
    public init(lineLength: Float64, spaceLength: Float64) {
        this.lineLength = lineLength
        this.spaceLength = spaceLength
        this.phase = 0.0
    }
    public func getLineLength(): Float64 {
        return this.lineLength
    }
    public func getSpaceLength(): Float64 {
        return this.spaceLength
    }
    public func getPhase(): Float64{
        return this.phase
    }
}
