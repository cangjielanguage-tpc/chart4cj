package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_WaterfallPage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_waterfall_setHighlights_page {

   private var title: String = "L1_waterfallPage_chart_page"
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    var Waterfall:WaterfallEntry=WaterfallEntry(5.0,5.0,10.0)
    let Highlight:WaterfallHighlight=WaterfallHighlight(8.0,9.0,color:0x7FFFAA)
    private var ListWaterfallHighlight:Array<WaterfallHighlight>=Array<WaterfallHighlight>([Highlight])

    var Waterfall1:WaterfallEntry=WaterfallEntry(-5.0,-5.0,10.0)
    var Waterfall2:WaterfallEntry=WaterfallEntry(8.0,3.0,7.0)



    func DataSet(): WaterfallData{
            Waterfall.setHighlights(ListWaterfallHighlight)
            var ListbubbleEntry:ArrayList<WaterfallEntry>=ArrayList<WaterfallEntry>(Waterfall,Waterfall1,Waterfall2)
            var waterfalldataSet:WaterfallDataSet=WaterfallDataSet(ListbubbleEntry,"瀑布图")
            waterfalldataSet.setDotsColors(0xFF6347)
            var listwaterfalldata:ArrayList<IWaterfallDataSet>=ArrayList<IWaterfallDataSet>([waterfalldataSet])
            var waterfalldata:WaterfallData=WaterfallData(listwaterfalldata)
            return waterfalldata
    }



    func aboutToAppear(): WaterfallChartModel {
            let data: WaterfallData = DataSet()
            this.model.setData(data)
            return  this.model
        }



    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            WaterfallChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}





