/**
 * Created on 2024/4/16
 */
package core.utils

public class MPPointD <: Poolable {
    private static var pool: ObjectPool<MPPointD> = (ObjectPool.create(64, MPPointD(0.0, 0.0)).setReplenishPercentage(0.5) as ObjectPool<MPPointD>)()

    public static func getInstance(x: Float64, y: Float64): MPPointD {
        var result: MPPointD = pool.get()
        result.x = x
        result.y = y
        return result
    }

    public static func recycleInstance(instance: MPPointD) {
        pool.recycle(instance)
    }

    public static func recycleInstances(instances: ArrayList<MPPointD>) {
        pool.recycle(instances)
    }

    public func instantiate(): Poolable {
        return MPPointD(0.0, 0.0)
    }

    public var x: Float64 = 0.0
    public var y: Float64 = 0.0

    private init(x: Float64, y: Float64) {
        super()
        this.x = x
        this.y = y
    }

    /**
     * returns a string representation of the object
     */
    public func toString(): String {
        return "MPPointD, x: ${this.x}, y: ${this.y}"
    }
}
