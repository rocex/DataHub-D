module ui.org.rocex.ui.form.Form;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.rocex.ui.utils.UIHelper;
import org.rocex.ui.widgets.CompositeControl;
import org.rocex.ui.widgets.IWidget;
import org.rocex.utils.Logger;
import org.rocex.utils.StringHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-27 22:59:58
 ***************************************************************************/
public class Form(T) : CompositeControl, IWidget!(T)
{
    /** 自适应布局，尽量不出现横向滚动条 */
    public static int auto_layout = 100;

    private Composite composite;

    private int iMaxWidth = cast(int)(Field.field_width * 0.4);

    private ScrolledComposite scrolledComposite;

    private T superVO;

    private Listener listener = new class Listener
    {
        void handleEvent(Event evt)
        {
            autoLayout(evt);
        }
    };

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-5-30 22:57:12
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        this(parent, iStyle, 3);
    }

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @param iFieldColumns Form中有多少列，非自适应情况下，以固定列数显示
     * @author Rocex Wang
     * @since 2019-5-27 22:19:33
     ***************************************************************************/
    public this(Composite parent, int iStyle, int iFieldColumns)
    {
        super(parent, SWT.NONE | iStyle);

        setLayout(new FillLayout());

        scrolledComposite = new ScrolledComposite(this, SWT.H_SCROLL | SWT.V_SCROLL);
        scrolledComposite.setExpandVertical(true);
        scrolledComposite.setExpandHorizontal(true);

        GridLayout gridLayout = new GridLayout(iFieldColumns, true);
        gridLayout.marginWidth = 3;
        gridLayout.marginHeight = 3;
        gridLayout.verticalSpacing = 3;
        gridLayout.horizontalSpacing = 3;

        composite = new Composite(scrolledComposite, SWT.NONE);
        composite.setLayout(gridLayout);

        scrolledComposite.setContent(composite);
        scrolledComposite.setMinSize(composite.computeSize(SWT.DEFAULT, SWT.DEFAULT));

        this.setAutoLayout((iStyle & auto_layout) != 0);

        superVO = new T;
    }

    /***************************************************************************
     * @param strTitle
     * @return Field
     * @author Rocex Wang
     * @since 2019-5-30 22:14:49
     ***************************************************************************/
    Field addField(String strTitle)
    {
        const int iTitleWidth = UIHelper.getTitleWidth(strTitle);

        if (iTitleWidth > iMaxWidth)
        {
            iMaxWidth = iTitleWidth;
        }

        if (iTitleWidth > Field.field_width * 0.5)
        {
            iMaxWidth = cast(int)(Field.field_width * 0.5);
        }

        return new Field(this, SWT.NONE);
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-28 22:05:15
     * @param evt
     ***************************************************************************/
    protected void autoLayout(Event evt)
    {
        if ((getStyle() & auto_layout) == 0)
        {
            scrolledComposite.setMinSize(composite.computeSize(SWT.DEFAULT, SWT.DEFAULT));
        }
        else
        {
            pack2();

            const Point parentSize = composite.getSize();

            int col = parentSize.x / (Field.field_width + 20);

            if (col < 1)
            {
                col = 1;
            }

            if (col != (cast(GridLayout) composite.getLayout()).numColumns)
            {
                composite.setLayout(new GridLayout(col, true));

                scrolledComposite.setMinSize(composite.computeSize(SWT.DEFAULT, SWT.DEFAULT));
            }
        }
    }

    /***************************************************************************
     * @return Composite
     * @author Rocex Wang
     * @since 2019-5-28 22:57:19
     ***************************************************************************/
    override public Composite getControl()
    {
        return composite;
    }

    /***************************************************************************
     * @param strKey
     * @return Field
     * @author Rocex Wang
     * @since 2019-6-11 22:34:47
     ***************************************************************************/
    public Field getField(String strKey)
    {
        Control[] controls = composite.getChildren();

        foreach (Control control; controls)
        {
            if (!(control == Field))
            {
                continue;
            }

            Field field = cast(Field) control;

            if (StringHelper.equals(strKey, field.getKey()))
            {
                return field;
            }
        }

        return null;
    }

    /***************************************************************************
     * @return SuperVO
     * @author Rocex Wang
     * @since 2019-6-11 22:42:10
     ***************************************************************************/
    override public T getValue()
    {
        return getValue(true);
    }

    /***************************************************************************
     * @param blCheckValid 是否校验数据合法性
     * @return SuperVO
     * @author Rocex Wang
     * @since 2019-6-29 22:37:28
     ***************************************************************************/
    public T getValue(bool blCheckValid)
    {
        Control[] controls = composite.getChildren();

        String strMsg = "";

        T newSuperVO = cast(T) superVO.clone();

        foreach (Control control; controls)
        {
            if (!(control == Field))
            {
                continue;
            }

            Field field = cast(Field) control;

            Object objValue = field.getValue();

            if (blCheckValid && !field.getProp().isNullable()
                    && (objValue is null || objValue.toString().trim().length() == 0))
            {
                strMsg += ", " ~ field.getTitle();
            }
            else
            {
                newSuperVO.setValue(field.getKey(), objValue);
            }
        }

        if (strMsg.trim().length() > 0)
        {
            throw new RuntimeException("[" ~ strMsg.substring(2) ~ "] 不能为空！");
        }

        return newSuperVO;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Composite#layout(boolean, boolean)
     * @author Rocex Wang
     * @since 2019-5-30 22:00:31
     ****************************************************************************/
    override public void layout(bool changed, bool all)
    {
        pack2();

        super.layout(changed, all);
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-30 22:17:11
     ***************************************************************************/
    public void pack2()
    {
        if (iMaxWidth != 0)
        {
            Control[] controls = composite.getChildren();

            foreach (Control control; controls)
            {
                GridData layoutData = cast(GridData)((cast(Field) control)
                        .getLabel().getLayoutData());
                layoutData.widthHint = iMaxWidth;
            }
        }
    }

    /***************************************************************************
     * @param blAutoLayout
     * @author Rocex Wang
     * @since 2019-5-28 22:01:49
     ***************************************************************************/
    protected void setAutoLayout(bool blAutoLayout)
    {
        if (blAutoLayout)
        {
            composite.addListener(SWT.Paint, listener);
        }
        else
        {
            composite.removeListener(SWT.Paint, listener);
        }
    }

    /***************************************************************************
     * @param superVO
     * @author Rocex Wang
     * @since 2019-6-11 22:42:36
     ***************************************************************************/
    override public void setValue(T superVO)
    {
        if (superVO is null)
        {
            return;
        }

        this.superVO = superVO;

        Control[] controls = composite.getChildren();

        foreach (Control control; controls)
        {
            if (!(control == Field))
            {
                continue;
            }

            Field field = cast(Field) control;

            field.setValue(superVO.getValue(field.getKey()));
        }
    }
}
