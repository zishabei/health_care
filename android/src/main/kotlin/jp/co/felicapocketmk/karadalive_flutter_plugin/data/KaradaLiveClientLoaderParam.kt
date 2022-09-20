package jp.co.felicapocketmk.karadalive_flutter_plugin.data

data class KaradaLiveClientLoaderParam(
        var dbName: String, // walking.db
        var preferenceName: String, // KARADA_LIVE_CONFIG
        var device: String,
        var serviceNo: String,
        var endPoint: String? = null
)
