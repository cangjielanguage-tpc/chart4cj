/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package core.charts
from ohos import base.*
from ohos import component.*
from ohos import state_manage.*
from ohos import state_macro_manage.*


from ohos import ability.Ability
from ohos import ability.Want
from ohos import ability.LaunchParam
from ohos import window.WindowStage

from ohos import ability.AbilityStage
from ohos import ability.LaunchReason
from ohos import prompt_action.*

from std import sync.*
from std import collection.*
from std import time.Duration
from std import math.*
from std import random.*
from std import convert.*
from mpchart import core.pie.*
from mpchart import core.utils.*
from mpchart import core.components.*
from mpchart import core.bar.*
from mpchart import core.bubble.*
from mpchart import core.waterfall.*
from mpchart import core.line.*


extend Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
