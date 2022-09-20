package jp.co.felicapocketmk.karadalive_flutter_plugin.data

enum class BreakType(val position: Int, val leastStep: Long) {
    NONE(-1, 0), // 記録なし
    COUNT1_1MINUTE_1HOUR(0, 80), // 1時間に1分間
    COUNT1_5MINUTE_1HOUR(1, 400), // 1時間に5分間
    COUNT2_3MINUTE_30MINUTE(2, 240) // 30分ごとに3分間を2回
}