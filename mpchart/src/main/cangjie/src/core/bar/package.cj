/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bar

import core.utils.*
import core.pie.*
import core.components.*

from ohos import component.*
from ohos import base.*
from ohos import device_info.*
from ohos import animator.*

from std import collection.*
from std import math.*
from std import format.*
from std import time.*


extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
