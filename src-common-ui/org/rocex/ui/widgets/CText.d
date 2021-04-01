module org.rocex.ui.widgets.CText;

import std.regex;

import java.lang.all;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.rocex.ui.form.FieldProp;
import org.rocex.ui.widgets.IWidget;
import org.rocex.utils.StringHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2020-6-19 22:47:46
 ***************************************************************************/
public class CText : Text, IWidget
{
    private FieldProp prop;

    /***************************************************************************
     * @param parent
     * @param style
     * @author Rocex Wang
     * @since 2020-6-19 22:47:46
     ***************************************************************************/
    public this(Composite parent, int style)
    {
        super(parent, style);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#checkSubclass()
     * @author Rocex Wang
     * @since 2020-6-19 22:42:15
     ****************************************************************************/
    override protected void checkSubclass()
    {
    }

    /***************************************************************************
     * @param evt
     * @return String
     * @author Rocex Wang
     * @since 2019-6-13 22:19:56
     ***************************************************************************/
    protected String getNewValue(Event evt)
    {
        String strText = getText();

        return strText[0 .. evt.start] ~ evt.text ~ strText[evt.end .. $];
    }

    /***************************************************************************
     * @return the prop
     * @author Rocex Wang
     * @since 2020-6-19 22:29:55
     ***************************************************************************/
    public FieldProp getProp()
    {
        return prop;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#getValue()
     * @author Rocex Wang
     * @since 2020-6-19 22:52:11
     ****************************************************************************/
    override public Object getValue()
    {
        String strValue = getText();

        // todo
        // switch (getProp().getDataType())
        // {
        //  case FieldProp.datatype_double:
        //     return StringHelper.isNumber(strValue)
        //         ? Double.parseDouble(strValue) : cast(Double) null;
        // case FieldProp.datatype_integer:
        //     return StringHelper.isNumber(strValue)
        //         ? Integer.parseInt(strValue) : cast(Integer) null;
        // }

        return stringcast(strValue);
    }

    /***************************************************************************
     * @param prop the prop to set
     * @author Rocex Wang
     * @since 2020-6-19 22:29:55
     ***************************************************************************/
    public void setProp(FieldProp fieldProp)
    {
        this.prop = fieldProp;

        setTextLimit(fieldProp.getLength());

        Listener listener = new class Listener
        {
            void handleEvent(Event evt)
            {
                verifyData(evt);
            }
        };

        addListener(SWT.Verify, listener);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2020-6-19 22:52:11
     ****************************************************************************/
    override public void setValue(Object objValue)
    {
        setText(StringHelper.defaultString(objValue));
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2019-6-13 22:07:02
     ***************************************************************************/
    protected void verifyData(Event evt)
    {
        if (evt.text is null || evt.text.trim().length() == 0)
        {
            return;
        }

        switch (getProp().getDataType())
        {
        case FieldProp.datatype_double:
            evt.doit = verifyDouble(evt);
            break;
        case FieldProp.datatype_email:
            evt.doit = verifyEmail(evt);
            break;
        case FieldProp.datatype_integer:
            evt.doit = verifyInteger(evt);
            break;
        default:
            evt.doit = verifyString(evt);
            break;
        }
    }

    /***************************************************************************
     * @param evt
     * @return boolean
     * @author Rocex Wang
     * @since 2019-6-13 22:15:21
     ***************************************************************************/
    protected bool verifyDouble(Event evt)
    {
        // bool blDoit = stringcast(evt.text).matches("^(-?\\d+)(\\.\\d+)?$");
        auto blDoit = __traits(isFloating, evt.text);

        if (blDoit)
        {
            const double dblValue = Double.parseDouble(getNewValue(evt));

            if (dblValue < getProp().getMin() || dblValue > getProp().getMax())
            {
                blDoit = false;
            }
        }

        return blDoit;
    }

    /***************************************************************************
     * @param evt
     * @return boolean
     * @author Rocex Wang
     * @since 2019-6-13 22:17:13
     ***************************************************************************/
    protected bool verifyEmail(Event evt)
    {
        bool blDoit = StringHelper.isEmail(evt.text);

        if (blDoit)
        {
            String strNewValue = getNewValue(evt);

            if (strNewValue.length() > getProp().getLength())
            {
                blDoit = false;
            }
        }

        return blDoit;
    }

    /***************************************************************************
     * @param evt
     * @return boolean
     * @author Rocex Wang
     * @since 2019-6-13 22:15:57
     ***************************************************************************/
    protected bool verifyInteger(Event evt)
    {
        bool blDoit = StringHelper.isInteger(evt.text);

        if (blDoit)
        {
            const int iValue = Integer.parseInt(getNewValue(evt));

            if (iValue < getProp().getMin() || iValue > getProp().getMax())
            {
                blDoit = false;
            }
        }

        return blDoit;
    }

    /***************************************************************************
     * @param evt
     * @return boolean
     * @author Rocex Wang
     * @since 2019-6-13 22:23:24
     ***************************************************************************/
    protected bool verifyString(Event evt)
    {
        String strNewValue = getNewValue(evt);

        bool blDoit = true;

        if (strNewValue.length() > getProp().getLength())
        {
            blDoit = false;
        }

        return blDoit;
    }
}
