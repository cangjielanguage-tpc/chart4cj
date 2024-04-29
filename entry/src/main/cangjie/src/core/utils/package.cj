
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

extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}