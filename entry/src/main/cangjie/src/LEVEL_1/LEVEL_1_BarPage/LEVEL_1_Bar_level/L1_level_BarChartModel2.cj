package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_level
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
@Entry
@Component
class L1_level_BarChartModel2 {

    private var title: String = "L1_bar_chart_pag1e"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    var a:Any="第一注"
    var barntry:BarEntry=BarEntry(1980.0,100.0)
    var barntry1:BarEntry=BarEntry(1981.0,11.0)
    var barntry2:BarEntry=BarEntry(1982.0,64.0)

    var barntry3:BarEntry=BarEntry(1980.0,60.0)
    var barntry4:BarEntry=BarEntry(1981.0,130.0)
    var barntry5:BarEntry=BarEntry(1982.0,80.0)

    var barntry6:BarEntry=BarEntry(1980.0,80.0)
    var barntry7:BarEntry=BarEntry(1981.0,113.0)
    var barntry8:BarEntry=BarEntry(1982.0,41.0)

    var barntry9:BarEntry=BarEntry(1980.0,90.0)
    var barntry10:BarEntry=BarEntry(1981.0,50.0)
    var barntry11:BarEntry=BarEntry(1982.0,70.0)
    private var ListbareEntry:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry,barntry1,barntry2)
    private var ListbareEntry1:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry3,barntry4,barntry5)
    private var ListbareEntry2:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry6,barntry7,barntry8)
    private var ListbareEntry3:ArrayList<BarEntry>=ArrayList<BarEntry>(barntry9,barntry10,barntry11)

//设置是否突出显示某个条目（堆叠柱状图）

    func DataSet(): BarData{
            var barDataSet:BarDataSet=BarDataSet(ListbareEntry,"大or小")
            var barDataSet1:BarDataSet=BarDataSet(ListbareEntry1,"左or右")
            var barDataSet2:BarDataSet=BarDataSet(ListbareEntry2,"前or后")
            var barDataSet3:BarDataSet=BarDataSet(ListbareEntry2,"前or后")
            var arrybarDataSet:Array<IBarDataSet>=Array<IBarDataSet>([barDataSet,barDataSet1,barDataSet2,barDataSet3])
            var barData:BarData=BarData(arrybarDataSet)
            barData.setBarWidth(0.2);
            return barData
            }


    func aboutToAppear(): BarChartModel {

            var xAxis = this.model.getXAxis().getOrThrow();
            xAxis.setLabelCount(4,false);
            xAxis.setPosition(XAxisPosition.BOTTOM);
            xAxis.setDrawGridLinesBehindData(true)
            let data: BarData = DataSet()
            this.model.setData(data)
            return  this.model
              //this.model.invalidate();
    }



    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
