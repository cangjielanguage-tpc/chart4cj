/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public abstract class Renderer {
    /**
     * the component that handles the drawing area of the chart and it's offsets
     */
    protected var mViewPortHandler: ?ViewPortHandler

    public init(viewPortHandler: ?ViewPortHandler) {
        this.mViewPortHandler = viewPortHandler
    }
}
