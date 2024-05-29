/**
 * Created on 2024/5/6
 */
package core.pie

import core.utils.*
import core.components.*
import core.basedata.*
from std import collection.{ArrayList, HashSet, EquatableCollection, HashMap}
from std import format.{Formatter}
from std import math.*
from ohos import component.*
from ohos import base.*
from std import reflect.{TypeInfo}
from ohos import device_info.*
from ohos import animator.*
from std import unicode.{UnicodeExtension}
from std import time.*
from ohos import image.*

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

public enum Event {
    | TouchEvent
    | GestureEvent
}
