//
//  Constants.swift
//

import Foundation

public enum Constants {
    public enum Api {
        public enum Client {
            public static let production = "deadbeef"
            public static let staging = "beefdead"
        }
        
        // TODO
//        public enum Endpoint {
//            public static let production = App.current.appConfig.productionEndpoint
//            public static let staging = App.current.appConfig.stagingEndpoint
//        }
        
        public enum EndpointAdLoc {
            public static let production = "api.adloc.jp/api"
            public static let staging = "stage-api.adloc.jp/api"
        }
        
        public enum DefaultParameter {
            public static let homeMessageCount = 5
        }
        
        public enum NetworkError {
            public static let title = "通信に失敗しました。"
            public static let message = "電波の良い場所に移動するか、しらばらく経ってからアプリを起動してください。"
            public static let yesTitle = "OK"
        }

        public static let rankingLimit = 300
    }
    
    // TODO
//    public enum WebEndpoint {
//        public static var production = App.current.appConfig.productionWebEndpoint
//        public static var staging = App.current.appConfig.stagingWebEndpoint
//
//        public static func update(production: String, staging: String) {
//            self.production = production
//            self.staging = staging
//        }
//    }
    
    public enum Privacy {
        public static let yesTitle = "OK"
    }
    
    public static let weightUpdateErrorMessage = "体重の値を10〜200[kg]で入力して下さい"
    public static let bodyFatUpdateErrorMessage = "体脂肪率の値を5〜50で入力して下さい"
    public static let stepGoalErrorMessage = "目標歩数は3000歩～15000歩としてください。"

    public static let maxGraphMonth = 12
    public static let maxRankingMonth = 12
    public static let maxHomeDay = 31
    
    public static let currentMonth = 0

    public static let messagePageSize = 10
    
    public static let pageSize = 31

    public static let maxExaminationYear = 5

    public enum Ranking {
        public static let maxMonth = 12
    }
        
    public static let homeCharacterImage = "airfy_flip"
    
    @available(*, deprecated, message: "will be removed")
    public enum Ibaraki {
        public enum Examination {
            public static let specificChecks = ["初回", "終了"]
        }
        
        public enum Takling {
            public static let taklingID = "talk"
        }
    }
    
    public enum Zendesk {
        /*
         * Zendesk SDK 初期化設定
         --------------------------------------- */
        public static let appId = "d3a315b09b058b99595e4f7a6f2f95733dbf68dac834650a"
        public static let zendeskUrl = "https://karada-live.zendesk.com"
        public static let clientId = "mobile_sdk_client_a47ffc832de47ccd4c0c"
    }
    
    public static let prefectures = [
        ("北海道", "01"), ("青森県", "02"), ("岩手県", "03"), ("宮城県", "04"), ("秋田県", "05"), ("山形県", "06"), ("福島県", "07"),
        ("茨城県", "08"), ("栃木県", "09"), ("群馬県", "10"), ("埼玉県", "11"), ("千葉県", "12"), ("東京都", "13"), ("神奈川県", "14"),
        ("新潟県", "15"), ("富山県", "16"), ("石川県", "17"), ("福井県", "18"), ("山梨県", "19"), ("長野県", "20"),
        ("岐阜県", "21"), ("静岡県", "22"), ("愛知県", "23"), ("三重県", "24"),
        ("滋賀県", "25"), ("京都府", "26"), ("大阪府", "27"), ("兵庫県", "28"), ("奈良県", "29"), ("和歌山県", "30"),
        ("鳥取県", "31"), ("島根県", "32"),
        ("岡山県", "33"), ("広島県", "34"), ("山口県", "35"),
        ("徳島県", "36"), ("香川県", "37"), ("愛媛県", "38"), ("高知県", "39"),
        ("福岡県", "40"), ("佐賀県", "41"), ("長崎県", "42"), ("熊本県", "43"), ("大分県", "44"), ("宮崎県", "45"), ("鹿児島県", "46"), ("沖縄県", "47")
    ]
    
    static let katakanaMessage = "フリガナは3文字以上20文字以下のカタカナで入力して下さい。"
    static let furikanaMessage = "ふりがなは3文字以上20文字以下で入力して下さい。"
    
    public static let lastPointsDefaultValue = -1
}

public enum Google {
    public static let apiKey = "AIzaSyChihzJ3cG-xrfiBSYOgzMWjyjE1Ea1gog"
}
