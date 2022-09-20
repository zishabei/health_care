package jp.co.felicapocketmk.karadalive_flutter_plugin.util

import android.os.Debug
import android.os.Environment
import android.util.Log
import jp.co.felicapocketmk.karadalive_flutter_plugin.BuildConfig
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import java.io.*
import java.util.*

/**
 * デバッグ用のLogCatを出力します。
 *
 * 使用方法
 * Logger.d("メッセージ");
 * 又は
 * Logger.d(TAG, "メッセージ");
 */
object Logger {

    // LogCatのデフォルトフィルター名
    private const val TAG = "appLog"

    fun e(msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.e(TAG, msg.orEmpty())
        }
    }

    fun e(tag: String, msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.e(tag, msg.orEmpty())
        }
    }

    fun w(msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.w(TAG, msg.orEmpty())
        }
    }

    fun w(tag: String, msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.w(tag, msg.orEmpty())
        }
    }

    fun i(msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.i(TAG, msg.orEmpty())
        }
    }

    fun i(tag: String, msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.i(tag, msg.orEmpty())
        }
    }

    fun d(msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.d(TAG, msg.orEmpty())
        }
    }

    fun d(tag: String, msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.d(tag, msg.orEmpty())
        }
    }

    fun v(msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.v(TAG, msg.orEmpty())
        }
    }

    fun v(tag: String, msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.v(tag, msg.orEmpty())
        }
    }

    @JvmOverloads
    fun heap(tag: String = TAG) {
        if (BuildConfig.DEBUG) {
            val msg = ("heap : Free="
                    + java.lang.Long.toString(Debug.getNativeHeapFreeSize() / 1024)
                    + "kb" + ", Allocated="
                    + java.lang.Long.toString(Debug.getNativeHeapAllocatedSize() / 1024)
                    + "kb" + ", Size="
                    + java.lang.Long.toString(Debug.getNativeHeapSize() / 1024) + "kb")

            Log.v(tag, msg)
        }
    }

    /**
     * 外部ファイルへのログ出力(主にデバッグ用)
     * 使用の際はパーミッションをマニフェストへ記載する
     * <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
     *
     * (注)OSバージョン依存が強いので実用的ではない(Deprecated)
     *
     * TODO:アプリ名依存を排する(そもそもこのメソッド削除をも考慮)
     */
    @Deprecated("")
    fun fileOutput(msg: String) {
        val dirPath = Environment.getExternalStorageDirectory().getPath() + "/ishikawa/"
        val fileName = dirPath + "log.txt"
        var text = msg
        val now = Date()
        var bw: BufferedWriter? = null
        val ste = Throwable().stackTrace
        text = "${ste[1].methodName}(${ste[1].fileName}:${ste[1].lineNumber})" + text
        try {
            try {
                mkDir(dirPath)
            } catch (e: IOException) {
                e.printStackTrace()
                return
            }
            val file = FileOutputStream(fileName, true)
            bw = BufferedWriter(OutputStreamWriter(file, "UTF-8"))
        } catch (e: UnsupportedEncodingException) {
            e.printStackTrace()
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }

        try {
            val nowString = CommonUtil.convertDateToFormatString(now, DateFormatType.YMD_HMS_SLASH)
            bw?.append(nowString + "\t" + text + "\n")
            Log.e("fileOutput", nowString + "\t" + text)
        } catch (e: IOException) {
            e.printStackTrace()
        }

        try {
            bw?.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    @Throws(IOException::class)
    fun mkDir(path: String): Boolean {
        val dir = File(path)
        return if (!dir.exists()) {
            if (!dir.mkdirs()) {
                throw IOException("File.mkdirs() failed.")
            }
            true
        } else if (!dir.isDirectory) {
            throw IOException("Cannot create path. " + dir.toString() + " already exists and is not a directory.")
        } else {
            false
        }
    }
}
