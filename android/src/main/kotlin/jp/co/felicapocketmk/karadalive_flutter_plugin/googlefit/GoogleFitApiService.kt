package jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit

import android.content.Context
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.result.DataReadResponse
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * 個別にリクエストを投げたい/レスポンスを受けたいケース
 * GoogleFitからデータを取得するI/Fをまとめる
 */
class GoogleFitApiService {

    /**
     *
     * 基準日を指定してFitからデータを取得する
     */
    fun readFitDataByActivityType(context: Context,
                                  fetchDate: Date,
                                  successHandle: ((DataReadResponse) -> Unit),
                                  errorHandle: ((Throwable) -> Unit)) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")

        val cal = Calendar.getInstance()
        cal.time = fetchDate
        val startTime = cal.clearTime().timeInMillis

        cal.time = fetchDate
        val endTime = cal.setEndTime().timeInMillis

        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequestByActivityType(Date(startTime), Date(endTime)))
                    .addOnSuccessListener(successHandle)
                    .addOnFailureListener(errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     *
     * 期間を指定してFitからデータを取得する
     *
     * 日付の加工はしない
     */
    fun readFitDataByActivityType(context: Context,
                                  startDate: Date,
                                  endDate: Date,
                                  successHandle: ((DataReadResponse) -> Unit),
                                  errorHandle: ((Throwable) -> Unit)) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequestByActivityType(startDate, endDate))
                    .addOnSuccessListener(successHandle)
                    .addOnFailureListener(errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     * 期間を指定してFitからデータを取得する
     */
    fun readFitData(context: Context,
                    startDate: Date,
                    endDate: Date,
                    successHandle: ((DataReadResponse) -> Unit),
                    errorHandle: ((Throwable) -> Unit)) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequest(startDate, endDate))
                    .addOnSuccessListener(successHandle)
                    .addOnFailureListener(errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     * Fitから今日のデータを取得する
     */
    fun readFitDataToday(context: Context,
                         successHandle: ((DataReadResponse) -> Unit),
                         errorHandle: ((Throwable) -> Unit)) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            val today = Date()
            val cal = Calendar.getInstance()
            cal.time = today
            val startTime = cal.clearTime().timeInMillis

            cal.time = today
            val endTime = cal.setEndTime().timeInMillis
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequest(Date(startTime), Date(endTime)))
                    .addOnSuccessListener(successHandle)
                    .addOnFailureListener(errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     * Fitから指定日のデータを取得する
     */
    fun readFitData(context: Context,
                    targetYmd: String,
                    successHandle: ((DataReadResponse) -> Unit),
                    errorHandle: ((Throwable) -> Unit)) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequest(targetYmd))
                    .addOnSuccessListener(successHandle)
                    .addOnFailureListener(errorHandle)
        } catch (t: Throwable) {
            errorHandle(t)
        }
    }

    /**
     *
     * 期間と集計間隔(duration/TimeUnit)を指定してFitからデータを取得する
     *
     * 日付の加工はしない
     */
    fun readFitData(context: Context,
                    startDate: Date,
                    endDate: Date,
                    duration: Int,
                    timeUnit: TimeUnit,
                    successHandle: ((DataReadResponse) -> Unit),
                    errorHandle: ((Throwable) -> Unit)) {
        Logger.i(this.javaClass.name, "Read Fitness Data start.")
        try {
            Fitness.getHistoryClient(context, requiredGoogleSignInAccount(context))
                    .readData(GoogleFitApiRequest.makeDailyActivityDataRequest(startDate, endDate, duration, timeUnit))
                    .addOnSuccessListener(successHandle)
                    .addOnFailureListener(errorHandle)
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
