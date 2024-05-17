from ohos import ability.Ability
from ohos import ability.Want
from ohos import ability.LaunchParam
from ohos import window.WindowStage

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}

func createAbilityStage(): MyAbilityStage {
    MyAbilityStage()
}

let ABILITY_STAGE_REGISTER_RESULT = AbilityStage.registerCreator("entry", createAbilityStage)
