package jp.co.felicapocketmk.karadalive_flutter_plugin.util

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import androidx.core.content.ContextCompat
import android.text.SpannableString
import android.text.Spanned
import android.text.format.DateFormat
import android.text.style.ClickableSpan
import android.view.View
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.DailyActivityData
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.MonthlyPoint
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import java.math.BigDecimal
import java.nio.charset.Charset
import java.nio.charset.CharsetEncoder
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern

object CommonUtil {

    enum class TimeCompareResult {
        FUTURE,
        PAST,
        EQUAl,
    }

    enum class TimeComparePrecision {
        YEAR,
        MONTH,
        DAY,
    }

    /**
     * 1年前の同日から本日までの経過日数を取得します。
     *
     * @return int
     */
    // cal.add(Calendar.YEAR, -1); // 1年
    // 当日を含むため +1
    val diffDays: Int
        get() {
            val cal = Calendar.getInstance()
            val toDateTime = cal.timeInMillis
            cal.add(Calendar.DAY_OF_MONTH, -90)
            val fromDateTime = cal.timeInMillis
            val diffDays = ((toDateTime - fromDateTime) / (1000 * 60 * 60 * 24)).toInt()
            return diffDays + 1
        }

    /**
     * その年のMonthlyPointリストを取得する(降順)
     */
    fun monthlyPointOfYear(now: Date): MutableList<MonthlyPoint> {
        val monthlyPointList = mutableListOf<MonthlyPoint>()

        val cal = Calendar.getInstance()
        cal.time = now

        val year = cal.get(Calendar.YEAR)
        var month = cal.get(Calendar.MONTH) + 1

        while (month > 0) {
            monthlyPointList.add(MonthlyPoint(year, month, 0))
            month--
        }
        return monthlyPointList
    }

    /**
     * 年度が4月始まりのMonthlyPointリストを取得する(降順)
     */
    fun monthlyPointOfJapaneseYear(now: Date): MutableList<MonthlyPoint> {
        val monthlyPointList = mutableListOf<MonthlyPoint>()

        val cal = Calendar.getInstance()
        cal.time = now

        var year = cal.get(Calendar.YEAR)
        var month = cal.get(Calendar.MONTH) + 1

        while (true) {
            monthlyPointList.add(MonthlyPoint(year, month, 0))
            if (month == 4) break

            if (--month < 1) {
                month = 12
                year--
            }
        }
        return monthlyPointList
    }
    /**
     * 去年の9月始まりのMonthlyPointリストを取得する(降順)
     */
    fun monthlyPointOfSeptember(now: Date): MutableList<MonthlyPoint> {
        val monthlyPointList = mutableListOf<MonthlyPoint>()

        val cal = Calendar.getInstance()
        cal.time = now

        var year = cal.get(Calendar.YEAR)
        val currentYear = year
        var month = cal.get(Calendar.MONTH) + 1

        while (true) {
            monthlyPointList.add(MonthlyPoint(year, month, 0))
            if (month == 9 && year != currentYear) break

            if (--month < 1) {
                month = 12
                year--
            }
        }
        return monthlyPointList
    }

    /**
     * 今年度の始まり(4月1日)のDateを取得する
     */
    fun japaneseFirstDayInYear(now: Date): Date {
        val nowCal = Calendar.getInstance()
        nowCal.time = now

        val year: Int
        year = if (nowCal.get(Calendar.MONTH) < 3) {
            nowCal.get(Calendar.YEAR) -1
        } else {
            nowCal.get(Calendar.YEAR)
        }
        return firstDayInMonth(year, 4)
    }

    /**
     * 今年度の終わり(3月31日)のDateを取得する
     */
    fun japaneseEndDayInYear(now: Date): Date {
        val nowCal = Calendar.getInstance()
        nowCal.time = now

        val year: Int
        year = if (nowCal.get(Calendar.MONTH) < 3) {
            nowCal.get(Calendar.YEAR)
        } else {
            nowCal.get(Calendar.YEAR) + 1
        }
        return endDayInMonth(year, 3)
    }

    /**
     * 今年度の終わりの月の初日(3月01日)のDateを取得する
     */
    fun japaneseEndMonthAndFirstDayInYear(now: Date): Date {
        val nowCal = Calendar.getInstance()
        nowCal.time = now

        val year: Int
        year = if (nowCal.get(Calendar.MONTH) < 3) {
            nowCal.get(Calendar.YEAR) -1
        } else {
            nowCal.get(Calendar.YEAR)
        }
        return firstDayInMonth(year, 3)
    }

