/**
 * Created on 2024/9/7
 */
package ohos_app_cangjie_entry.scrollingCharts.listViewItems

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import chart.pie.*
import chart.utils.*
import chart.components.*
import chart.charts.*

@Component
public class PieChartItem {
    var data: PieData = PieData()
    @State
    var pieModel: PieChartModel = PieChartModel.build()

    protected override func aboutToAppear() {
        this.pieModel.setHoleRadius(95.0);
        this.pieModel.setData(this.data);
        this.pieModel.setUsePercentValues(true);
        this.pieModel.setHoleRadius(10.0);
        this.pieModel.setTransparentCircleRadius(15.0);
        this.pieModel.setExtraOffsets(-20.0, 0.0, 0.0, 0.0);
        this.pieModel.setEntryLabelTextSize(5.0);
        this.pieModel.setDrawHoleEnabled(false);

        let l: ?Legend = this.pieModel.getLegend()
        if (let Some(l) <- l) {
            l.setOrientation(LegendOrientation.VERTICAL)
            l.setVerticalAlignment(LegendVerticalAlignment.TOP);
            l.setHorizontalAlignment(LegendHorizontalAlignment.RIGHT);
        }
    }

    func build() {
        Column() {
            PieChart(model: this.pieModel)
        }.alignItems(HorizontalAlign.Start).width(100.percent).height(30.percent)
    }
}
