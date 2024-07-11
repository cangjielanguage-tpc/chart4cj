/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bubble

import core.utils.*
import core.pie.*
import core.bar.*
from ohos import component.*
from ohos import base.*
//from std import reflect.{TypeInfo}
from ohos import device_info.*
from ohos import animator.*

from std import collection.{ArrayList}
from std import math.*
from std import format.*


extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
