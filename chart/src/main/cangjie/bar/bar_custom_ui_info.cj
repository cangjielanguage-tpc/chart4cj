/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bar
import ohos.state_macro_manage.*
import ohos.state_manage.*

@Observed
public class BarCustomUiInfo {
    @Publish public var width: Float64 = 0.0
    @Publish public var height: Float64 = 0.0
    @Publish public var showUi: Bool = false
    @Publish public var x: Float64 = 0.0
    @Publish public var y: Float64 = 0.0
    @Publish public var offsetLeft: Float64 = 0.0
    @Publish public var offsetRight: Float64 = 0.0
    @Publish public var data: ?BarEntry = Option<BarEntry>.None
    @Publish public var isInbounds: Bool = false
}
