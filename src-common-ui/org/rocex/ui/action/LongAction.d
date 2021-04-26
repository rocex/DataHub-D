module org.rocex.ui.action.LongAction;

import org.eclipse.swt.widgets.Event;

import org.rocex.ui.action.Action;
import org.rocex.ui.action.LongTask;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2020-6-17 22:03:46
 ***************************************************************************/
public abstract class LongAction : Action
{
    /***************************************************************************
     * Params: strId
     * Authors: Rocex Wang
     * Date: 2020-6-17 22:03:46
     ***************************************************************************/
    public this(string strId)
    {
        super(strId);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * Authors: Rocex Wang
     * Date: 2020-6-17 22:03:46
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
     * Returns: LongTask
     * Authors: Rocex Wang
     * Date: 2020-6-28 22:21:51
     ***************************************************************************/
    protected abstract LongTask getLongTask();
}
