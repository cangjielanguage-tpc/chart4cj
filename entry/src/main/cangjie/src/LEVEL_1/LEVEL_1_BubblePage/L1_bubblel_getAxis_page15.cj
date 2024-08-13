package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BubblePage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_bubblel_getAxis_page15   {

    private var title: String = "L1_bubblePage_chart_page2"
    private var model: BubbleChartModel = BubbleChartModel.build()
    var bubbley1:BubblesEntry=BubblesEntry(5.0,5.0,size:1.0)
    var bubbley2:BubblesEntry=BubblesEntry(10.0,10.0,size:2.0)
    var bubbley3:BubblesEntry=BubblesEntry(15.0,15.0,size:3.0)
    var bubbley4:BubblesEntry=BubblesEntry(-10.0,15.0,size:3.0)
    private var ListBubblesEntry:ArrayList<BubblesEntry>=ArrayList<BubblesEntry>(bubbley1,bubbley2,bubbley3)
    var Colors:ArrayList<UInt32>=ArrayList<UInt32>(0xFFC0CB,0x0000FF,0x00FFFF)



    func DataSet(): BubbleData{
            var bubbledataSet:BubbleDataSet=BubbleDataSet(ListBubblesEntry,"气泡图￥")
            var listbubbledata:ArrayList<IBubbleDataSet>=ArrayList<IBubbleDataSet>([bubbledataSet])
            var bubbleData:BubbleData=BubbleData(listbubbledata)
            return bubbleData
    }

//x轴

    func aboutToAppear(): BubbleChartModel {
            let data: BubbleData = DataSet()
            var Xaxis=this.model.getXAxis().getOrThrow()
            let lmit=LimitLine(20.0)
            lmit.setLineWidth(5.0)
            lmit.setLineColor(0x98FB98)
            lmit.enableDashedLine(30, 2, 5)
            lmit.setLabelPosition(LimitLabelPosition.LEFT_BOTTOM)
            lmit.setLabel("气泡图")
            Xaxis.addLimitLine(lmit)             //添加限制线
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





