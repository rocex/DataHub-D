module ui.org.rocex.ui.form.CheckField;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-6-11 22:26:24
 ***************************************************************************/
public class CheckField(T) : Field!(bool)
{
    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-6-11 22:26:24
     ***************************************************************************/
    public this(Form parent, int iStyle)
    {
        super(parent, iStyle);

        Button control = new Button(this, SWT.CHECK);

        setControl(control);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#getControl()
     * @author Rocex Wang
     * @since 2019-6-11 22:15:12
     ****************************************************************************/
    override public Button getControl()
    {
        return cast(Button) super.getControl();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#getValue()
     * @author Rocex Wang
     * @since 2019-6-11 22:15:44
     ****************************************************************************/
    override public bool getValue()
    {
        return getControl().getSelection();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#setProp(org.rocex.ui.form.FieldProp)
     * @author Rocex Wang
     * @since 2019-6-13 22:45:04
     ****************************************************************************/
    override public CheckField setProp(FieldProp fieldProp)
    {
        return cast(CheckField) super.setProp(fieldProp);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.form.Field#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2019-6-11 22:15:49
     ****************************************************************************/
    override public void setValue(bool value)
    {
        super.setValue(value);

        if (value !is null && is(value == bool))
        {
            getControl().setSelection(value);
        }
    }
}
