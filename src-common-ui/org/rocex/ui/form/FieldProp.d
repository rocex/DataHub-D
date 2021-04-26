module org.rocex.ui.form.FieldProp;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-6-11 22:02:16
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
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:33:56
     ***************************************************************************/
    public this()
    {
    }

    /***************************************************************************
     * Params: strKey
     * Params: strTitle
     * Authors: Rocex Wang
     * Date: 2019-6-13 22:39:23
     ***************************************************************************/
    public this(string strKey, string strTitle)
    {
        this();

        this.strKey = strKey;
        this.strTitle = strTitle;
    }

    /***************************************************************************
     * Params: strKey
     * Params: strTitle
     * Params: blNullable
     * Authors: Rocex Wang
     * Date: 2019-6-13 22:24:22
     ***************************************************************************/
    public this(string strKey, string strTitle, bool blNullable)
    {
        this(strKey, strTitle);

        this.blNullable = blNullable;
    }

    /***************************************************************************
     * Params: strKey
     * Params: blNullable
     * Params: strDataType
     * Params: iLength
     * Authors: Rocex Wang
     * Date: 2019-6-12 22:21:15
     ***************************************************************************/
    public this(string strKey, string strTitle, bool blNullable, string strDataType, int iLength)
    {
        this(strKey, strTitle, blNullable);

        this.iLength = iLength;
        this.strDataType = strDataType;
    }

    /***************************************************************************
     * Returns: the dataType
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public string getDataType()
    {
        return strDataType;
    }

    /***************************************************************************
     * Returns: the key
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public string getKey()
    {
        return strKey;
    }

    /***************************************************************************
     * Returns: the length
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public int getLength()
    {
        return iLength;
    }

    /***************************************************************************
     * Returns: the max
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public double getMax()
    {
        return dblMax;
    }

    /***************************************************************************
     * Returns: the min
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public double getMin()
    {
        return dblMin;
    }

    /***************************************************************************
     * Returns: the title
     * Authors: Rocex Wang
     * Date: 2019-6-12 22:24:28
     ***************************************************************************/
    public string getTitle()
    {
        return strTitle;
    }

    /***************************************************************************
     * Returns: the nullable
     * Authors: Rocex Wang
     * Date: 2019-6-12 22:17:11
     ***************************************************************************/
    public bool isNullable()
    {
        return blNullable;
    }

    /***************************************************************************
     * Params: dataType the dataType to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setDataType(string dataType)
    {
        strDataType = dataType;

        return this;
    }

    /***************************************************************************
     * Params: strKey the id to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setKey(string key)
    {
        strKey = key;

        return this;
    }

    /***************************************************************************
     * Params: length the length to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setLength(int length)
    {
        iLength = length;

        return this;
    }

    /***************************************************************************
     * Params: max the max to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setMax(double max)
    {
        dblMax = max;

        return this;
    }

    /***************************************************************************
     * Params: min the min to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-11 22:28:40
     ***************************************************************************/
    public FieldProp setMin(double min)
    {
        dblMin = min;

        return this;
    }

    /***************************************************************************
     * Params: nullable the nullable to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-12 22:17:11
     ***************************************************************************/
    public FieldProp setNullable(bool nullable)
    {
        blNullable = nullable;

        return this;
    }

    /***************************************************************************
     * Params: title the title to set
     * Returns: FieldProp
     * Authors: Rocex Wang
     * Date: 2019-6-12 22:24:28
     ***************************************************************************/
    public FieldProp setTitle(string title)
    {
        strTitle = title;

        return this;
    }
}
