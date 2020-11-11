module org.rocex.ui.form;

import java.lang.String;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2019-6-11 22:02:16
 ***************************************************************************/
public class FieldProp
{
    public static const String datatype_double = "double";
    public static const String datatype_email = "email";
    public static const String datatype_integer = "integer";
    public static const String datatype_string = "string";

    private bool blNullable = true;

    private double dblMax = 10000;
    private double dblMin = 0;

    private int iLength = 128;

    private String strDataType = datatype_string;

    private String strKey;
    private String strTitle;

    /***************************************************************************
     * @author Rocex Wang
     * @version 2019-6-11 22:33:56
     ***************************************************************************/
    public this()
    {
    }

    /***************************************************************************
     * @param strKey
     * @param strTitle
     * @author Rocex Wang
     * @version 2019-6-13 22:39:23
     ***************************************************************************/
    public this(String strKey, String strTitle)
    {
        this();

        this.strKey = strKey;
        this.strTitle = strTitle;
    }

    /***************************************************************************
     * @param strKey
     * @param strTitle
     * @param blNullable
     * @author Rocex Wang
     * @version 2019-6-13 22:24:22
     ***************************************************************************/
    public this(String strKey, String strTitle, bool blNullable)
    {
        this(strKey, strTitle);

        this.blNullable = blNullable;
    }

    /***************************************************************************
     * @param strKey
     * @param blNullable
     * @param strDataType
     * @param iLength
     * @author Rocex Wang
     * @version 2019-6-12 22:21:15
     ***************************************************************************/
    public this(String strKey, String strTitle, bool blNullable, String strDataType, int iLength)
    {
        this(strKey, strTitle, blNullable);

        this.iLength = iLength;
        this.strDataType = strDataType;
    }

    /***************************************************************************
     * @return the dataType
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public String getDataType()
    {
        return strDataType;
    }

    /***************************************************************************
     * @return the key
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public String getKey()
    {
        return strKey;
    }

    /***************************************************************************
     * @return the length
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public int getLength()
    {
        return iLength;
    }

    /***************************************************************************
     * @return the max
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public double getMax()
    {
        return dblMax;
    }

    /***************************************************************************
     * @return the min
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public double getMin()
    {
        return dblMin;
    }

    /***************************************************************************
     * @return the title
     * @author Rocex Wang
     * @version 2019-6-12 22:24:28
     ***************************************************************************/
    public String getTitle()
    {
        return strTitle;
    }

    /***************************************************************************
     * @return the nullable
     * @author Rocex Wang
     * @version 2019-6-12 22:17:11
     ***************************************************************************/
    public bool isNullable()
    {
        return blNullable;
    }

    /***************************************************************************
     * @param dataType the dataType to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setDataType(String dataType)
    {
        strDataType = dataType;

        return this;
    }

    /***************************************************************************
     * @param strKey the id to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setKey(String key)
    {
        strKey = key;

        return this;
    }

    /***************************************************************************
     * @param length the length to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setLength(int length)
    {
        iLength = length;

        return this;
    }

    /***************************************************************************
     * @param max the max to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setMax(double max)
    {
        dblMax = max;

        return this;
    }

    /***************************************************************************
     * @param min the min to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setMin(double min)
    {
        dblMin = min;

        return this;
    }

    /***************************************************************************
     * @param nullable the nullable to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-12 22:17:11
     ***************************************************************************/
    public FieldProp setNullable(bool nullable)
    {
        blNullable = nullable;

        return this;
    }

    /***************************************************************************
     * @param title the title to set
     * @return FieldProp
     * @author Rocex Wang
     * @version 2019-6-12 22:24:28
     ***************************************************************************/
    public FieldProp setTitle(String title)
    {
        strTitle = title;

        return this;
    }
}
