/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.utils

public class FSize <: Poolable {
    public var width: Float64 = 0.0
    public var height: Float64 = 0.0

    public static var pool: ObjectPool<FSize> = ObjectPool(256, FSize(0.0, 0.0)).create()

    public func instantiate(): Poolable {
        return FSize(0.0, 0.0)
    }

    public static func getInstance(width: Float64, height: Float64): FSize {
        let result: FSize = FSize.pool.get()
        result.width = width
        result.height = height
        return result
    }

    public static func recycleInstance(instance: FSize) {
        FSize.pool.recycle(instance)
    }

    public static func recycleInstances(instances: ArrayList<FSize>) {
        FSize.pool.recycle(instances)
    }

    public init() {
        super()
    }

    public init(width: Float64, height: Float64) {
        this.width = width
        this.height = height
    }

    public func equals(obj: FSize): Bool {
        return this.width == obj.width && this.height == obj.height
    }

    public func toString(): String {
        return this.width.toString() + "x" + this.height.toString()
    }
}