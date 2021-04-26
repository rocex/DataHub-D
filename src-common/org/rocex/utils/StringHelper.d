module org.rocex.utils.StringHelper;

import std.algorithm;
import std.conv;
import std.datetime;
import std.string;
import std.regex;
import std.traits;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-6-4 21:24:28
 ***************************************************************************/
public class StringHelper
{
    // [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}
    private static string strRegexEmail = "\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";

    /** url regex */
    private static string strRegexUrl = r"(([h|H][t|T]|[f|F])[t|T][p|P]([s|S]?)\:\/\/|~/|/)?"
        ~ r"([\w]+:\w+@)?(([a-zA-Z]{1}([\w\-]+\.)+([\w]{2,5}))"
        ~ r"(:[\d]{1,5})?)?((/?\w+/)+|/?)"
        ~ r"(\w+\.[\w]{3,4})?([,]\w+)*((\?\w+=\w+)?(&\w+=\w+)*([,]\w*)*)?";

    /** */
    public static const string WHITESPACE = " \n\r\f\t";

    /***************************************************************************
     * 驼峰转下划线，例如：userName -> user_name
     * Params: strValue
     * Returns: 驼峰转下划线，例如：userName -> user_name
     * Authors: Rocex Wang
     * Date: 2019-10-25 21:59:29
     ***************************************************************************/
    public static string camelToUnderline(string strValue)
    {
        if (strValue is null || strip(strValue.idup()).length == 0)
        {
            return strValue;
        }

        string strResult = "";

        char[] chars = cast(char[]) strValue;

        auto gap = 'a' - 'A';

        const char ch0 = chars[0];
        strResult ~= (ch0 >= 'A' && ch0 <= 'Z') ? ("" ~ cast(char)(ch0 + gap)) : to!string(ch0);

        for (int i = 1; i < chars.length; i++)
        {
            const char ch = chars[i];
            strResult ~= (ch >= 'A' && ch <= 'Z') ? ("_" ~ cast(char)(ch + gap)) : to!string(ch);
        }

        return strResult;
    }

    /***************************************************************************
     * Params: objValue
     * Returns: string
     * Authors: Rocex Wang
     * Date: 2019-6-25 21:10:26
     ***************************************************************************/
    public static string defaultString(Object objValue)
    {
        return defaultString(objValue is null ? null : objValue.toString());
    }

    /***************************************************************************
     * Params: strValue
     * Returns: string
     * Authors: Rocex Wang
     * Date: 2019-6-4 21:37:12
     ***************************************************************************/
    public static string defaultString(string strValue)
    {
        return defaultString(strValue, "");
    }

    /***************************************************************************
     * Params: strValue
     * Params: strDefault
     * Returns: string
     * Authors: Rocex Wang
     * Date: 2019-6-4 21:37:09
     ***************************************************************************/
    public static string defaultString(string strValue, string strDefault)
    {
        return strValue is null ? strDefault : strValue;
    }

    /***************************************************************************
     * Params: object1
     * Params: object2
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2019-5-13 21:10:22
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
     * Params: strValue
     * Returns: 首字母变小写
     * Authors: Rocex Wang
     * Date: 2019-6-11 21:59:38
     * @see com.jfinal.kit.StrKit
     ***************************************************************************/
    public static string firstCharToLowerCase(string strValue)
    {
        const char firstChar = cast(char) strValue[0];

        if (firstChar >= 'A' && firstChar <= 'Z')
        {
            char[] chars = strValue.dup;
            chars[0] += 'a' - 'A';

            return idup(chars);
        }

        return strValue;
    }

    /***************************************************************************
     * Params: strValue
     * Returns: 首字母变大写
     * Authors: Rocex Wang
     * Date: 2019-6-11 21:59:51
     * @see com.jfinal.kit.StrKit
     ***************************************************************************/
    public static string firstCharToUpperCase(string strValue)
    {
        const char firstChar = strValue[0];

        if (firstChar >= 'a' && firstChar <= 'z')
        {
            char[] chars = cast(char[]) strValue;
            chars[0] -= 'a' - 'A';

            return idup(chars);
        }

        return strValue;
    }

