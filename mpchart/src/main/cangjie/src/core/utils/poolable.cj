/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.utils

public abstract class Poolable {
    public static let NO_OWNER: Int64 = -1
    public var currentOwnerId: Int64 = NO_OWNER

    public open func instantiate(): Poolable
}
