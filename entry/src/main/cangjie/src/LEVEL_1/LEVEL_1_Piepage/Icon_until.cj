package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_Piepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
public class IconUtilT {
    public static func loadMedia(resld:UInt32 ,context:Option<AbilityContext>):Array<UInt8>{
        if (let Some(v)<-context){
            AppLog.info("getglobalAbilityContext successfully")
            let stageContext=getStageContext(v)
            let rm:ResourceManager=ResourceManager.getResourceManager(stageContext)
            try {
            	return rm.getMediaContent(resld,0)
                }catch (e:Exception) {
                AppLog.error("getMediaConetext failed,err msg="+e.message)
                return Array<UInt8>()
                }
            }
        AppLog.error("[loadMedia]:the getglobalAbilityContext is None.")
        return Array<UInt8>()
        }
    }

