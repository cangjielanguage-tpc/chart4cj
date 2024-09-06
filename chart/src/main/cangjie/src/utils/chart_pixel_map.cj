/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package chart.utils

public class ChartPixelMap {
    private var icon: ?PixelMap = Option<PixelMap>.None
    private var height: Float64 = 0.0
    private var width: Float64 = 0.0

    public func setIcon(newIcon: PixelMap) {
        this.icon = newIcon
    }

    public func getIcon(): ?PixelMap {
        return this.icon
    }

    public func setWidth(width: Float64) {
        this.width = width
    }

    public func getWidth(): Float64 {
        return this.width
    }

    public func setHeight(height: Float64) {
        this.height = height
    }

    public func getHeight(): Float64 {
        return this.height
    }
}