    /**
     * 今年の始まり(1月1日)のDateを取得する
     */
    fun firstDayInYear(now: Date): Date {
        val nowCal = Calendar.getInstance()
        nowCal.time = now

        return firstDayInMonth(nowCal.get(Calendar.YEAR), 1)
    }

    /**
     * 今年の終わり(12月31日)のDateを取得する
     */
    fun endDayInYear(date: Date): Date {
        val endMonth = 12
        val cal = Calendar.getInstance()
        cal.time = date

        return endDayInMonth(cal.get(Calendar.YEAR), endMonth)
    }

    /**
     * 今月基準で過去月の差分月数を取得する
     */
    fun diffMonthFromNowToPast(past: Date): Int {
        return diffMonth(past, Date())
    }

    /**
     * 差分月数を取得する
     * toDateがfromDateよりも未来なら差分は正、逆は負
     */
    fun diffMonth(fromDate: Date, toDate: Date): Int {
        val fromCal = Calendar.getInstance()
        fromCal.time = fromDate
        fromCal.set(Calendar.DATE, 1)

        val toCal = Calendar.getInstance()
        toCal.time = toDate
        toCal.set(Calendar.DATE, 1)

        var count = 0
        val future = fromCal.before(toCal)
        if (future) {
            while (fromCal.before(toCal)) {
                fromCal.add(Calendar.MONTH, 1)
                count++
            }
        } else {
            while (toCal.before(fromCal)) {
                toCal.add(Calendar.MONTH, 1)
                count++
            }
        }
        return if (future) count else -count
    }

    /**
     * 差分日数を取得する
     * toDateがfromDateよりも未来なら差分は正、逆は負
     */
    fun diffDay(fromDate: Date, toDate: Date): Int {
        val toLong = toDate.time
        val fromLong = fromDate.time
        val diffDay = (toLong - fromLong) / (1000 * 60 * 60 * 24)

        return diffDay.toInt()
    }

    /**
     * 指定したX日後(or X日前)の同日をDate型で取得
     */
    fun dayAgoDate(amount: Int): Date {
        val today = Calendar.getInstance()
        today.add(Calendar.DAY_OF_MONTH, amount)
        return today.time
    }

    /**
     * 指定したXヶ月後(or Xヶ月前)の同日をDate型で取得
     */
    @Deprecated("use monthAgoDate(Date, Int)")
    fun monthAgoDate(amount: Int): Date {
        val today = Calendar.getInstance()
        today.add(Calendar.MONTH, amount)
        return today.time
    }

    /**
     * Xヶ月後(or Xヶ月前)の同日をDate型で取得
     */
    fun monthAgoDate(date: Date, amount: Int): Date {
        val cal = Calendar.getInstance()
        cal.time = date
        cal.add(Calendar.MONTH, amount)
        return cal.time
    }

    /**
     * 指定したX年後(or X年前)の同日をDate型で取得
     */
    @Deprecated("use yearsAgoDate(Date, Int)")
    fun yearsAgoDate(amount: Int): Date {
        val today = Calendar.getInstance()
        today.add(Calendar.YEAR, amount)
        return today.time
    }

    fun yearsAgoDate(date: Date, amount: Int): Date {
        val cal = Calendar.getInstance()
        cal.time = date
        cal.add(Calendar.YEAR, amount)
        return cal.time
    }

    /**
     * 月始めの日付を取得
     */
    fun firstDayInMonth(date: Date): Date {
        val cal = Calendar.getInstance()
        cal.time = date

        val firstDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH)
        cal.set(Calendar.DAY_OF_MONTH, firstDay)

