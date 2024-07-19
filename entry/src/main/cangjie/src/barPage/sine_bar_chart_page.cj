/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package barPage
@Entry
@Component
class SineBarChartPage {
    private var title: String = "Sine"
    private var model: BarChartModel = BarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var barData: BarData = BarData()
    private var normalMarker: MarkerView = MarkerView()

    func aboutToAppear(): BarChartModel {
        let description: Description = this.model.getDescription()
        description.setEnabled(false)

        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(false)
        }

        // if more than 40 entries are displayed in the this.model, no values will be drawn
        this.model.setMaxVisibleValueCount(60)

        // scaling can now only be done on x- and y-axis separately
        this.model.setPinchZoom(false)

        this.model.setDrawGridBackground(false)
        this.model.setDrawBarShadow(false)

        this.model.setDrawValueAboveBar(true)
        this.model.setHighlightFullBarEnabled(false)

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(leftaxis) <- this.leftAxis) {
            leftaxis.setAxisMinimum(-2.5)
            leftaxis.setAxisMaximum(2.5)
            leftaxis.setLabelCount(6, false)
            leftaxis.setGranularityEnabled(true)
            leftaxis.setGranularity(0.1)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(rightaxis) <- this.rightAxis) {
            rightaxis.setDrawGridLines(false)
            rightaxis.setLabelCount(6, false)
            rightaxis.setAxisMinimum(-2.5)
            rightaxis.setAxisMaximum(2.5)
            rightaxis.setGranularity(0.1)
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setEnabled(false)
        }

        this.normalMarker = MarkerView()
        this.model.setMarker(this.normalMarker)

        this.setData(50)

        return this.model
    }

    private func setData(count: Int64): Unit {
        let dataResult: Array<Float64> = otherSine.slice(0, count)

        let entries: ArrayList<BarEntry> = ArrayList<BarEntry>()
        for (i in 0..count) {
            entries.append(BarEntry(Float64(i), dataResult[i]))
        }

        let set: BarDataSet
        let barData = this.model.getBarData()
        if (barData.isSome() && barData().getDataSetCount() > 0) {
            set = (barData().getDataSetByIndex(0) as BarDataSet)()
            set.setEntries(entries)
            barData().notifyDataChanged()
            this.model.notifyDataSetChanged()
        } else {
            set = BarDataSet(entries, "Sinus Function")
            set.setColorByColor(UInt32(0x808000))
            set.setDrawIcons(false)
            set.setDrawValues(false)

            let dataSetList: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
            dataSetList.append(set)
            let data: BarData = BarData(dataSetList)
            data.setBarWidth(0.8)
            this.model.setData(data)
        }
    }

    func render() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
