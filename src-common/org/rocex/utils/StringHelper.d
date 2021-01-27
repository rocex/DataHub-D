module org.rocex.utils.StringHelper;

import java.lang.all;
import java.math.BigDecimal;
import std.algorithm;
import std.conv;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-6-4 21:24:28
 ***************************************************************************/
public class StringHelper
{
    /** */
    public static const String WHITESPACE = " \n\r\f\t";

    /***************************************************************************
     * 驼峰转下划线，例如：userName -> user_name
     * @param strValue
     * @return 驼峰转下划线，例如：userName -> user_name
     * @author Rocex Wang
     * @since 2019-10-25 21:59:29
     ***************************************************************************/
    public static String camelToUnderline(String strValue)
    {
        if (strValue is null || strValue.trim().length() == 0)
        {
            return strValue;
        }

        String strResult = "";

        char[] chars = strValue.toCharArray();

        foreach (char ch; chars)
        {
            strResult ~= (ch >= 'A' && ch <= 'Z') ? ("_" ~ cast(char)(ch + ('a' - 'A'))) : to!String(ch);
        }

        return strResult;
    }

    /***************************************************************************
     * @param objValue
     * @return String
     * @author Rocex Wang
     * @since 2019-6-25 21:10:26
     ***************************************************************************/
    public static String defaultString(Object objValue)
    {
        return defaultString(objValue is null ? null : objValue.toString());
    }

    /***************************************************************************
     * @param strValue
     * @return String
     * @author Rocex Wang
     * @since 2019-6-4 21:37:12
     ***************************************************************************/
    public static String defaultString(String strValue)
    {
        return defaultString(strValue, "");
    }

    /***************************************************************************
     * @param strValue
     * @param strDefault
     * @return String
     * @author Rocex Wang
     * @since 2019-6-4 21:37:09
     ***************************************************************************/
    public static String defaultString(String strValue, String strDefault)
    {
        return strValue is null ? strDefault : strValue;
    }

    /***************************************************************************
     * @param object1
     * @param object2
     * @return boolean
     * @author Rocex Wang
     * @since 2019-5-13 21:10:22
     ***************************************************************************/
    public static bool equals(Object object1, Object object2)
    {
        if (object1 == object2)
        {
            return true;
        }

        if (object1 is null || object2 is null)
        {
            return false;
        }

        return object1.opEquals(object2);
    }

    /***************************************************************************
     * @param strValue
     * @return 首字母变小写
     * @author Rocex Wang
     * @since 2019-6-11 21:59:38
     * @see com.jfinal.kit.StrKit
     ***************************************************************************/
    public static String firstCharToLowerCase(String strValue)
    {
        const char firstChar = strValue.charAt(0);

        if (firstChar >= 'A' && firstChar <= 'Z')
        {
            char[] chars = strValue.dup;
            chars[0] += 'a' - 'A';

            return _idup(chars);
        }

        return strValue;
    }

    /***************************************************************************
     * @param strValue
     * @return 首字母变大写
     * @author Rocex Wang
     * @since 2019-6-11 21:59:51
     * @see com.jfinal.kit.StrKit
     ***************************************************************************/
    public static String firstCharToUpperCase(String strValue)
    {
        const char firstChar = strValue.charAt(0);

        if (firstChar >= 'a' && firstChar <= 'z')
        {
            char[] chars = strValue.toCharArray();
            chars[0] -= 'a' - 'A';

            return _idup(chars);
        }

        return strValue;
    }

    /*********************************************************************************************************
     * @param strSource
     * @return int 返回strSource的长度，以一个英文字符的长度为单位，汉字占两位
     * @since 2004-7-7 21:21:57
     ********************************************************************************************************/
    public static int getLength(String strSource)
    {
        return getLength(strSource, false);
    }

    /*********************************************************************************************************
     * @param strSource
     * @param blTrim
     * @return int 返回strSource的长度，以一个英文字符的长度为单位，汉字占两位
     * @since 2004-7-7 21:21:57
     ********************************************************************************************************/
    public static int getLength(String strSource, bool blTrim)
    {
        if (strSource is null)
        {
            return 0;
        }

        if (blTrim)
        {
            strSource = strSource.trim();
        }

        int iLength = 0;

        for (int i = 0; i < strSource.length(); i++)
        {
            const char strTemp = strSource.charAt(i);

            iLength = iLength + (strTemp >= 0 && strTemp <= 255 ? 1 : 2);
        }

        return iLength;
    }

    /***************************************************************************
     * @return UUID.toString()
     * @author Rocex Wang
     * @since 2019-8-6 21:19:55
     ***************************************************************************/
    public static String getUUID()
    {
        return to!String(System.currentTimeMillis());
    }

    /***************************************************************************
     * strSource is null  || strSource.trim().length() == 0
     * @param strSource
     * @return boolean
     * @author Rocex Wang
     * @since 2020-6-4 21:43:56
     ***************************************************************************/
    public static bool isBlank(String strSource)
    {
        return strSource is null || strSource.trim().length() == 0;
    }

    /***************************************************************************
     * strSource is null  || strSource.length() == 0
     * @param strSource
     * @return boolean
     * @author Rocex Wang
     * @since 2019-7-13 21:50:00
     ***************************************************************************/
    public static bool isEmpty(String strSource)
    {
        return strSource is null || strSource.length() == 0;
    }

    /***************************************************************************
     * 判断字符串是否数字
     * @param strSource
     * @return boolean
     * @author Rocex Wang
     * @since 2020-6-22 21:00:14
     ***************************************************************************/
    public static bool isNumber(String strSource)
    {
        try
        {
            new BigDecimal(strSource);
        }
        catch (Exception ex)
        {
            return false;
        }

        return true;
    }

    /***************************************************************************
     * 下划线转驼峰，例如：user_name -> userName
     * @param strValue
     * @return 下划线转驼峰，例如：user_name -> userName
     * @author Rocex Wang
     * @since 2019-10-25 21:44:16
     ***************************************************************************/
    public static String underlineToCamel(String strValue)
    {
        if (strValue is null || strValue.trim().length() == 0 || !strValue.indexOf("_") > -1)
        {
            return strValue;
        }

        auto strSplits = strValue.splitter("_");

        String strResult;

        foreach (String strSplit; strSplits)
        {
            strResult ~= (firstCharToUpperCase(strSplit));
        }

        return strResult;
    }
}
