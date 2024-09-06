/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bar

public class CustomUiInfo {
    var width: Float64
    var height: Float64
    var showUi: Bool
    var x: Float64
    var y: Float64
    var offsetLeft: Float64
    var offsetRight: Float64
    var data: ?EntryOhos
    var isInbounds: Bool

    public init(
        width: Float64,
        height: Float64,
        showUi!: Bool = false,
        x!: Float64 = 0.0,
        y!: Float64 = 0.0,
        offsetLeft!: Float64 = 0.0,
        offsetRight!: Float64 = 0.0,
        data!: ?EntryOhos = Option<EntryOhos>.None,
        isInbounds!: Bool = false
    ) {
        this.x = x
        this.y = y
        this.offsetLeft = offsetLeft
        this.offsetRight = offsetRight
        this.data = data
        this.isInbounds = isInbounds
        this.width = width
        this.height = height
        this.showUi = showUi
    }
}
