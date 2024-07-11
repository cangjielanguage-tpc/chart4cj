/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

public class PiEntry <: EntryOhos {
    public var label: String = ""

    public init(yValue: Float64, label: String, icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: ?Any = Option<Any>.None) {
        super(0.0, yValue, icon: icon, data: data);
        this.label = label
    }

    /**
     * This is the same as getY(). Returns the value of the PiEntry.
     *
     * @return
     */
    public func getValue(): Float64 {
        return super.getY()
    }

    public func getLabel(): String {
        return this.label
    }

    public func setLabel(label: String): Unit {
        this.label = label
    }

    public func copy(): PiEntry {
        let data = this.getData()
        let e: PiEntry = PiEntry(this.getY(), this.label, data: getData())
        return e
    }
}
