module org.rocex.ui.action.paging.NextPageAction;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.paging.PageAction;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-14 22:46:17
 ***************************************************************************/
public class NextPageAction : PageAction
{
    /***************************************************************************
     * @param strId
     * @author Rocex Wang
     * @since 2019-5-14 22:46:17
     ***************************************************************************/
    public this()
    {
        super(ActionConst.id_page_next);

        setText(" > ");
        setToolTip("Go to next page");
        setAccelerator(SWT.CTRL | SWT.ALT | 'N');
        setIconPath(ResHelper.res_icon_path ~ "/paging/next.png");
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * @author Rocex Wang
     * @since 2019-5-14 22:46:17
     ****************************************************************************/
    override public void doAction(Event evt)
    {
        getPageInfo().setPageIndex(getPageInfo().getPageIndex() + 1);

        super.doAction(evt);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#isEnabled()
     * @author Rocex Wang
     * @since 2020-6-24 22:29:03
     ****************************************************************************/
    override public bool isEnabled()
    {
        return super.isEnabled() && getPageInfo().getPageIndex() < getPageInfo().getPageCount();
    }
}
