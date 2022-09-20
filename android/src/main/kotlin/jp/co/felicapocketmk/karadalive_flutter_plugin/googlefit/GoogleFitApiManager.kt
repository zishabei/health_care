package jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit

import android.content.Context
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.data.DataSet
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.result.DataReadResponse
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.DailyActivityData
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.DailyActivityDataMap
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * GoogleFitからデータを取得するI/Fをまとめる
 */
@Suppress("unused")
object GoogleFitApiManager {

    interface GoogleFitApiManagerListener : EventListener {
        fun onReadFitDataComplete(fitDailyActivityList: List<DailyActivityData>?)
    }

    private var listener: GoogleFitApiManagerListener? = null

    fun setListener(listener: GoogleFitApiManagerListener) {
        GoogleFitApiManager.listener = listener
    }

    /**
     * 期間を指定してFitからデータを取得する
     */
    fun readFitData(context: Context, startDate: Date, endDate: Date) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequest(startDate, endDate))
                    .addOnSuccessListener(this::successHandle)
                    .addOnFailureListener(this::errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     * Fitから今日のデータを取得する
     */
    fun readFitDataToday(context: Context) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readDailyTotalFromLocalDevice(DataType.TYPE_STEP_COUNT_DELTA)
                    .addOnSuccessListener(this::successHandle)
                    .addOnFailureListener(this::errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     * Fitから指定日のデータを取得する
     */
    fun readFitData(context: Context, targetYmd: String) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequest(targetYmd))
                    .addOnSuccessListener(this::successHandle)
                    .addOnFailureListener(this::errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    @Throws(Throwable::class)
    private fun requiredGoogleSignInAccount(context: Context): GoogleSignInAccount {
        val account = GoogleSignIn.getLastSignedInAccount(context)
        account ?: throw Throwable("Can not get LastSignedInAccount.")
        return account
    }

    private fun successHandle(dataReadResponse: DataReadResponse) {
        Logger.i(this.javaClass.name, "Read Fitness Data Success.")
        listener?.onReadFitDataComplete(convertToDailyActivity(dataReadResponse))
        Logger.i(this.javaClass.name, "Read Fitness Data end.")
    }

    private fun successHandle(dataSet: DataSet) {
        Logger.i(this.javaClass.name, "Read Fitness Data Success.")
        listener?.onReadFitDataComplete(convertToDailyActivityToday(dataSet))
        Logger.i(this.javaClass.name, "Read Fitness Data end.")
    }

    private fun errorHandle(t: Throwable) {
        Logger.e(t.message)
        listener?.onReadFitDataComplete(null)
    }

    // TODO 変換処理はConverter or Translatorとして外部に切り出しても良さそう

    /** 変換処理 当日用(readDailyTotalFromLocalDevice) */
    private fun convertToDailyActivityToday(dataSet: DataSet): List<DailyActivityData> {
        val dailyActivityMap = DailyActivityDataMap(arrayListOf())
        dailyActivityMap.updateDailyActivityData(dumpDataSet(dataSet))
        return dailyActivityMap.getDailyActivityDataList()
    }

    /** 変換処理 日付を跨ぐ用 */
    private fun convertToDailyActivity(dataReadResult: DataReadResponse): List<DailyActivityData> {
        // If the DataReadRequest object specified aggregated data, dataReadResult will be returned
        // as buckets containing DataSets, instead of just DataSets.

        val dailyActivityMap = DailyActivityDataMap(arrayListOf())

        if (dataReadResult.buckets.size > 0) {
            Logger.i(
                    this.javaClass.name,
                    "Number of returned buckets of DataSets is: " + dataReadResult.buckets.size
            )
            for (bucket in dataReadResult.buckets) {
                Logger.d(this.javaClass.name, "↓↓↓↓↓" + bucket.activity + "↓↓↓↓↓")

                // TODO:以下の仮実装を使用するのであれば本実装をコメントアウト ↓
                // データの絞り込みが可能(下記参考)
                // https://developers.google.com/android/reference/com/google/android/gms/location/DetectedActivity#constant-summary
                // if (bucket.activity == "walking" ||
                //       bucket.activity == "running" ||
                //        bucket.activity == "still"
                // ) { // "walking", "running", "still" が対象 (https://developers.google.com/android/reference/com/google/android/gms/location/DetectedActivity)

                val dataSets = bucket.dataSets
                for (dataSet in dataSets) {
                    dailyActivityMap.updateDailyActivityData(dumpDataSet(dataSet))
                }
                // }
                // TODO:以下の仮実装を使用するのであれば本実装をコメントアウト ↑

                Logger.d(this.javaClass.name, "↑↑↑↑↑" + bucket.activity + "↑↑↑↑↑")
            }

        } else if (dataReadResult.dataSets.size > 0) {
            Logger.i(
                    this.javaClass.name,
                    "Number of returned DataSets is: " + dataReadResult.dataSets.size
            )
            for (dataSet in dataReadResult.dataSets) {
                dailyActivityMap.updateDailyActivityData(dumpDataSet(dataSet))
            }
        }
        return dailyActivityMap.getDailyActivityDataList()
    }

    /** 変換処理 アプリ内で使用するドメインに変換 */
    private fun dumpDataSet(dataSet: DataSet): List<DailyActivityData> {
        Logger.i(this.javaClass.name, "Data returned for Data type: " + dataSet.dataType.name)

        val dailyActivityDataList = arrayListOf<DailyActivityData>()
        val sdf = SimpleDateFormat(DateFormatType.YMD_HYPHEN.formatString, Locale.JAPANESE)

        for (dp in dataSet.dataPoints) {
            val targetDay = sdf.format(dp.getStartTime(TimeUnit.MILLISECONDS))
            var distance = 0L
            var steps = 0L

            for (field in dp.dataType.fields) {
                if (field.name == "distance") {
                    Logger.d(
                            this.javaClass.name,
                            targetDay + " distance: " + dp.getValue(field).toString()
                    )
//                    if (dp.originalDataSource.streamName == "user_input") {
//                        continue
//                    }
                    distance = dp.getValue(field).asFloat().toLong()
                }

                if (field.name == "steps") {
                    Logger.d(
                            this.javaClass.name,
                            targetDay + " steps: " + dp.getValue(field).toString()
                    )
                    if (dp.originalDataSource.streamName == "user_input") {
                        continue
                    }
                    steps = dp.getValue(field).asInt().toLong()
                }

                // カロリー (bucket.getActivity() が "still" の場合、非活動のカロリーも加算されるため注意)
//                 if (field.getName().equals("calories")) {
//                     Logger.d(this.javaClass.name, targetDay + " calories: " + dp.getValue(field).toString());
//                     fitnessData.addCalories(Float.parseFloat(dp.getValue(field).toString()));
//                 }
            }
            dailyActivityDataList.add(DailyActivityData(targetDay, steps, distance))
        }
        return dailyActivityDataList
    }
}
