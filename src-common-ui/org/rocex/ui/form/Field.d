module ui.org.rocex.ui.form.Field;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.rocex.ui.widgets.CompositeControl;
import org.rocex.ui.widgets.IWidget;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-27 22:55:58
 ***************************************************************************/
public class Field(T) : CompositeControl, IWidget!(T)
{
    public static int field_width = 270;

    private Control control;

    private FieldProp fieldProp;

    private int iWidth = field_width;

    private Label label;

    private T objValue;

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-5-27 22:55:59
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(is(parent == Form) ? (cast(Form) parent).getControl() : parent, SWT.NONE);

        setLayout(new GridLayout(2, false));

        GridData gridData = new GridData(SWT.FILL, SWT.FILL, true, false);
        gridData.widthHint = field_width;
        setLayoutData(gridData);

        GridData gridDataLabel = new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1);
        gridDataLabel.widthHint = cast(int)(field_width * 0.4);

        label = new Label(this, SWT.RIGHT);
        label.setLayoutData(gridDataLabel);
        label.setText("");
        label.setToolTipText(label.getText());
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * @author Rocex Wang
     * @since 2020-7-4 22:22:49
     ****************************************************************************/
    override public void dispose()
    {
        ResHelper.dispose(control, label);

        fieldProp = null;
        objValue = null;

        super.dispose();
    }

    /***************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.CompositeControl#getControl()
     * @author Rocex Wang
     * @since 2019-5-27 22:10:53
     ***************************************************************************/
    override public Control getControl()
    {
        return control;
    }

    /***************************************************************************
     * @return the key
     * @author Rocex Wang
     * @since 2019-6-12 22:09:56
     ***************************************************************************/
    public String getKey()
    {
        return getProp().getKey();
    }

    /***************************************************************************
     * @return the label
     * @author Rocex Wang
     * @since 2019-5-30 22:51:55
     ***************************************************************************/
    public Label getLabel()
    {
        return label;
    }

    /***************************************************************************
     * @return FieldProp
     * @author Rocex Wang
     * @since 2019-6-11 22:33:13
     ***************************************************************************/
    public FieldProp getProp()
    {
        if (fieldProp is null)
        {
            fieldProp = new FieldProp();
        }

        return fieldProp;
    }

    /***************************************************************************
     * @return
     * @author Rocex Wang
     * @since 2019-5-27 22:10:55
     ***************************************************************************/
    public String getTitle()
    {
        return label is null || label.isDisposed() ? "" : label.getText();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#getValue()
     * @author Rocex Wang
     * @since 2019-6-11 22:31:31
     ****************************************************************************/
    override public T getValue()
    {
        return objValue;
    }

    /***************************************************************************
     * @return the width
     * @author Rocex Wang
     * @since 2019-5-28 22:47:04
     ***************************************************************************/
    public int getWidth()
    {
        return iWidth;
    }

    /***************************************************************************
     * @param control
     * @author Rocex Wang
     * @since 2019-5-27 22:15:12
     ***************************************************************************/
    public void setControl(Control control)
    {
        GridData gridData = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
        gridData.widthHint = cast(int)(field_width * 0.6);
        control.setLayoutData(gridData);

        this.control = control;
    }

    /***************************************************************************
     * @param fieldProp
     * @author Rocex Wang
     * @since 2019-6-11 22:34:02
     ***************************************************************************/
    public Field setProp(FieldProp fieldProp)
    {
        if (fieldProp is null)
        {
            return this;
        }

        this.fieldProp = fieldProp;

        if (fieldProp.getTitle() !is null)
        {
            label.setText(fieldProp.getTitle());
        }

        if (!fieldProp.isNullable())
        {
            label.setForeground(Display.getDefault().getSystemColor(SWT.COLOR_RED));

            getControl().addListener(SWT.Modify, evt => {
                label.setForeground(ResHelper.getColor(getValue() is null
                    || getValue().toString().trim().length() == 0 ? SWT.COLOR_RED : SWT.COLOR_BLACK));
            });
        }

        return this;
    }

    /***************************************************************************
     * @param strText
     * @author Rocex Wang
     * @since 2019-5-27 22:08:25
     ***************************************************************************/
    public void setTitle(String strText)
    {
        getProp().setTitle(strText);

        if (label !is null && !label.isDisposed())
        {
            label.setText(strText);
            label.setToolTipText(strText);
        }
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2019-6-11 22:31:09
     ****************************************************************************/
    override public void setValue(T objValue)
    {
        this.objValue = objValue;
    }

    /***************************************************************************
     * @param control
     * @param iWidth
     * @author Rocex Wang
     * @since 2019-5-28 22:51:36
     ***************************************************************************/
    protected void setWidth(Control control, int iWidth)
    {
        if (control is null || control.isDisposed())
        {
            return;
        }

        GridData gridData = cast(GridData) control.getLayoutData();
        gridData.widthHint = iWidth;
        control.setLayoutData(gridData);
    }

    /***************************************************************************
     * @param width the width to set
     * @author Rocex Wang
     * @since 2019-5-28 22:47:04
     ***************************************************************************/
    public void setWidth(int width)
    {
        iWidth = width;

        setWidth(this, iWidth);
        setWidth(label, cast(int)(iWidth * 0.4));
        setWidth(control, cast(int)(iWidth * 0.6));
    }
}
