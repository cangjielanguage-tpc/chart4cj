/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.pageconfig

public class ContentItem {
    private var name: String
    private var desc: String
    private var pagePath: String
    private var isSection: Bool = false

    public init(n: String, d!: String = "", pagePath!: String = "") {
        this.name = n
        if (d == "" || d == "") {
            this.desc = ""
            this.isSection = true
        } else {
            this.desc = d
        }
        this.pagePath = pagePath
    }

    public func getName(): String {
        return this.name
    }

    public func getDesc(): String {
        return this.desc
    }

    public func getPagePath(): String {
        return this.pagePath
    }

    public func getIsSection(): Bool {
        return this.isSection
    }
}
