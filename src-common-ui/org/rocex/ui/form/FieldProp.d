module org.rocex.ui.form.FieldProp;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-6-11 22:02:16
 ***************************************************************************/
public class FieldProp
{
    /** */
    public static const string datatype_double = "double";

    /** */
    public static const string datatype_email = "email";

    /** */
    public static const string datatype_integer = "integer";

    /** */
    public static const string datatype_string = "string";

    private bool blNullable = true;

    private double dblMax = 10_000;
    private double dblMin = 0;

    private int iLength = 128;

    private string strDataType = datatype_string;

    private string strKey;
    private string strTitle;

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-6-11 22:33:56
     ***************************************************************************/
    public this()
    {
    }

    /***************************************************************************
     * @param strKey
     * @param strTitle
     * @author Rocex Wang
     * @since 2019-6-13 22:39:23
     ***************************************************************************/
    public this(string strKey, string strTitle)
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
     * @since 2019-6-13 22:24:22
     ***************************************************************************/
    public this(string strKey, string strTitle, bool blNullable)
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
     * @since 2019-6-12 22:21:15
     ***************************************************************************/
    public this(string strKey, string strTitle, bool blNullable, string strDataType, int iLength)
    {
        this(strKey, strTitle, blNullable);

        this.iLength = iLength;
        this.strDataType = strDataType;
    }

    /***************************************************************************
     * @return the dataType
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public string getDataType()
    {
        return strDataType;
    }

    /***************************************************************************
     * @return the key
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public string getKey()
    {
        return strKey;
    }

    /***************************************************************************
     * @return the length
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public int getLength()
    {
        return iLength;
    }

    /***************************************************************************
     * @return the max
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public double getMax()
    {
        return dblMax;
    }

    /***************************************************************************
     * @return the min
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public double getMin()
    {
        return dblMin;
    }

    /***************************************************************************
     * @return the title
     * @author Rocex Wang
     * @since 2019-6-12 22:24:28
     ***************************************************************************/
    public string getTitle()
    {
        return strTitle;
    }

    /***************************************************************************
     * @return the nullable
     * @author Rocex Wang
     * @since 2019-6-12 22:17:11
     ***************************************************************************/
    public bool isNullable()
    {
        return blNullable;
    }

    /***************************************************************************
     * @param dataType the dataType to set
     * @return FieldProp
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setDataType(string dataType)
    {
        strDataType = dataType;

        return this;
    }

    /***************************************************************************
     * @param strKey the id to set
     * @return FieldProp
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setKey(string key)
    {
        strKey = key;

        return this;
    }

    /***************************************************************************
     * @param length the length to set
     * @return FieldProp
     * @author Rocex Wang
     * @since 2019-6-11 22:28:40
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
     * @since 2019-6-11 22:28:40
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
     * @since 2019-6-11 22:28:40
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
     * @since 2019-6-12 22:17:11
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
     * @since 2019-6-12 22:24:28
     ***************************************************************************/
    public FieldProp setTitle(string title)
    {
        strTitle = title;

        return this;
    }
}
