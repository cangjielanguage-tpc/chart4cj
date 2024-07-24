/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.utils

public class MPPointF <: Poolable {
    private static var pool: ObjectPool<MPPointF> = ObjectPool(64, MPPointF(0.0, 0.0)).create()

    public var x: Float64 = 0.0
    public var y: Float64 = 0.0

    public init() {
    }

    public init(x: Float64, y: Float64) {
        this.x = x
        this.y = y
    }

    public static func getInstance(x: Float64, y: Float64): MPPointF {
        var result: MPPointF = pool.get()
        result.x = x
        result.y = y
        return result
    }

    public static func getInstance(): MPPointF {
        return pool.get()
    }

    public static func getInstance(copy: MPPointF): MPPointF {
        var result: MPPointF = pool.get()
        result.x = copy.x
        result.y = copy.y
        return result
    }
    public static func recycleInstance(instance: MPPointF) {
        pool.recycle(instance)
    }

    public static func recycleInstances(instances: ArrayList<MPPointF>) {
        pool.recycle(instances)
    }

    public func getX(): Float64 {
        return this.x
    }

    public func getY(): Float64 {
        return this.y
    }

    public func instantiate(): Poolable {
        return MPPointF(0.0, 0.0)
    }
}
