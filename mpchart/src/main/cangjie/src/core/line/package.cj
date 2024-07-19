/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.line

import core.pie.*
import core.utils.*
import core.bar.*
from std import collection.*
from std import math.*
from ohos import component.*
from ohos import base.*
from ohos import device_info.*
from ohos import animator.*

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
