/**
 * Created on 2024/5/24
 */
package core.bar

import core.utils.*
import core.pie.*
import core.components.*

from ohos import component.*
from ohos import base.*
from std import reflect.{TypeInfo}
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
