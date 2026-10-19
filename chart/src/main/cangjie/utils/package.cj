/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.utils

internal import std.collection.{ArrayList}
internal import std.convert.Formattable
internal import std.sort.*
internal import std.math.*
internal import std.convert.{Parsable}
//internal import std.unicode.{UnicodeExtension}
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.device_info.*
internal import ohos.image.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

public interface ArrayListInterface<T> {
	func replaceOrAppend(index: Int64, value: T) : Unit
}

extend<T> ArrayList<T> <: ArrayListInterface<T> {
    public func replaceOrAppend(index: Int64, value: T): Unit{
        if (index < this.size) {
            this.add(value, at: index)
        } else {
            this.add(value)
        }
    }
}

public class AngularVelocitySample {
    public var time: Int64 = 0
    public var angle: Float64 = 0.0

    public init(time: Int64, angle: Float64) {
        this.time = time
        this.angle = angle
    }
}
