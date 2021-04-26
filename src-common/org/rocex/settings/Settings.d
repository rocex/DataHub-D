module org.rocex.settings.Settings;

import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.SWT;
import org.rocex.settings.SettingConst;
import org.rocex.utils.Logger;
import org.rocex.utils.Properties;
import org.rocex.utils.ResHelper;
import std.algorithm;
import std.conv;
import std.range;
import std.string;

/***************************************************************************
 * 系统参数设置中心，只保存有变化的参数值<br>
 * Authors: Rocex Wang
 * Date: 2019-5-13 21:30:23
 ***************************************************************************/
public class Settings
{
    private static Properties properties = null;

    /** 原始数据，在load的时候加载，store之后重置成最新的，和 properties 做对比，以判断是否有变化 */
    private static Properties originalProperties = null;

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2020-7-7 21:30:06
     ***************************************************************************/
    static this()
    {
        properties = new Properties();
        originalProperties = new Properties();
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2020-7-7 21:30:06
     ***************************************************************************/
    public static ~this()
    {
        properties.dispose();
        originalProperties.dispose();
    }

    /***************************************************************************
     * Params: strKey
     * Params: blDefaultValue
     * Returns: boolean
     * Authors: Rocex Wang
     * Date: 2019-5-13 21:57:56
     ***************************************************************************/
    public static bool getBoolean(string strKey, bool blDefaultValue = false)
    {
        string strProperty = getValue(strKey, to!string(blDefaultValue)).toLower();

        if (strProperty is null)
        {
            return blDefaultValue;
        }

        return cmp("true", strProperty) == 0 || cmp("1", strProperty) == 0
            || cmp("yes", strProperty) == 0 || cmp("y", strProperty) == 0
            || cmp("on", strProperty) == 0;
    }

    /***************************************************************************
     * Params: strKey
     * Params: dblDefaultValue
     * Returns: double
     * Authors: Rocex Wang
     * Date: 2019-5-21 21:36:06
     ***************************************************************************/
    public static double getDouble(string strKey, double dblDefaultValue)
    {
        string strProperty = getValue(strKey, to!string(dblDefaultValue));

        return isNumeric(strProperty) ? to!double(strProperty) : dblDefaultValue;
    }

    /***************************************************************************
     * Params: strKey
     * Returns: Font
     * Authors: Rocex Wang
     * Date: 2019-7-18 21:38:26
     ***************************************************************************/
    public static Font getFont(string strKey)
    {
        return getFont(strKey, null);
    }

    /***************************************************************************
     * Params: strKey
     * Params: defaultFont
     * Returns: Font
     * Authors: Rocex Wang
     * Date: 2019-7-18 21:27:53
     ***************************************************************************/
    public static Font getFont(string strKey, Font defaultFont)
    {
        string strProperty = getValue(strKey, "");

        if (strProperty is null || strProperty.length == 0)
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
     * Params: strKey
     * Params: iDefaultValue
     * Returns: int
     * Authors: Rocex Wang
     * Date: 2019-5-21 21:34:29
     ***************************************************************************/
    public static int getInt(string strKey, int iDefaultValue = 0)
    {
        string strProperty = getValue(strKey, iDefaultValue.to!string);

        return isNumeric(strProperty) ? to!int(strProperty) : iDefaultValue;
    }

    /***************************************************************************
     * Params: strKey
     * Params: strDefaultValue
     * Returns: string
     * Authors: Rocex Wang
     * Date: 2019-5-13 21:44:44
     ***************************************************************************/
    public static string getValue(string strKey, string strDefaultValue = null)
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
     * Returns: boolean 从文件中加载以来是否有变化，包括任何的 key、value、comment 的变化
     * Authors: Rocex Wang
     * Date: 2021-2-4 22:51:31
     ***************************************************************************/
    public static bool isChangeFromLoad()
    {
        return !properties.equals(originalProperties);
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:09:32
     ***************************************************************************/
    public static void load()
    {
        properties.load(SettingConst.file_path_of_settings);

        originalProperties = properties.clone();
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-13 21:44:47
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
     * Params: strKey
     * Params: strValue
     * Authors: Rocex Wang
     * Date: 2019-5-13 21:57:50
     ***************************************************************************/
    public static void setValue(string strKey, string strValue)
    {
        properties.put(strKey, strValue);
    }

    /***************************************************************************
     * Params: strKey
     * Params: blValue
     * Authors: Rocex Wang
     * Date: 2020-08-06 21:15:28
     ***************************************************************************/
    public static void setValue(string strKey, bool blValue)
    {
        setValue(strKey, blValue ? "true" : "false");
    }

    /***************************************************************************
     * Params: strKey
     * Params: iValue
     * Authors: Rocex Wang
     * Date: 2020-08-06 21:15:34
     ***************************************************************************/
    public static void setValue(string strKey, int iValue)
    {
        setValue(strKey, to!string(iValue));
    }

    /***************************************************************************
     * Params: strKey
     * Params: dblValue
     * Authors: Rocex Wang
     * Date: 2021-03-23 21:25:34
     ***************************************************************************/
    public static void setValue(string strKey, double dblValue)
    {
        setValue(strKey, to!string(dblValue));
    }
}
