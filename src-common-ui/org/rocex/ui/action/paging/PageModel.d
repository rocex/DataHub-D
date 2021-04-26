module org.rocex.ui.action.paging.PageModel;

import org.eclipse.swt.widgets.Event;
import org.rocex.ui.Context;
import org.rocex.vo.PageInfo;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2020-6-24 22:44:33
 ***************************************************************************/
public class PageModel
{
    private Context context;

    private PageInfo pageInfo;

    /***************************************************************************
     * Params: evt
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:05:49
     ***************************************************************************/
    public void doAction(Event evt)
    {
    }

    /***************************************************************************
     * Returns: the context
     * Authors: Rocex Wang
     * Date: 2020-7-25 22:37:06
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * Returns: the pageInfo
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:32:18
     ***************************************************************************/
    public PageInfo getPageInfo()
    {
        return pageInfo;
    }

    /***************************************************************************
     * Params: context the context to set
     * Authors: Rocex Wang
     * Date: 2020-7-25 22:37:06
     ***************************************************************************/
    public PageModel setContext(Context context)
    {
        this.context = context;

        return this;
    }

    /***************************************************************************
     * Params: pageInfo
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:31:49
     ***************************************************************************/
    public PageModel setPageInfo(PageInfo pageInfo)
    {
        this.pageInfo = pageInfo;

        return this;
    }
}
