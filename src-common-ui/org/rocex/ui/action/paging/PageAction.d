module org.rocex.ui.action.paging.PageAction;

import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.Action;

import org.rocex.ui.widgets.PagingBar;
import org.rocex.vo.PageInfo;
import org.rocex.ui.action.paging.PageModel;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-14 22:46:17
 ***************************************************************************/
public class PageAction : Action
{
    private PageInfo pageInfo;
    private PageModel pageModel;

    private PagingBar pagingBar;

    /***************************************************************************
     * @param strId
     * @author Rocex Wang
     * @since 2019-5-14 22:46:17
     ***************************************************************************/
    public this(string strId)
    {
        super(strId);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * @author Rocex Wang
     * @since 2019-5-14 22:46:17
     ****************************************************************************/
    override public void doAction(Event evt)
    {
        if (pagingBar is null)
        {
            return;
        }

        pagingBar.setPageInfo(getPageInfo());

        pageModel.doAction(evt);

        fireEvent(evt);
    }

    /***************************************************************************
     * @return the pageInfo
     * @author Rocex Wang
     * @since 2020-6-24 22:06:30
     ***************************************************************************/
    public PageInfo getPageInfo()
    {
        return pageInfo;
    }

    /***************************************************************************
     * @return the pageModel
     * @author Rocex Wang
     * @since 2020-6-24 22:54:21
     ***************************************************************************/
    public PageModel getPageModel()
    {
        return pageModel;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#isEnabled()
     * @author Rocex Wang
     * @since 2020-6-24 22:33:11
     ****************************************************************************/
    override public bool isEnabled()
    {
        return getPageInfo() !is null && getPageInfo().getPageSize() != PageInfo.no_paging;
    }

    /***************************************************************************
     * @param pageInfo the pageInfo to set
     * @author Rocex Wang
     * @since 2020-6-24 22:06:30
     ***************************************************************************/
    public void setPageInfo(PageInfo pageInfo)
    {
        this.pageInfo = pageInfo;
    }

    /***************************************************************************
     * @param pageModel the pageModel to set
     * @author Rocex Wang
     * @since 2020-6-24 22:54:21
     ***************************************************************************/
    public void setPageModel(PageModel pageModel)
    {
        this.pageModel = pageModel;
    }

    /***************************************************************************
     * @param pagingBar the pagingBar to set
     * @author Rocex Wang
     * @since 2020-6-24 22:09:15
     ***************************************************************************/
    public void setPagingBar(PagingBar pagingBar)
    {
        this.pagingBar = pagingBar;
    }
}
