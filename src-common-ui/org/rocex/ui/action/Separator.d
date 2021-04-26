module org.rocex.ui.action.Separator;

import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.Action;
import org.rocex.ui.action.ActionConst;

/***************************************************************************
 * 分割条，适用于 {@link MenuBar} 和 {@link ToolBar}<br>
 * Authors: Rocex Wang
 * Date: 2019-7-29 22:28:54
 ***************************************************************************/
public class Separator : Action
{
    /****************************************************************************
     * Authors: Rocex Wang
     * Date: 2020-08-04 22:12:08
     ****************************************************************************/
    public this()
    {
        super(ActionConst.id_separator);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * Authors: Rocex Wang
     * Date: 2019-7-29 22:24:07
     ****************************************************************************/
    override public void doAction(Event evt)
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#isEnabled()
     * Authors: Rocex Wang
     * Date: 2019-7-29 22:24:07
     ****************************************************************************/
    override public bool isEnabled()
    {
        return false;
    }
}
