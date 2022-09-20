package jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit

import com.google.android.gms.fitness.data.DataSource
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.request.DataReadRequest
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 *
 * Requestの生成処理を管理
 *
 * TODO manager部改修後未確認
 * TODO flutter-plugin化後未確認
 * Fit の制約により日付をまたいでデータ出力されることがあるため
 * 前後+1日の余裕を持たせる
 */
object GoogleFitApiRequest {
    private val sdf = SimpleDateFormat(DateFormatType.YMD_HYPHEN.formatString, Locale.JAPANESE)

    private val dataSource: DataSource
        get() {
            return DataSource.Builder()
                    .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
                    .setType(DataSource.TYPE_DERIVED)
                    .setStreamName("estimated_steps")
                    .setAppPackageName("com.google.android.gms")
                    .build()
        }

    // memo sendStepで使用
    @Throws(ParseException::class)
    fun makeDailyActivityDataRequest(startDate: Date, endDate: Date): DataReadRequest {
        val cal = Calendar.getInstance()
        cal.time = startDate
        val startTime = cal.setStartTime().timeInMillis

        cal.time = endDate
        val endTime = cal.setEndTime().timeInMillis

        Logger.i(this.javaClass.name, "Range Start: " + sdf.format(startTime))
        Logger.i(this.javaClass.name, "Range End: " + sdf.format(endTime))

        // TODO DEPRECATION 解決
        @Suppress("DEPRECATION")
        return DataReadRequest.Builder()
                .bucketByTime(1, TimeUnit.DAYS)
                .aggregate(dataSource, DataType.TYPE_STEP_COUNT_DELTA)
                .aggregate(DataType.TYPE_DISTANCE_DELTA, DataType.AGGREGATE_DISTANCE_DELTA)
                .aggregate(DataType.TYPE_CALORIES_EXPENDED, DataType.AGGREGATE_CALORIES_EXPENDED)
                .aggregate(DataType.TYPE_ACTIVITY_SEGMENT, DataType.AGGREGATE_ACTIVITY_SUMMARY)
                .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
                .build()
    }

    @Throws(ParseException::class)
    fun makeDailyActivityDataRequest(targetYmd: String): DataReadRequest {
        val date = Date(sdf.parse(targetYmd)?.time ?: 0)
        val cal = Calendar.getInstance()
        cal.time = date
        val startTime = cal.setStartTime().timeInMillis

        cal.add(Calendar.DAY_OF_MONTH, 2)
        val endTime = cal.setEndTime().timeInMillis

        Logger.i(this.javaClass.name, "Range Start: " + sdf.format(startTime))
        Logger.i(this.javaClass.name, "Range End: " + sdf.format(endTime))

        // TODO DEPRECATION 解決
        @Suppress("DEPRECATION")
        return DataReadRequest.Builder()
                .bucketByTime(1, TimeUnit.DAYS)
                .aggregate(dataSource, DataType.TYPE_STEP_COUNT_DELTA)
                .aggregate(DataType.TYPE_DISTANCE_DELTA, DataType.AGGREGATE_DISTANCE_DELTA)
                .aggregate(DataType.TYPE_CALORIES_EXPENDED, DataType.AGGREGATE_CALORIES_EXPENDED)
                .aggregate(DataType.TYPE_ACTIVITY_SEGMENT, DataType.AGGREGATE_ACTIVITY_SUMMARY)
                .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
                .build()
    }

    @Throws(ParseException::class)
    fun makeDailyActivityDataRequest(startDate: Date, endDate: Date, duration:Int, timeUnit: TimeUnit): DataReadRequest {
        // TODO DEPRECATION 解決
        @Suppress("DEPRECATION")
        return DataReadRequest.Builder()
                .bucketByTime(duration, timeUnit)
                .aggregate(dataSource, DataType.TYPE_STEP_COUNT_DELTA)
                .aggregate(DataType.TYPE_DISTANCE_DELTA, DataType.AGGREGATE_DISTANCE_DELTA)
                .aggregate(DataType.TYPE_ACTIVITY_SEGMENT, DataType.AGGREGATE_ACTIVITY_SUMMARY)
                .aggregate(DataType.TYPE_CALORIES_EXPENDED, DataType.AGGREGATE_CALORIES_EXPENDED)
                .setTimeRange(startDate.time, endDate.time, TimeUnit.MILLISECONDS)
                .build()
    }

    @Deprecated("bucketByActivityTypeは期待した動作にならない 要調査")
    @Throws(ParseException::class)
    fun makeDailyActivityDataRequestByActivityType(startDate: Date, endDate: Date): DataReadRequest {
        // TODO DEPRECATION 解決
        @Suppress("DEPRECATION")
        return DataReadRequest.Builder()
                .bucketByActivityType(1, TimeUnit.SECONDS)
                .aggregate(dataSource, DataType.TYPE_STEP_COUNT_DELTA)
                .aggregate(DataType.TYPE_DISTANCE_DELTA, DataType.AGGREGATE_DISTANCE_DELTA)
                .aggregate(DataType.TYPE_ACTIVITY_SEGMENT, DataType.AGGREGATE_ACTIVITY_SUMMARY)
                .aggregate(DataType.TYPE_CALORIES_EXPENDED, DataType.AGGREGATE_CALORIES_EXPENDED)
                .setTimeRange(startDate.time, endDate.time, TimeUnit.MILLISECONDS)
                .build()
    }

    private fun Calendar.setStartTime(): Calendar {
        return this.also {
            it.set(Calendar.HOUR_OF_DAY, 0)
            it.set(Calendar.MINUTE, 0)
            it.set(Calendar.SECOND, 0)
            it.set(Calendar.MILLISECOND, 0)
            //it.add(Calendar.DAY_OF_MONTH, -1)
        }
    }

    private fun Calendar.clearTime(): Calendar {
        return this.also {
            it.set(Calendar.HOUR_OF_DAY, 0)
            it.set(Calendar.MINUTE, 0)
            it.set(Calendar.SECOND, 0)
            it.set(Calendar.MILLISECOND, 0)
        }
    }

    private fun Calendar.setEndTime(): Calendar {
        return this.also {
            it.set(Calendar.HOUR_OF_DAY, 23)
            it.set(Calendar.MINUTE, 59)
            it.set(Calendar.SECOND, 59)
            it.set(Calendar.MILLISECOND, 999)
        }
    }
}