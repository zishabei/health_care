package jp.co.felicapocketmk.karadalive_flutter_plugin

import android.content.Context
import android.util.Log
import dev.flutter.pigeon.Pigeon
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.AppConfig
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit.GoogleFitApiService
import jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit.converter.GoogleFitApiConverter
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.CommonUtil
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger
import java.util.*

class FlutterCallNativeApi(private val context: Context) : Pigeon.FlutterCallNativeApi {

    override fun getTodayStep(result: Pigeon.Result<Pigeon.NativeStep>?) {
        fetchTodayStep(
            successHandle = { result?.success(it) },
            errorHandle = { result?.error(it) }
        )
    }

    /**
     * get 31 days step list
     */
    override fun getHistorySteps(result: Pigeon.Result<Pigeon.NativeStepList>?) {
        fetchMonthlySteps(
            successHandle = { result?.success(it) },
            errorHandle = { result?.error(it) }
        )
    }

    override fun getLast2DaysSteps(result: Pigeon.Result<Pigeon.NativeStepList>?) {
        fetchLast2DaysSteps(
            successHandle = { result?.success(it) },
            errorHandle = { result?.error(it) }
        )
    }

    /**
     * date format: 'yyyy-MM-dd'
     */
    override fun getSteps(
        startDate: String,
        endDate: String,
        result: Pigeon.Result<Pigeon.NativeStepList>?
    ) {
        fetchStepsByTerms(
            CommonUtil.convertFormatStringToDate(startDate, DateFormatType.YMD_HYPHEN),
            CommonUtil.convertFormatStringToDate(endDate, DateFormatType.YMD_HYPHEN),
            successHandle = { result?.success(it) },
            errorHandle = { result?.error(it) }
        )
    }

    private fun fetchTodayStep(
        successHandle: ((Pigeon.NativeStep) -> Unit),
        errorHandle: ((Throwable) -> Unit)
    ) {
        val builder = Pigeon.NativeStep.Builder()
        GoogleFitApiService().readFitDataToday(context, successHandle = {
            val dailyActivityDataList = GoogleFitApiConverter.convertToDailyActivity(it)
            dailyActivityDataList.firstOrNull()?.let { data ->
                builder.setDate(data.measuredAt)
                builder.setDistance(data.distance)
                builder.setSteps(data.step)
            }
            successHandle(builder.build())
        }, errorHandle = { throwable ->
            Logger.e("fetchTodayStep error ${Log.getStackTraceString(throwable)}")
            errorHandle(throwable)
        })
    }

    fun fetchMonthlySteps(
        successHandle: ((Pigeon.NativeStepList) -> Unit),
        errorHandle: ((Throwable) -> Unit)
    ) {
        val listBuilder = Pigeon.NativeStepList.Builder()
        val endDate = Calendar.getInstance()
        val startDate: Calendar = (endDate.clone() as Calendar).also { it.add(Calendar.DAY_OF_MONTH, -AppConfig.DATA_OF_DAYS) }
        GoogleFitApiService().readFitData(context, startDate.time, endDate.time, successHandle = { readResponse ->
            val dailyActivityDataList = GoogleFitApiConverter.convertToDailyActivity(readResponse)
            val stepList = dailyActivityDataList.map { data ->
                Logger.i("fetchMonthlySteps data $data")
                Pigeon.NativeStep.Builder().also {
                    it.setDate(data.measuredAt)
                    it.setDistance(data.distance)
                    it.setSteps(data.step)
                }.build()
            }
            listBuilder.setRecords(stepList)
            successHandle(listBuilder.build())
        }, errorHandle = { throwable ->
            Logger.e("fetchMonthlySteps error ${Log.getStackTraceString(throwable)}")
            errorHandle(throwable)
        })
    }

    fun fetchLast2DaysSteps(
        successHandle: ((Pigeon.NativeStepList) -> Unit),
        errorHandle: ((Throwable) -> Unit)
    ) {
        val listBuilder = Pigeon.NativeStepList.Builder()
        val endDate = Calendar.getInstance()
        val startDate: Calendar = (endDate.clone() as Calendar).also { it.add(Calendar.DAY_OF_MONTH, -1) }
        GoogleFitApiService().readFitData(context, startDate.time, endDate.time, successHandle = { readResponse ->
            val dailyActivityDataList = GoogleFitApiConverter.convertToDailyActivity(readResponse)
            val stepList = dailyActivityDataList.map { data ->
                Pigeon.NativeStep.Builder().also {
                    it.setDate(data.measuredAt)
                    it.setDistance(data.distance)
                    it.setSteps(data.step)
                }.build()
            }
            listBuilder.setRecords(stepList)
            successHandle(listBuilder.build())
        }, errorHandle = { throwable ->
            Logger.e("fetchLast2DaysSteps error ${Log.getStackTraceString(throwable)}")
            errorHandle(throwable)
        })
    }

    fun fetchStepsByTerms(
        startDate: Date,
        endDate: Date,
        successHandle: ((Pigeon.NativeStepList) -> Unit),
        errorHandle: ((Throwable) -> Unit)
    ) {
        val listBuilder = Pigeon.NativeStepList.Builder()
        GoogleFitApiService().readFitData(context, startDate, endDate, successHandle = { readResponse ->
            val dailyActivityDataList = GoogleFitApiConverter.convertToDailyActivity(readResponse)
            val stepList = dailyActivityDataList.map { data ->
                Pigeon.NativeStep.Builder().also {
                    it.setDate(data.measuredAt)
                    it.setDistance(data.distance)
                    it.setSteps(data.step)
                }.build()
            }
            listBuilder.setRecords(stepList)
            successHandle(listBuilder.build())
        }, errorHandle = { throwable ->
            Logger.e("fetchStepsByTerms error ${Log.getStackTraceString(throwable)}")
            errorHandle(throwable)
        })
    }
}