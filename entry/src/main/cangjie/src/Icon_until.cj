/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

public class IconUtilT {
    public static func loadMedia(resld: UInt32, context: Option<AbilityContext>): Array<UInt8> {
        if (let Some(v) <- context) {
            AppLog.info("getglobalAbilityContext successfully")
            AppLog.error("llllllllll")
            let stageContext = getStageContext(v)
            let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
            try {
                return rm.getMediaContent(resld, 120)
            } catch (e: Exception) {
                AppLog.error("getMediaConetext failed,err msg=" + e.message)
                return Array<UInt8>()
            }
        }
        AppLog.error("[loadMedia]:the getglobalAbilityContext is None.")
        return Array<UInt8>()
    }
}
