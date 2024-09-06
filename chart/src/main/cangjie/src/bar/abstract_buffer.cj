/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bar

public abstract class AbstractBuffer<T> {
    /** index in the buffer */
    protected var index: Int64 = 0
    /** float-buffer that holds the data points to draw, order: x,y,x,y,... */
    public var buffer: ArrayList<Float64>
    /** animation phase x-axis */
    protected var phaseX: Float64 = 1.0
    /** animation phase y-axis */
    protected var phaseY: Float64 = 1.0
    /** indicates from which x-index the visible data begins */
    protected var mFrom: Int64 = 0
    /** indicates to which x-index the visible data ranges */
    protected var mTo: Int64 = 0

    /**
     * Initialization with buffer-size.
     *
     * @param size
     */
    public init(size: Int64) {
        this.index = 0
        this.buffer = ArrayList<Float64>()
    }

    /** limits the drawing on the x-axis */
    public func limitFrom(mfrom: Int64): Unit {
        var f = mfrom
        if (f < 0) {
            f = 0
        }

        this.mFrom = f
    }

    /** limits the drawing on the x-axis */
    public func limitTo(mto: Int64): Unit {
        var t = mto
        if (t < 0) {
            t = 0
        }

        this.mTo = t
    }

    /**
     * Resets the buffer index to 0 and makes the buffer reusable.
     */
    public func reset(): Unit {
        this.index = 0
    }

    /**
     * Returns the size (length) of the buffer array.
     *
     * @return
     */
    public func size(): Int64 {
        return this.buffer.size
    }

    /**
     * Set the phases used for animations.
     *
     * @param phaseX
     * @param phaseY
     */
    public func setPhases(phaseX: Float64, phaseY: Float64): Unit {
        this.phaseX = phaseX
        this.phaseY = phaseY
    }

    /**
     * Builds up the buffer with the provided data and resets the buffer-index
     * after feed-completion. This needs to run FAST.
     *
     * @param data
     */
    public func feed(data: T): Unit
}
