package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BubblePage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_bubblel_bar_page {

    private var title: String = "L1_bubblePage_chart_page2"
    private var model: BubbleChartModel = BubbleChartModel.build()
    var bubble1:BubblesEntry=BubblesEntry(5.0,5.0,size:1.0)
    private var ListBubblesEntry:ArrayList<BubblesEntry>=ArrayList<BubblesEntry>(bubble1)


    func DataSet(): BubbleData{
            var bubbledataSet:BubbleDataSet=BubbleDataSet(ListBubblesEntry,"气泡图￥")
            var listbubbledata:ArrayList<IBubbleDataSet>=ArrayList<IBubbleDataSet>([bubbledataSet])
            var bubbleData:BubbleData=BubbleData(listbubbledata)
            return bubbleData
    }



    func aboutToAppear(): BubbleChartModel {
            let data: BubbleData = DataSet()
            this.model.setData(data)
            return  this.model
        }




    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BubbleChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}





