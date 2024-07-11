/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

/**
 * Contains information needed to determine the highlighted value.
 */
public class Highlight {
    /**
     * the x-value of the highlighted value
     */
    private var mX: Float64 = Float64.NaN
    /**
     * the y-value of the highlighted value
     */
    private var mY: Float64 = Float64.NaN
    /**
     * the x-pixel of the highlight
     */
    private var mXPx: Float64 = 0.0
    /**
     * the y-pixel of the highlight
     */
    private var mYPx: Float64 = 0.0
    /**
     * the index of the data object - in case it refers to more than one
     */
    private var mDataIndex: Int64 = -1
    /**
     * the index of the dataset the highlighted value is in
     */
    private var mDataSetIndex: Int64 = 0
    /**
     * index which value of a stacked bar entry is highlighted, default -1
     */
    private var mStackIndex: Int64 = -1
    /**
     * the axis the highlighted value belongs to
     */
    private var axis: ?AxisDependency = None
    /**
     * the x-position (pixels) on which this highlight object was last drawn
     */
    private var mDrawX: Float64 = 0.0
    /**
     * the y-position (pixels) on which this highlight object was last drawn
     */
    private var mDrawY: Float64 = 0.0

    public init(x: Float64, y!: Float64 = Float64.NaN, dataSetIndex!: Int64 = 0, dataIndex!: Int64 = -1, stackIndex!: Int64 = 0, xPx!: Float64 = 0.0,
        yPx!: Float64 = 0.0, axis!: ?AxisDependency = Option<AxisDependency>.None) {
        this.mX = x
        this.mY = y
        this.mDataIndex = dataIndex
        this.mStackIndex = stackIndex
        this.mDataSetIndex = dataSetIndex
        this.mXPx = xPx
        this.mYPx = yPx
        this.axis = axis
    }


    /**
     * returns the x-value of the highlighted value
     *
     * @return
     */
    public func getX(): Float64 {
        return this.mX
    }

    /**
     * returns the y-value of the highlighted value
     *
     * @return
     */
    public func getY(): Float64 {
        return this.mY
    }

    /**
     * returns the x-position of the highlight in pixels
     */
    public func getXPx(): Float64 {
        return this.mXPx
    }

    /**
     * returns the y-position of the highlight in pixels
     */
    public func getYPx(): Float64 {
        return this.mYPx
    }

    /**
     * the index of the data object - in case it refers to more than one
     *
     * @return
     */
    public func getDataIndex(): Int64 {
        return this.mDataIndex
    }

    public func setDataIndex(mDataIndex: Int64): Unit {
        this.mDataIndex = mDataIndex
    }

    /**
     * returns the index of the DataSet the highlighted value is in
     *
     * @return
     */
    public func getDataSetIndex(): Int64 {
        return this.mDataSetIndex
    }

    /**
     * Only needed if a stacked-barchart entry was highlighted. References the
     * selected value within the stacked-entry.
     *
     * @return
     */
    public func getStackIndex(): Int64 {
        return this.mStackIndex
    }

    public func isStacked(): Bool {
        return this.mStackIndex >= 0
    }

    /**
     * Returns the axis the highlighted value belongs to.
     *
     * @return
     */
    public func getAxis(): ?AxisDependency {
        return this.axis
    }

    /**
     * Sets the x- and y-position (pixels) where this highlight was last drawn.
     *
     * @param x
     * @param y
     */
    public func setDraw(x: Float64, y: Float64): Unit {
        this.mDrawX = x
        this.mDrawY = y
    }

    /**
     * Returns the x-position in pixels where this highlight object was last drawn.
     *
     * @return
     */
    public func getDrawX(): Float64 {
        return this.mDrawX
    }

    /**
     * Returns the y-position in pixels where this highlight object was last drawn.
     *
     * @return
     */
    public func getDrawY(): Float64 {
        return this.mDrawY
    }

    /**
     * Returns true if this highlight object is equal to the other (compares
     * xIndex and dataSetIndex)
     *
     * @param h
     * @return
     */
    public func equalTo(h: Highlight): Bool {
        if (this.mDataSetIndex == h.mDataSetIndex && this.mX == h.mX
            && this.mStackIndex == h.mStackIndex && this.mDataIndex == h.mDataIndex) {
            return true
        } else {
            return false
        }
    }

    public func toString(): String {
        return "Highlight, x: ${this.mX}, y: ${this.mY}, dataSetIndex: ${this.mDataSetIndex}, stackIndex (only stacked barentry): ${this.mStackIndex}"
    }
}
