/**
 * Created on 2024/5/11
 */
package core.pie

public interface OnChartValueSelectedListener {

    /**
     * Called when a value has been selected inside the chart.
     *
     * @param e The selected Entry
     * @param h The corresponding highlight object that contains information
     *          about the highlighted position such as dataSetIndex, ...
     */
    func onValueSelected(e: EntryOhos, h: Highlight): Unit

    /**
     * Called when nothing has been selected or an "un-select" has been made.
     */
    func onNothingSelected(): Unit
}
