module org.rocex.ui.action.LongAction;

import org.eclipse.swt.widgets.Event;

import org.rocex.ui.action.Action;
import org.rocex.ui.action.LongTask;


/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2020-6-17 22:03:46
 ***************************************************************************/
public abstract class LongAction : Action
{
    /***************************************************************************
     * @param strId
     * @author Rocex Wang
     * @since 2020-6-17 22:03:46
     ***************************************************************************/
    public this(string strId)
    {
        super(strId);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * @author Rocex Wang
     * @since 2020-6-17 22:03:46
     ****************************************************************************/
    override public void doAction(Event evt)
    {
        LongTask longTask = getLongTask();

        if (longTask !is null)
        {
            longTask.setEvent(evt);
            longTask.setAction(this);
            longTask.start();
        }

        longTask = null;
    }

    /***************************************************************************
     * @return LongTask
     * @author Rocex Wang
     * @since 2020-6-28 22:21:51
     ***************************************************************************/
    protected abstract LongTask getLongTask();
}
