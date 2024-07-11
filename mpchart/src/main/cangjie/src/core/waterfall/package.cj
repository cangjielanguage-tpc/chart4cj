/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.waterfall

import core.utils.*
import core.bar.*
import core.pie.*
from ohos import component.*
from ohos import base.*
from ohos import device_info.*
from ohos import animator.*

from std import collection.{ArrayList}
from std import math.*
from std import format.*
from std import sort.*

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
