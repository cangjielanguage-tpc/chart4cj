
/**
 * Created on 2024/4/10
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
