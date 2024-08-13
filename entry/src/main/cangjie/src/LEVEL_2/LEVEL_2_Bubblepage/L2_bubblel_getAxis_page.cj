package ohos_app_cangjie_entry.LEVEL_2.LEVEL_2_Bubblepage
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L2_bubblel_getAxis_page   {

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
            Xaxis.setDrawAxisLine(true)             //设置轴位置
            Xaxis.setPosition(XAxisPosition.BOTTOM_INSIDE)
            Xaxis.setCenterAxisLabels(true)             //设置绘制X轴标签的角度
            Xaxis.setAxisLineWidth(-3.0)              //设置轴线宽度
            Xaxis.setAxisLineColor(Color.BLUE)        //设置轴线颜色
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





