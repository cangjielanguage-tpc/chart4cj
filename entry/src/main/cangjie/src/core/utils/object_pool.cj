/**
 * Created on 2024/4/16
 */
package core.utils

public class ObjectPool<T> where T <: Poolable {
    private static var ids: Int64 = 0

    private var poolId: Int64 = 0
    private var desiredCapacity: Int64 = 0
    private var objects: ?ArrayList<Any> = None
    private var objectsPointer: Int64 = 0
    private var modelObject: ?T = None
    private var replenishPercentage: Float64 = 0.0

    public func getPoolId(): Int64 {
        return poolId
    }

    public static func create(withCapacity: Int64, object: Poolable) {
        var result = ObjectPool<Poolable>(withCapacity, object)
        result.poolId = ids
        ids++

        return result
    }

    public init(withCapacity: Int64, object: T) {
        if (withCapacity <= 0) {
            throw IllegalArgumentException("Object Pool must be instantiated with a capacity greater than 0!")
        }
        this.desiredCapacity = withCapacity
        this.objectsPointer = 0
        this.modelObject = object
        this.replenishPercentage = 1.0
        this.refillPool(Option<Float64>.None)
    }

    public func setReplenishPercentage(percentage: Float64): Unit {
        var p: Float64 = percentage
        if (p > 1.0) {
            p = 1.0
        } else if (p < 0.0) {
            p = 0.0
        }
        this.replenishPercentage = p
    }

    public func getReplenishPercentage(): Float64 {
        return replenishPercentage
    }

    private func refillPool(percentage: ?Float64): Unit {
        var p = percentage
        if(percentage.isNone()) {
            p = this.replenishPercentage
        }
        var portionOfCapacity: Int64 = Int64(Float64(desiredCapacity) * p())

        if (portionOfCapacity < 1) {
            portionOfCapacity = 1
        } else if (portionOfCapacity > desiredCapacity) {
            portionOfCapacity = desiredCapacity
        }

        for (i in 0..portionOfCapacity) {
            if(this.objects.isSome() && this.modelObject.isSome()) {
                let poolableObj = this.modelObject().instantiate()
                if(poolableObj.isSome()) {
                    this.objects()[i] = poolableObj
                }
            }

        }
        objectsPointer = portionOfCapacity - 1
    }

    public func get(): T {
        if (this.objectsPointer == -1 && this.replenishPercentage > 0.0) {
            this.refillPool(Option<Float64>.None)
        }
        if (this.objects.isNone()) {
            this.objects = ArrayList<Any>(this.desiredCapacity);
        }
        var result: Option<T> = objects()[this.objectsPointer] as T
        result().currentOwnerId = Poolable.NO_OWNER
        this.objectsPointer--

        return result()
    }

    public func recycle(object: T): Unit {
        if (object.currentOwnerId != Poolable.NO_OWNER) {
            if (object.currentOwnerId == this.poolId) {
                throw IllegalArgumentException("The object passed is already stored in this pool!")
            } else {
                throw IllegalArgumentException(
                    "The object to recycle already belongs to poolId ${object.currentOwnerId} . Object cannot belong to two different pool instances simultaneously!"
                )
            }
        }

        this.objectsPointer++
        if (this.objectsPointer >= objects().size) {
            this.resizePool()
        }

        object.currentOwnerId = this.poolId
        objects()[this.objectsPointer] = object
    }

    public func recycle(objects: ArrayList<T>): Unit {
        while (objects.size + this.objectsPointer + 1 > this.desiredCapacity) {
            this.resizePool()
        }
        let objectsListSize: Int64 = objects.size

        // Not relying on recycle(T object) because this is more performant.
        for (i in 0..objectsListSize) {
            var object: T = objects[i]
            if (object.currentOwnerId != Poolable.NO_OWNER) {
                if (object.currentOwnerId == this.poolId) {
                    throw IllegalArgumentException("The object passed is already stored in this pool!")
                } else {
                    throw IllegalArgumentException(
                        "The object to recycle already belongs to poolId ${object.currentOwnerId}. Object cannot belong to two different pool instances simultaneously!"
                    )
                }
            }
            object.currentOwnerId = this.poolId
            this.objects()[this.objectsPointer + 1 + i] = object
        }
        this.objectsPointer += objectsListSize
    }

    private func resizePool(): Unit {
        let oldCapacity: Int64 = this.desiredCapacity
        this.desiredCapacity *= 2
        var temp: ArrayList<Any> = ArrayList<Any>()
        for (i in 0..oldCapacity) {
            temp[i] = this.objects()[i]
        }
        this.objects = temp
    }

    public func getPoolCapacity(): Int64 {
        return this.objects().size
    }

    public func getPoolCount(): Int64 {
        return this.objectsPointer + 1
    }
}
