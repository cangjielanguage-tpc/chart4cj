package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_WaterfallPage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_waterfall_setDrawValueAboveBar_page {

    private var title: String = "L1_waterfallPage_chart_page"
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    var Waterfall:WaterfallEntry=WaterfallEntry(5.0,5.0,8.0)
    var Waterfall1:WaterfallEntry=WaterfallEntry(-5.0,-5.0,2.0)
    var Waterfall2:WaterfallEntry=WaterfallEntry(8.0,3.0,7.0)
    var Waterfall3:WaterfallEntry=WaterfallEntry(10.0,5.0,6.0)
    private var ListWaterfallEntry:ArrayList<WaterfallEntry>=ArrayList<WaterfallEntry>(Waterfall,Waterfall1,Waterfall)
    private var ListWaterfallTextColors:ArrayList<UInt32>=ArrayList<UInt32>(0x00CED1,0x00FF00,0xFFFF00)

//在指定的索引处向DataSet添加一个Entry。条目添加到列表的未尾。

    func DataSet(): WaterfallData{
            var waterfalldataSet:WaterfallDataSet=WaterfallDataSet(ListWaterfallEntry,"气泡图￥")
            var listwaterfalldata:ArrayList<IWaterfallDataSet>=ArrayList<IWaterfallDataSet>([waterfalldataSet])
            var waterfalldata:WaterfallData=WaterfallData(listwaterfalldata)
            return waterfalldata
    }



    func aboutToAppear(): WaterfallChartModel {
            let data: WaterfallData = DataSet()
            this.model.setDrawValueAboveBar(false)  //设置值是否在条形图的上方绘制
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





