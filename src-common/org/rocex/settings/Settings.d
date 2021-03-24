module org.rocex.settings.Settings;

import java.lang.all;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.SWT;
import org.rocex.settings.SettingConst;
import org.rocex.utils.FileHelper;
import org.rocex.utils.Logger;
import org.rocex.utils.Properties;
import org.rocex.utils.ResHelper;
import std.algorithm;
import std.conv;
import std.range;
import std.string;

/***************************************************************************
 * 系统参数设置中心，只保存有变化的参数值<br>
 * @author Rocex Wang
 * @since 2019-5-13 21:30:23
 ***************************************************************************/
public class Settings
{
    private static Properties properties = null;

    /** 原始数据，在load的时候加载，store之后重置成最新的，和 properties 做对比，以判断是否有变化 */
    private static Properties originalProperties = null;

    static this()
    {
        properties = new Properties();
        originalProperties = new Properties();
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-7-7 21:30:06
     ***************************************************************************/
    public static ~this()
    {
        properties.dispose();
        originalProperties.dispose();
    }

    /***************************************************************************
     * @param strKey
     * @param blDefaultValue
     * @return boolean
     * @author Rocex Wang
     * @since 2019-5-13 21:57:56
     ***************************************************************************/
    public static bool getBoolean(String strKey, bool blDefaultValue = false)
    {
        String strProperty = getValue(strKey, to!string(blDefaultValue)).toLower();

        if (strProperty is null)
        {
            return blDefaultValue;
        }

        return cmp("true", strProperty) == 0 || cmp("1", strProperty) == 0
            || cmp("yes", strProperty) == 0 || cmp("y", strProperty) == 0
            || cmp("on", strProperty) == 0;
    }

    /***************************************************************************
     * @param strKey
     * @param dblDefaultValue
     * @return double
     * @author Rocex Wang
     * @since 2019-5-21 21:36:06
     ***************************************************************************/
    public static double getDouble(String strKey, double dblDefaultValue)
    {
        String strProperty = getValue(strKey, to!string(dblDefaultValue));

        return isNumeric(strProperty) ? to!double(strProperty) : dblDefaultValue;
    }

    /***************************************************************************
     * @param strKey
     * @return Font
     * @author Rocex Wang
     * @since 2019-7-18 21:38:26
     ***************************************************************************/
    public static Font getFont(String strKey)
    {
        return getFont(strKey, null);
    }

    /***************************************************************************
     * @param strKey
     * @param defaultFont
     * @return Font
     * @author Rocex Wang
     * @since 2019-7-18 21:27:53
     ***************************************************************************/
    public static Font getFont(String strKey, Font defaultFont)
    {
        String strProperty = getValue(strKey, "");

        if (strProperty is null || strProperty.length() == 0)
        {
            return defaultFont;
        }

        auto split = splitter(strProperty, "|").filter!q{!a.empty}.array;

        if (split.empty)
        {
            return defaultFont;
        }

        const int iHeight = split.length > 1 ? to!int(split[1]) : 12;
        const int iStyle = split.length > 2 ? to!int(split[2]) : SWT.NORMAL;

        Font font = ResHelper.getFont(split[0], iHeight, iStyle);

        return font is null ? defaultFont : font;
    }

    /***************************************************************************
     * @param strKey
     * @param iDefaultValue
     * @return int
     * @author Rocex Wang
     * @since 2019-5-21 21:34:29
     ***************************************************************************/
    public static int getInt(String strKey, int iDefaultValue)
    {
        String strProperty = getValue(strKey, iDefaultValue.to!string);

        return isNumeric(strProperty) ? to!int(strProperty) : iDefaultValue;
    }

    /***************************************************************************
     * @param strKey
     * @param strDefaultValue
     * @return String
     * @author Rocex Wang
     * @since 2019-5-13 21:44:44
     ***************************************************************************/
    public static String getValue(String strKey, String strDefaultValue)
    {
        if (properties.isEmpty())
        {
            load();
        }

        auto strValue = properties.get(strKey);

        if (strValue is null)
        {
            return strDefaultValue;
        }

        return to!string(strValue);
    }

    /***************************************************************************
     * @return boolean 从文件中加载以来是否有变化，包括任何的 key、value、comment 的变化
     * @author Rocex Wang
     * @since 2021-2-4 22:51:31
     ***************************************************************************/
    public static bool isChangeFromLoad()
    {
        return !properties.equals(originalProperties);
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-21 22:09:32
     ***************************************************************************/
    public static void load()
    {
        properties.load(SettingConst.file_path_of_settings);

        originalProperties = properties.clone();
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-13 21:44:47
     ***************************************************************************/
    public static void save()
    {
        if (!isChangeFromLoad())
        {
            return;
        }

        properties.store(SettingConst.file_path_of_settings);

        originalProperties = properties.clone();

        Logger.getLogger.info("settings saved!");
    }

    /***************************************************************************
     * @param strKey
     * @param strValue
     * @author Rocex Wang
     * @since 2019-5-13 21:57:50
     ***************************************************************************/
    public static void setValue(String strKey, String strValue)
    {
        const String strProp = properties.get(strKey);

        if (equals(strProp, strValue))
        {
            return;
        }

        properties.put(strKey, strValue);
    }

    /***************************************************************************
     * @param strKey
     * @param blValue
     * @author Rocex Wang
     * @since 2020-08-06 21:15:28
     ***************************************************************************/
    public static void setValue(String strKey, bool blValue)
    {
        setValue(strKey, blValue ? "true" : "false");
    }

    /***************************************************************************
     * @param strKey
     * @param iValue
     * @author Rocex Wang
     * @since 2020-08-06 21:15:34
     ***************************************************************************/
    public static void setValue(String strKey, int iValue)
    {
        setValue(strKey, to!String(iValue));
    }

    /***************************************************************************
     * @param strKey
     * @param dblValue
     * @author Rocex Wang
     * @since 2021-03-23 21:25:34
     ***************************************************************************/
    public static void setValue(String strKey, double dblValue)
    {
        setValue(strKey, to!String(dblValue));
    }
}
