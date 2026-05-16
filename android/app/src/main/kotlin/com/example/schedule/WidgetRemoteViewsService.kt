package com.example.schedule

import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray
import org.json.JSONObject

class WidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return WidgetRemoteViewsFactory(applicationContext)
    }
}

class WidgetRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private var items = mutableListOf<WidgetItem>()
    private var activeIndex = -1

    override fun onCreate() {}

    override fun onDataSetChanged() {
        items.clear()
        activeIndex = -1

        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val jsonStr = prefs.getString("items", "[]") ?: "[]"

        try {
            val arr = JSONArray(jsonStr)
            // 找到当前进行中的任务
            var activeIdx = -1
            val allItems = mutableListOf<WidgetItem>()

            for (i in 0 until arr.length()) {
                val obj = arr.getJSONObject(i)
                val item = WidgetItem(
                    time = obj.getString("time"),
                    name = obj.getString("name"),
                    done = obj.getBoolean("done"),
                    active = obj.getBoolean("active"),
                    start = obj.getInt("start")
                )
                allItems.add(item)
                if (item.active) activeIdx = i
            }

            if (allItems.isEmpty()) return

            // 按 start 排序（确保时间顺序）
            allItems.sortBy { it.start }

            // 重新找 active 在排序后的位置
            activeIdx = allItems.indexOfFirst { it.active }

            if (activeIdx >= 0) {
                // 当前活动项放在中间位置
                val centerPos = allItems.size / 2
                // 计算需要的偏移
                val offset = centerPos - activeIdx

                // 添加空行填充，使活动项居中
                val paddingCount = if (offset > 0) offset else 0
                for (i in 0 until paddingCount) {
                    items.add(WidgetItem.empty())
                }

                // 添加所有项
                items.addAll(allItems)

                // 底部也添加对称的空行
                for (i in 0 until paddingCount) {
                    items.add(WidgetItem.empty())
                }
            } else {
                // 没有活动项，直接按时间排序显示
                items.addAll(allItems)
            }
        } catch (e: Exception) {
            // 解析失败
        }
    }

    override fun onDestroy() { items.clear() }
    override fun getCount(): Int = items.size

    override fun getViewAt(position: Int): RemoteViews {
        val item = items[position]

        // 空行（用于居中填充）
        if (item.isEmpty) {
            return RemoteViews(context.packageName, R.layout.widget_list_item).apply {
                setViewVisibility(R.id.item_icon, View.INVISIBLE)
                setTextViewText(R.id.item_time, "")
                setTextViewText(R.id.item_name, "")
                setViewVisibility(R.id.item_status, View.GONE)
            }
        }

        return RemoteViews(context.packageName, R.layout.widget_list_item).apply {
            // 图标
            if (item.active) {
                setImageViewResource(R.id.item_icon, android.R.drawable.ic_media_play)
            } else if (item.done) {
                setImageViewResource(R.id.item_icon, android.R.drawable.checkbox_on_background)
            } else {
                setImageViewResource(R.id.item_icon, android.R.drawable.checkbox_off_background)
            }

            setTextViewText(R.id.item_time, item.time)
            setTextViewText(R.id.item_name, item.name)

            // 进行中高亮
            if (item.active) {
                setInt(R.id.item_name, "setTextColor", 0xFF2196F3.toInt())
                setTextViewText(R.id.item_name, "▶ ${item.name}")
                setInt(R.id.item_time, "setTextColor", 0xFF2196F3.toInt())
            } else if (item.done) {
                setInt(R.id.item_name, "setTextColor", 0xFFAAAAAA.toInt())
                setInt(R.id.item_time, "setTextColor", 0xFFAAAAAA.toInt())
            } else {
                setInt(R.id.item_name, "setTextColor", 0xFF333333.toInt())
                setInt(R.id.item_time, "setTextColor", 0xFF999999.toInt())
            }
        }
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
}

data class WidgetItem(
    val time: String = "",
    val name: String = "",
    val done: Boolean = false,
    val active: Boolean = false,
    val start: Int = 0,
    val isEmpty: Boolean = false
) {
    companion object {
        fun empty() = WidgetItem(isEmpty = true)
    }
}
