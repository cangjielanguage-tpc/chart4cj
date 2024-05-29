/**
 * Created on 2024/4/10
 */
package core.components

import core.utils.*
import core.basedata.*
from std import collection.{ArrayList, EquatableCollection}
from std import format.{Formatter}
from std import math.*
from std import reflect.{TypeInfo}
from ohos import component.*
from ohos import base.*

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