    /*********************************************************************************************************
     * Params: strText
     * Returns: int 返回strSource的长度，以一个英文字符的长度为单位，汉字占两位
     * Date: 2004-7-7 21:21:57
     ********************************************************************************************************/
    public static int getLength(string strText)
    {
        return getLength(strText, false);
    }

    /*********************************************************************************************************
     * Params: strText
     * Params: blTrim
     * Returns: int 返回strSource的长度，以一个英文字符的长度为单位，汉字占两位
     * Date: 2004-7-7 21:21:57
     ********************************************************************************************************/
    public static int getLength(string strText, bool blTrim)
    {
        if (strText is null)
        {
            return 0;
        }

        if (blTrim)
        {
            strText = strip(strText.idup());
        }

        int iLength = 0;

        for (int i = 0; i < strText.length; i++)
        {
            const char strTemp = strText[i];

            iLength = iLength + (strTemp >= 0 && strTemp <= 255 ? 1 : 2);
        }

        return iLength;
    }

    /***************************************************************************
     * Returns: UUID.toString()
     * Authors: Rocex Wang
     * Date: 2019-8-6 21:19:55
     ***************************************************************************/
    public static string getUUID()
    {
        return to!string(Clock.currStdTime() / 10_000);
    }

    /***************************************************************************
     * strText is null  || strText.trim().length() == 0
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2020-6-4 21:43:56
     ***************************************************************************/
    public static bool isBlank(string strText)
    {
        return strText is null || strip(strText.idup()).length == 0;
    }

    /***************************************************************************
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2021-4-1 22:44:08
     ***************************************************************************/
    public static bool isDouble(string strText)
    {
        return isNumber(strText);
    }

    /***************************************************************************
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2021-4-1 22:43:02
     ***************************************************************************/
    public static bool isEmail(string strText)
    {
        return !isBlank(strText) && !match(strText, regex(strRegexEmail)).empty;
    }

    /***************************************************************************
     * strText is null  || strText.length() == 0
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2019-7-13 21:50:00
     ***************************************************************************/
    public static bool isEmpty(string strText)
    {
        return strText is null || strText.length == 0;
    }

    /***************************************************************************
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2021-4-1 22:43:37
     ***************************************************************************/
    public static bool isInteger(string strText)
    {
        return __traits(isIntegral, strText);
        // return !isBlank(strText) && !match(strText, regex("^-?\\d+$"));
    }

    /***************************************************************************
     * 判断字符串是否数字
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2020-6-22 21:00:14
     ***************************************************************************/
    public static bool isNumber(string strText)
    {
        return !isBlank(strText) && isNumeric(strText);
    }

    /***************************************************************************
     * Params: strText
     * Returns: bool
     * Authors: Rocex Wang
     * Date: 2021-4-1 22:45:04
     ***************************************************************************/
    public static bool isURL(string strText)
    {
        return !isBlank(strText) && !match(strText, regex(strRegexUrl));
    }

    /***************************************************************************
     * 下划线转驼峰，例如：user_name -> userName
     * Params: strValue
     * Returns: 下划线转驼峰，例如：user_name -> userName
     * Authors: Rocex Wang
     * Date: 2019-10-25 21:44:16
     ***************************************************************************/
    public static string underlineToCamel(string strValue)
    {
        if (strValue is null || strip(strValue.idup()).length == 0 || !strValue.indexOf("_") > -1)
        {
            return strValue;
        }

        auto strSplits = strValue.splitter("_");

        string strResult;

        foreach (string strSplit; strSplits)
        {
            strResult ~= (firstCharToUpperCase(strSplit));
        }

        return strResult;
    }
}
