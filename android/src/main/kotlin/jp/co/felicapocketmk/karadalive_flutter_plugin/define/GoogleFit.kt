package jp.co.felicapocketmk.karadalive_flutter_plugin.define

enum class GoogleFit(var value: String) {
    PACKAGE_NAME("com.google.android.apps.fitness"),
    MARKET_URL("market://details?id=${PACKAGE_NAME.value}"),
}
