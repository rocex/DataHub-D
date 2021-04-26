module org.rocex.ui.action.paging.PageAction;

import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.Action;

import org.rocex.ui.widgets.PagingBar;
import org.rocex.vo.PageInfo;
import org.rocex.ui.action.paging.PageModel;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-14 22:46:17
 ***************************************************************************/
public class PageAction : Action
{
    private PageInfo pageInfo;
    private PageModel pageModel;

    private PagingBar pagingBar;

    /***************************************************************************
     * Params: strId
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:17
     ***************************************************************************/
    public this(string strId)
    {
        super(strId);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.widgets.Event)
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:17
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
     * Returns: the pageInfo
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:06:30
     ***************************************************************************/
    public PageInfo getPageInfo()
    {
        return pageInfo;
    }

    /***************************************************************************
     * Returns: the pageModel
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:54:21
     ***************************************************************************/
    public PageModel getPageModel()
    {
        return pageModel;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#isEnabled()
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:33:11
     ****************************************************************************/
    override public bool isEnabled()
    {
        return getPageInfo() !is null && getPageInfo().getPageSize() != PageInfo.no_paging;
    }

    /***************************************************************************
     * Params: pageInfo the pageInfo to set
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:06:30
     ***************************************************************************/
    public void setPageInfo(PageInfo pageInfo)
    {
        this.pageInfo = pageInfo;
    }

    /***************************************************************************
     * Params: pageModel the pageModel to set
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:54:21
     ***************************************************************************/
    public void setPageModel(PageModel pageModel)
    {
        this.pageModel = pageModel;
    }

    /***************************************************************************
     * Params: pagingBar the pagingBar to set
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:09:15
     ***************************************************************************/
    public void setPagingBar(PagingBar pagingBar)
    {
        this.pagingBar = pagingBar;
    }
}
