/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

/**
 * Class representing the x-axis labels settings. Only use the setter methods to
 * modify it. Do not access public variables directly. Be aware that not all
 * features the XLabels class provides are suitable for the RadarChart.
 */
public class XAxis <: AxisBase {
    /**
     * width of the x-axis labels in pixels - this is automatically
     * calculated by the computeSize() methods in the renderers
     */
    public var mLabelWidth: Int64 = 1
    /**
     * height of the x-axis labels in pixels - this is automatically
     * calculated by the computeSize() methods in the renderers
     */
    public var mLabelHeight: Int64 = 1
    /**
     * width of the (rotated) x-axis labels in pixels - this is automatically
     * calculated by the computeSize() methods in the renderers
     */
    public var mLabelRotatedWidth: Int64 = 1
    /**
     * height of the (rotated) x-axis labels in pixels - this is automatically
     * calculated by the computeSize() methods in the renderers
     */
    public var mLabelRotatedHeight: Int64 = 1
    /**
     * This is the angle for drawing the X axis labels (in degrees)
     */
    protected var mLabelRotationAngle: Int64 = 0
    /**
     * if set to true, the chart will avoid that the first and last label entry
     * in the chart "clip" off the edge of the chart
     */
    private var mAvoidFirstLastClipping: Bool = false
    /**
     * the position of the x-labels relative to the chart
     */
    private var mPosition: XAxisPosition = XAxisPosition.TOP

    /**
     * 表示标签在 X 轴上的偏移量
     */
    protected var mLabelXOffset: Int64 = 0

    /**
     * 自定义x轴labels
     */
    private var customLabels: Array<Float64> = []

    /**
     * 使用自定义labels
     */
    private var mUseCustomLabels: Bool = false

    /**
     * 标签绘制位置
     */
    private var xAxisLabelPosition: XAxisLabelPosition = XAxisLabelPosition.CENTER

    public init() {
        super()
        this.mYOffset = Utils.handleDataValues(4.0)
    }

    /**
     * returns the position of the x-labels
     */
    public func getPosition(): XAxisPosition {
        return this.mPosition
    }

    /**
     * sets the position of the x-labels
     *
     * @param pos
     */
    public func setPosition(pos: XAxisPosition): Unit {
        this.mPosition = pos
    }

    /**
     * returns the angle for drawing the X axis labels (in degrees)
     */
    public func getLabelRotationAngle(): Int64 {
        return this.mLabelRotationAngle
    }

    /**
     * sets the angle for drawing the X axis labels (in degrees)
     *
     * @param angle the angle in degrees
     */
    public func setLabelRotationAngle(angle: Int64): Unit {
        this.mLabelRotationAngle = angle
    }

    /**
     * if set to true, the chart will avoid that the first and last label entry
     * in the chart "clip" off the edge of the chart or the screen
     *
     * @param enabled
     */
    public func setAvoidFirstLastClipping(enabled: Bool): Unit {
        this.mAvoidFirstLastClipping = enabled
    }

    /**
     * returns true if avoid-first-lastclipping is enabled, false if not
     *
     * @return
     */
    public func isAvoidFirstLastClippingEnabled(): Bool {
        return this.mAvoidFirstLastClipping
    }

    /**
     * 设置标签在 X 轴上的偏移量
     * @param xOffset - 偏移量
     */
    public func setLabelXOffset(xOffset: Int64): Unit {
        this.mLabelXOffset = xOffset
    }

    /**
     * 获取标签在 X 轴上的偏移量
     * @returns 偏移量
     */
    public func getLabelXOffset(): Int64 {
        return this.mLabelXOffset
    }

    /**
     * 设置标签绘制位置
     * @param position - 绘制位置，可以是 LabelPosition.Left, LabelPosition.Center, LabelPosition.Right
     */
    public func setXAxisLabelPosition(position: XAxisLabelPosition): Unit {
        this.xAxisLabelPosition = position
    }

    /**
     * 获取标签绘制位置
     * @returns 绘制位置
     */
    public func getXAxisLabelPosition(): XAxisLabelPosition {
        return this.xAxisLabelPosition
    }

    /**
     *  设置自定义Labels
     * @param numbers labels数组
     */
    public func setCustomLabels(numbers: Array<Float64>): Unit {
        this.customLabels = numbers
    }

    /**
     * 获取自定义Labels
     * @returns labels数组
     */
    public func getCustomLabels(): Array<Float64> {
        return this.customLabels
    }

    /**
     * 设置是否使用自定义Labels
     * @param flag 是否使用自定义Labels
     */
    public func setDrawCustomLabels(flag: Bool): Unit {
        this.mUseCustomLabels = flag
    }

    /**
     * 检查是否正在使用自定义Labels
     * @returns 当前是否使用自定义Labels的布尔值
     */
    public func isDrawCustomLabels(): Bool {
        return this.mUseCustomLabels
    }
}
