module org.rocex.ui.widgets.CompositeControl;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.rocex.ui.Context;
import org.rocex.utils.UIHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2019-5-28 22:54:10
 ***************************************************************************/
public abstract class CompositeControl : Composite
{
    private Context context;

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @version 2019-5-28 22:57:42
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, iStyle);

        context = UIHelper.getContext(parent);
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @version 2019-7-11 22:11:38
     ***************************************************************************/
    protected void fireEvent(Event evt)
    {
        getContext().fireEvent(evt);
    }

    /***************************************************************************
     * @return the context
     * @author Rocex Wang
     * @version 2020-6-1 22:56:29
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * @return Control
     * @author Rocex Wang
     * @version 2019-5-28 22:58:22
     ***************************************************************************/
    public abstract Control getControl();

    /***************************************************************************
     * @param context the context to set
     * @author Rocex Wang
     * @version 2020-6-1 22:56:29
     ***************************************************************************/
    public void setContext(Context context)
    {
        this.context = context;
    }
}
