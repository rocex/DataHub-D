module org.rocex.ui.widgets.CompositeControl;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.rocex.ui.Context;
import org.rocex.ui.utils.UIHelper;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-28 22:54:10
 ***************************************************************************/
public abstract class CompositeControl : Composite
{
    private Context context;

    /***************************************************************************
     * Params: parent
     * Params: iStyle
     * Authors: Rocex Wang
     * Date: 2019-5-28 22:57:42
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, iStyle);

        context = UIHelper.getContext(parent);
    }

    /***************************************************************************
     * Params: evt
     * Authors: Rocex Wang
     * Date: 2019-7-11 22:11:38
     ***************************************************************************/
    protected void fireEvent(Event evt)
    {
        getContext().fireEvent(evt);
    }

    /***************************************************************************
     * Returns: the context
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:56:29
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * Returns: Control
     * Authors: Rocex Wang
     * Date: 2019-5-28 22:58:22
     ***************************************************************************/
    public abstract Control getControl();

    /***************************************************************************
     * Params: context the context to set
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:56:29
     ***************************************************************************/
    public void setContext(Context context)
    {
        this.context = context;
    }
}
