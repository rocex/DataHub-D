module org.rocex.ui.action.paging.LastPageAction;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.paging.PageAction;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-14 22:46:17
 ***************************************************************************/
public class LastPageAction : PageAction
{
    /***************************************************************************
     * Params: strId
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:17
     ***************************************************************************/
    public this()
    {
        super(ActionConst.id_page_last);

        setText(" >| ");
        setToolTip("Go to last page");
        setAccelerator(SWT.CTRL | SWT.ALT | 'L');
        setIconPath(ResHelper.res_icon_path ~ "/paging/last.png");
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:17
     ****************************************************************************/
    override public void doAction(Event evt)
    {
        getPageInfo().setPageIndex(getPageInfo().getPageCount());

        super.doAction(evt);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#isEnabled()
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:28:09
     ****************************************************************************/
    override public bool isEnabled()
    {
        return super.isEnabled() && getPageInfo().getPageIndex() < getPageInfo().getPageCount();
    }
}
