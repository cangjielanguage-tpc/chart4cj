/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

from ohos import ability.Ability
from ohos import ability.Want
from ohos import ability.LaunchParam
from ohos import window.WindowStage

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}
