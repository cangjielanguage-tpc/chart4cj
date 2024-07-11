/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.utils

from std import collection.{ArrayList}
from std import format.{Formatter}
from std import sort.*
from std import math.*
from std import core.*
from std import convert.{Parsable}
from std import unicode.{UnicodeExtension}
from ohos import base.*
from ohos import component.*
from ohos import device_info.*
from ohos import image.*

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
