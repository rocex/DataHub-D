module org.rocex.ui.form.TextField;

import org.rocex.ui.widgets.CText;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-6-11 22:56:34
 ***************************************************************************/
public class TextField(T) : Field!(T)
{
    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-6-11 22:56:34
     ***************************************************************************/
    public this(Form parent, int iStyle)
    {
        super(parent, iStyle);

        CText!(T) text = new CText!T(this, iStyle);

        setControl(text);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#getControl()
     * @author Rocex Wang
     * @since 2019-6-11 22:12:35
     ****************************************************************************/
    override public CText!(T) getControl()
    {
        return cast(CText!(T)) super.getControl();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#getValue()
     * @author Rocex Wang
     * @since 2019-6-11 22:12:10
     ****************************************************************************/
    override public T getValue()
    {
        return getControl().getValue();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#setProp(org.rocex.ui.form.FieldProp)
     * @author Rocex Wang
     * @since 2019-6-11 22:27:05
     ****************************************************************************/
    override public TextField!(T) setProp(FieldProp fieldProp)
    {
        super.setProp(fieldProp);

        getControl().setProp(fieldProp);

        return this;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2019-6-11 22:12:10
     ****************************************************************************/
    override public void setValue(T objValue)
    {
        super.setValue(objValue);

        getControl().setValue(objValue);
    }
}
