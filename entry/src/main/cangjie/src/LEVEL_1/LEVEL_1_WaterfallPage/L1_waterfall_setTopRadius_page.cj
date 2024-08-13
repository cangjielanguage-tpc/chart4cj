package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_WaterfallPage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_waterfall_setTopRadius_page {

    private var title: String = "L1_waterfallPage_chart_page"
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    var Waterfall:WaterfallEntry=WaterfallEntry(5.0,5.0,10.0)
    var Waterfall1:WaterfallEntry=WaterfallEntry(-5.0,-5.0,10.0)
    var Waterfall2:WaterfallEntry=WaterfallEntry(8.0,3.0,7.0)
    private var ListbubbleEntry:ArrayList<WaterfallEntry>=ArrayList<WaterfallEntry>(Waterfall,Waterfall1,Waterfall2)


    func DataSet(): WaterfallData{
            var waterfalldataSet:WaterfallDataSet=WaterfallDataSet(ListbubbleEntry,"瀑布图")
            var listwaterfalldata:ArrayList<IWaterfallDataSet>=ArrayList<IWaterfallDataSet>([waterfalldataSet])
            var waterfalldata:WaterfallData=WaterfallData(listwaterfalldata)
            waterfalldata.setTopRadius(70.0)   //设置顶部圆角半径
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





