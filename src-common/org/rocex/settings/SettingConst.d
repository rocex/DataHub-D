module org.rocex.settings.SettingConst;

import std.path;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-23 21:49:03
 ***************************************************************************/
enum SettingConst
{
    /** 双击关闭页签 */
    close_tab_by_double_click = "close_tab_by_double_click",

    /** 配置文件目录 */
    dir_path_of_settings = "data" ~ dirSeparator,

    /** 运行的日志级别 */
    enable_log_level = "enable_log_level",

    /** 配置文件全路径 */
    file_path_of_settings = "data" ~ dirSeparator ~ "settings.ini",

    /** 启用的入口类全路径类名 */
    main_class = "main_class",

    /** Sash的宽度 */
    sash_width = "sash.width",

    /** 窗口宽 */
    window_width = "window_width",

    /** 窗口高 */
    window_heigth = "window_heigth",

    /** 工具类显示文本 */
    toolbar_show_text = "toolbar.show.text",

    /** 窗口是否最大化 */
    window_maximized = "window_maximized",
}
