module ui.org.rocex.ui.form.ComboField;

import org.rocex.ui.widgets.CCombo;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-6-11 22:28:43
 ***************************************************************************/
public class ComboField(T) : Field!(T)
{
    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-6-11 22:28:56
     ***************************************************************************/
    public this(Form parent, int iStyle)
    {
        super(parent, iStyle);

        CCombo!(T) control = new CCombo!T(this, iStyle);

        setControl(control);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#getControl()
     * @author Rocex Wang
     * @since 2019-6-11 22:15:12
     ****************************************************************************/
    override public CCombo getControl()
    {
        return cast(CCombo) super.getControl();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#getValue()
     * @author Rocex Wang
     * @since 2019-6-11 22:15:44
     ****************************************************************************/
    override public T getValue()
    {
        return getControl().getValue();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#setProp(org.rocex.ui.form.FieldProp)
     * @author Rocex Wang
     * @since 2019-6-13 22:45:51
     ****************************************************************************/
    override public ComboField setProp(FieldProp fieldProp)
    {
        super.setProp(fieldProp);

        getControl().setProp(fieldProp);

        return this;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2019-6-11 22:15:49
     ****************************************************************************/
    override public void setValue(T objValue)
    {
        super.setValue(objValue);

        getControl().setValue(objValue);
    }
}
