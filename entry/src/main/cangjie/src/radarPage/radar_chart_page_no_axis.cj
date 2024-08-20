/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.radarPage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class RadarChartPageNoAxis {
    private var model: RadarChartModel = RadarChartModel.build()

    protected override func aboutToAppear() {
        this.model.setWebLineWidth(0.3);
        this.model.setWebColor(0xFFCCCCCC);
        this.model.setWebLineWidthInner(0.3);
        this.model.setWebColorInner(0xFFCCCCCC);
        this.model.setExtraTopOffset(-100.0);
        this.model.animateXY(2000, 2000)
        let xAxis: ?XAxis = this.model.getXAxis()
        this.setData()
    }

    private func setData(): Unit {
        let mul = 80.0;
        let min = 20.0;
        let cnt = 5;

        let entries1: ArrayList<RadarEntry> = ArrayList<RadarEntry>();
        let entries2: ArrayList<RadarEntry> = ArrayList<RadarEntry>();

        for (i in 0..cnt) {
            let val1 = (Random().nextFloat64() * mul) + min;
            entries1.append(RadarEntry(val1));

            let val2 = (Random().nextFloat64() * mul) + min;
            entries2.append(RadarEntry(val2));
        }

        let set1: RadarDataSet = RadarDataSet(entries1, "Last Week");
        set1.setColorByColor(UInt32(ChartColor.rgb(103, 110, 129)));
        set1.setLineWidth(2.0);

        let set2: RadarDataSet = RadarDataSet(entries2, "This Week");
        set2.setColorByColor(UInt32(ChartColor.rgb(121, 162, 175)));
        set2.setLineWidth(2.0);

        let sets: ArrayList<IRadarDataSet> = ArrayList<IRadarDataSet>();
        sets.append(set1);
        sets.append(set2);

        let data: RadarData = RadarData(sets);
        data.setValueTextSize(20.0);
        data.setDrawValues(false);
        data.setValueTextColor(0xffffff);
        this.model.setData(data);
    }

    func build() {
        Column() {
            Column() {
                RadarChart(model: this.model)
            }
        }
    }
}
