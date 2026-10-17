/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.components

public class LegendEntry {
    /**
     *
     * @param label The legend entry text. A `null` label will start a group.
     * @param form The form to draw for this entry.
     * @param formSize Set to NaN to use the legend's default.
     * @param formLineWidth Set to NaN to use the legend's default.
     * @param formLineDashEffect Set to nil to use the legend's default.
     * @param formColor The color for drawing the form.
     */
    public init() {}
    public init(label: String, form: LegendForm, formSize: Float64, formLineWidth: Float64,
        formLineDashEffect: ?DashPathEffect, formColor: UInt32) {
        this.label = label
        this.form = form
        this.formSize = formSize
        this.formLineWidth = formLineWidth
        this.formLineDashEffect = formLineDashEffect
        this.formColor = formColor
    }

    /**
     * The legend entry text.
     * A `null` label will start a group.
     */
    public var label: String = ""
    /**
     * The form to draw for this entry.
     *
     * `NONE` will avoid drawing a form, and any related space.
     * `EMPTY` will avoid drawing a form, but keep its space.
     * `DEFAULT` will use the Legend's default.
     */
    public var form: LegendForm = LegendForm.DEFAULT
    /**
     * Form size will be considered except for when .None is used
     *
     * Set as NaN to use the legend's default
     */
    public var formSize: Float64 = Float64.NaN
    /**
     * Line width used for shapes that consist of lines.
     *
     * Set as NaN to use the legend's default
     */
    public var formLineWidth: Float64 = Float64.NaN
    /**
     * Line dash path effect used for shapes that consist of lines.
     *
     * Set to null to use the legend's default
     */
    public var formLineDashEffect: ?DashPathEffect = None
    /**
     * The color for drawing the form
     */
    public var formColor: UInt32 = ColorTemplate.COLOR_NONE
}
