package jp.co.felicapocketmk.karadalive_flutter_plugin.data

data class BreakResult(
    var timeResult: Array<BreakType>,
    var summary: Array<Int>
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as BreakResult

        if (!timeResult.contentEquals(other.timeResult)) return false
        if (!summary.contentEquals(other.summary)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = timeResult.contentHashCode()
        result = 31 * result + summary.contentHashCode()
        return result
    }
}