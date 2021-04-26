module org.rocex.ui.action.paging.FirstPageAction;

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
public class FirstPageAction : PageAction
{
    /***************************************************************************
     * Params: strId
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:17
     ***************************************************************************/
    public this()
    {
        super(ActionConst.id_page_first);

        setText(" |< ");
        setToolTip("Go to first page");
        setAccelerator(SWT.CTRL | SWT.ALT | 'F');
        setIconPath(ResHelper.res_icon_path ~ "/paging/first.png");
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:17
     ****************************************************************************/
    override public void doAction(Event evt)
    {
        getPageInfo().setPageIndex(1);

        super.doAction(evt);
    }

    override public bool isEnabled()
    {
        return super.isEnabled() && getPageInfo().getPageIndex() > 1;
    }
}