        return cal.time
    }

    /**
     * 月始めの日付を取得
     */
    fun firstDayInMonth(year: Int, month: Int): Date {
        val cal = Calendar.getInstance()
        cal.set(Calendar.YEAR, year)
        cal.set(Calendar.MONTH, month - 1)

        val firstDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH)
        cal.set(Calendar.DAY_OF_MONTH, firstDay)

        return cal.time
    }

    /**
     * 月終わりの日付を取得
     */
    fun endDayInMonth(date: Date): Date {
        val cal = Calendar.getInstance()
        cal.time = date

        val endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH)
        cal.set(Calendar.DAY_OF_MONTH, endDay)

        return cal.time
    }

    /**
     * 月終わりの日付を取得
     */
    fun endDayInMonth(year: Int, month: Int): Date {
        val cal = Calendar.getInstance()
        cal.clear()
        cal.set(Calendar.YEAR, year)
        cal.set(Calendar.MONTH, month - 1)

        val endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH)
        cal.set(Calendar.DAY_OF_MONTH, endDay)

        return cal.time
    }

    /**
     * その週の月曜の日付を取得
     * (ただし月曜がその週始めであること)
     */
    fun mondayOfWeek(date: Date): Date {
        val monday = Calendar.getInstance()
        monday.time = date
        monday.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY)

        // Calendarの仕様(というか一般的にだと思うが...)日曜が週初めだが
        // アプリの仕様は月曜が週初め(日曜が最後)なので
        // 日曜だったら"先週"の月曜が"その週の月曜"になる
        val today = Calendar.getInstance()
        if (today[Calendar.DAY_OF_WEEK] == Calendar.SUNDAY) {
            monday.add(Calendar.DAY_OF_MONTH, -7)
        }
        return monday.time
    }

    /**
     * 年齢のひと桁を切り捨てた値を返す(旧版)
     * TODO:誕生日からの年齢計算と年代計算、一度にやっているので廃止にしたい
     */
    @Deprecated("calAgeTenPart(age: Int)")
    fun calAgeTenPart(birthday: Date): Int {
        val age = calcAgeDateStd(birthday)

        val ageString = age.toString()
        if (ageString.length < 2) return age
        val tenPartString = ageString[0] + "0"
        return tenPartString.toInt()
    }

    /**
     * 年齢のひと桁を切り捨てた値を返す
     * 10歳未満は年齢を返す
     * ex) 25 → 20, 33 → 30, 8 → 8
     */
    fun calAgeTenPart(age: Int): Int {
        val ageString = age.toString()
        if (ageString.length < 2) return age
        val tenPartString = ageString[0] + "0"
        return tenPartString.toInt()
    }

    /**
     * 日基準の年齢を求める
     */
    fun calcAgeDateStd(birthday: Date, baseDate: Date? = null): Int {
        val base = baseDate ?: Date()
        val baseInt = Integer.parseInt(convertDateToFormatString(base, DateFormatType.YMD))
        val birthInt = Integer.parseInt(convertDateToFormatString(birthday, DateFormatType.YMD))

        return (baseInt - birthInt) / 10000
    }

    /**
     * 年、年月、年月日、それぞれの精度で日付の未来過去を判定する
     *
     * @param target 比較対象日時
     * @param base 比較基準日時
     * @return 比較結果
     */
    fun timeCompare(target: Date, base: Date, precision:TimeComparePrecision): TimeCompareResult {
        val baseCal = Calendar.getInstance()
        baseCal.time = base
        val baseYear = baseCal.get(Calendar.YEAR)
        val baseMonth = baseCal.get(Calendar.MONTH)
        val baseDay = baseCal.get(Calendar.DAY_OF_MONTH)

        baseCal.time = Date()

        val targetCal = Calendar.getInstance()
        targetCal.time = target
        val targetYear = targetCal.get(Calendar.YEAR)
        val targetMonth = targetCal.get(Calendar.MONTH)
        val targetDay = targetCal.get(Calendar.DAY_OF_MONTH)

        targetCal.time = baseCal.time

        when (precision) {
            TimeComparePrecision.YEAR -> {
                if (targetYear == baseYear) return TimeCompareResult.EQUAl

                targetCal.set(Calendar.YEAR, targetYear)
                baseCal.set(Calendar.YEAR, baseYear)
            }
            TimeComparePrecision.MONTH -> {
                if (targetYear == baseYear
                        && targetMonth == baseMonth) return TimeCompareResult.EQUAl

                targetCal.set(Calendar.YEAR, targetYear)
                targetCal.set(Calendar.MONTH, targetMonth)
                baseCal.set(Calendar.YEAR, baseYear)
                baseCal.set(Calendar.MONTH, baseMonth)
            }
            TimeComparePrecision.DAY -> {
                if (targetYear == baseYear
                        && targetMonth == baseMonth
                        && targetDay == baseDay) return TimeCompareResult.EQUAl

                targetCal.set(Calendar.YEAR, targetYear)
                targetCal.set(Calendar.MONTH, targetMonth)
                targetCal.set(Calendar.DAY_OF_MONTH, targetDay)
                baseCal.set(Calendar.YEAR, baseYear)
                baseCal.set(Calendar.MONTH, baseMonth)
                baseCal.set(Calendar.DAY_OF_MONTH, baseDay)
            }
        }

        if (baseCal.after(targetCal)) {
            return TimeCompareResult.PAST
        }

        return TimeCompareResult.FUTURE
    }

    /**
     * Date型 → 各種フォーマット日時文字列
     */
    fun convertDateToFormatString(date: Date, formatType: DateFormatType): String {
        return SimpleDateFormat(formatType.formatString, Locale.JAPANESE)
                .format(date)
    }

    /**
     * 各種フォーマット日時文字列 → Date型
     */
    fun convertFormatStringToDate(formatString: String, formatType: DateFormatType): Date {
        return SimpleDateFormat(formatType.formatString, Locale.JAPANESE)
                .parse(formatString)
    }

    /**
     * 指定したX年前の同日をYMD_HYPHEN_PATTERN(String)で取得します。
     *
     * @param amount X年前を指定
     * @return String
     */
    fun ymdHyphenPatternYearsAgo(amount: Int): String {
        val today = Calendar.getInstance()
        today.add(Calendar.YEAR, amount)
        return DateFormat.format(DateFormatType.YMD_HYPHEN.formatString, today).toString()
    }

    /**
     * 数値を3桁区切りの文字列に変換します。
     * digit separator
     * @param value Long
     * @return String
     */
    @SuppressLint("DefaultLocale")
    fun convertTo3DigitSeparator(value: Long?): String {
        return String.format("%,d", value)
    }

    /**
     * 距離をカンマフォーマット、小数点第2位までの文字列に変換します。
     *
     * @param value Long
     * @return String
     */
    @SuppressLint("DefaultLocale")
    fun convertToKmFormat(value: Long): String {
        var bd = BigDecimal(value / 1000.0)
        bd = bd.setScale(2, BigDecimal.ROUND_FLOOR)
        return String.format("%,.2f", bd)
    }

    fun trimAllSpace(str: String): String {
        return str.replace(" ", "").replace("　", "")
    }

    /**
     * アプリのバージョン名を取得します。
     *
     * @param context Context
     * @return String
     */
    fun applicationVersionName(context: Context): String {
        val pm = context.packageManager
        var versionName = ""
        try {
            val packageInfo = pm.getPackageInfo(context.packageName, 0)
            versionName = packageInfo.versionName
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return versionName
    }

    /**
     * px→dpに変換
     * @param context
     * @param px
     * @return
     */
    fun convertPxToDp(context: Context, px: Int): Int {
        val d = context.resources.displayMetrics.density
        return (px / d + 0.5).toInt()
    }

    /**
     * dp→pxに変換
     * @param context
     * @param dp
     * @return
     */
    fun convertDpToPx(context: Context, dp: Int): Int {
        val d = context.resources.displayMetrics.density
        return (dp * d + 0.5).toInt()
    }

    /**
     * BMIを求める
     * BMI＝体重(kg) ÷ {身長(m) Ｘ 身長(m)}
     *
     * @param weight
     * @param height
     * @param scale (0 = 小数第1位を四捨五入, 1 = 小数第2位を四捨五入 ...)
     */
    fun calcBmi(weight: Float, height: Float, scale: Int = 0): Float{
        if (weight <= 0 || height <= 0) {
            return 0F
        }
        val bmi = weight / ( (height / 100) * (height /100))

        return BigDecimal(bmi.toDouble()).setScale(scale, BigDecimal.ROUND_HALF_UP).toFloat()
    }

    fun isNeedPermissionCheck(): Boolean {
        // Android 6, API 23以上で要パーミッシンの確認
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
    }

    fun checkPermission(context: Context, manifestPermission: String): Boolean {
        return ContextCompat.checkSelfPermission(
                context,
                manifestPermission) == PackageManager.PERMISSION_GRANTED
    }

    /**
     * リンク付きのテキストを生成する
     */
    fun linkedText(context: Context, originalText: String): SpannableString {

        // URLを判定 本文を改行で分割
        val msg = originalText.split("\n".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
        val list = mutableListOf<String>()
        val regex = "(http://|https://){1}[\\w\\.\\-/:\\#\\?\\=\\&\\;\\%\\~\\+]+".toRegex()

        for (lineText in msg) {
            if (lineText.matches(".*http.*".toRegex()) || lineText.matches(".*https.*".toRegex())) {
                var line = lineText
                line = line.replace("　".toRegex(), "")
                line = line.replace(" ".toRegex(), "")
                val urls = regex.findAll(line)
                // 一行の中からURLのみを切り出し、listに詰める
                for (url in urls) {
                    list.add(url.value)
                }
            }
        }
        return createSpannableString(context, originalText, list)
    }

    private fun createSpannableString(context: Context, originalText: String, list: MutableList<String>): SpannableString {
        val ss = SpannableString(originalText)

        for (url in list) {
            var start: Int
            var end: Int

            // リンク化対象の文字列の start, end を算出する
            val pattern = Pattern.compile(url.replace("?", "\\?"))
            val matcher = pattern.matcher(originalText)
            while (matcher.find()) {
                start = matcher.start()
                end = matcher.end()

                // SpannableString にクリックイベント、パラメータをセットする
                ss.setSpan(object : ClickableSpan() {
                    override fun onClick(textView: View) {
                        val uri = Uri.parse(url)
                        context.startActivity(Intent(Intent.ACTION_VIEW, uri))
                    }
                }, start, end, Spanned.SPAN_INCLUSIVE_INCLUSIVE)
            }
        }
        return ss
    }

    /**
     * 環境依存文字が含まれているか確認
     */
    fun hasInvalidCharset(targetStr: String): Boolean {
        val charset: Charset = Charset.forName("Shift_JIS")
        val encoder: CharsetEncoder = charset.newEncoder()

        for (targetChar in targetStr.toCharArray()) {
            val c = convertMappingMismatchChar(targetChar)
            if (c.isSurrogate()) return true
            if (!encoder.canEncode(c)) return true
        }
        return false
    }

    /**
     * Unicodeマッピング不整合が発生する特殊文字の変換
     * Shift_JIS においてUnicodeマッピング不整合が発生する文字を個別に変換して回避するため変換を行う
     * 以下の文字を変換の対象としている
     *   ￠(0xFFE0)
     *   ￡(0xFFE1)
     *   ￢(0xFFE2)
     *   ∥(0x2225)
     *   －(0xFF0D)
     *   ～(0xFF5E)
     *   ―(0x2015)
     * @param target 対象文字
     * @return 変換後文字
     */
    private fun convertMappingMismatchChar(target: Char): Char {
        var converted = target
        when (target) {
            0xFFE0.toChar() -> converted = 0x00A2.toChar()
            0xFFE1.toChar() -> converted = 0x00A3.toChar()
            0xFFE2.toChar() -> converted = 0x00AC.toChar()
            0x2225.toChar() -> converted = 0x2016.toChar()
            0xFF0D.toChar() -> converted = 0x2212.toChar()
            0xFF5E.toChar() -> converted = 0x301C.toChar()
            0x2015.toChar() -> converted = 0x2014.toChar()
            else -> { }
        }
        return converted
    }

    /**
     * 指定年月のDailyActivityDataランダムデータを作成
     * (For テスト)
     */
    fun createRandomDailyActivityData(year: Int, month: Int): List<DailyActivityData> {
        val endDayCal = Calendar.getInstance()
        endDayCal.time = endDayInMonth(year, month)

        val activityDataList = mutableListOf<DailyActivityData>()

        val createCal = Calendar.getInstance()
        createCal.time = firstDayInMonth(year, month)

        val count = endDayCal.get(Calendar.DAY_OF_MONTH)

        for (i in 1..count) {
            val activityData = DailyActivityData(convertDateToFormatString(createCal.time, DateFormatType.YMD_HYPHEN))
            val rand = Random()

            val stepInt = rand.nextInt(30001)
            activityData.step = stepInt.toLong()

            val distanceInt = rand.nextInt(5001)
            activityData.distance = distanceInt.toLong()

            val calorieInt = rand.nextInt(4001) + 1000
            activityData.calories = calorieInt.toLong()

            val systolicBpInt = rand.nextInt(30) + 130
            activityData.systolicBp = systolicBpInt.toLong()

            val diastolicBpInt = rand.nextInt(40) + 80
            activityData.diastolicBp = diastolicBpInt.toLong()

            val runningInt = rand.nextInt(7200)
            activityData.runningTime = runningInt.toLong()

            val cyclingInt = rand.nextInt(14400)
            activityData.cyclingTime = cyclingInt.toLong()
            
            val maxWeight = 100.0f
            val minWeight = 60.0f
            val weightFloat = rand.nextFloat() * (maxWeight - minWeight) + minWeight
            val weightString = String.format("%.1f", weightFloat)
            activityData.weight = weightString.toFloat()

            activityDataList.add(activityData)

            createCal.add(Calendar.DAY_OF_MONTH, 1)
        }
        return activityDataList
    }
}
