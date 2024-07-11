/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.components

import core.utils.*
import core.basedata.*
from std import collection.{ArrayList, EquatableCollection}
from std import format.{Formatter}
from std import math.*
from ohos import component.*
from ohos import base.*

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
