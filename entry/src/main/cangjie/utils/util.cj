/**
 * Created on 2025/7/17
 */
package ohos_app_cangjie_entry.utils
import chart.utils.ChartPixelMap

import kit.LocalizationKit.*
import kit.AbilityKit.*
import kit.ImageKit.*

public class Util {

  public static func getPixelMap(id: Int32, abilityContext: UIAbilityContext): ChartPixelMap{
    let stageContext = getStageContext(abilityContext)
    let resourceManager = ResourceManager.getResourceManager(stageContext)
    let charPixelMap: ChartPixelMap = ChartPixelMap();
    let fileData: Array<UInt8> = resourceManager.getMediaContent(id, 120)
    let imageSource = createImageSource(fileData) 
    let pixelMap= imageSource.createPixelMap()
    charPixelMap.setIcon(pixelMap)
    charPixelMap.setWidth(20.0)
    charPixelMap.setHeight(20.0)
    return charPixelMap
  }

}