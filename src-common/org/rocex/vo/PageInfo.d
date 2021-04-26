module org.rocex.vo.PageInfo;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-8-7 22:15:47
 ***************************************************************************/
public class PageInfo //todo : SuperVO
{
    /// 不使用分页
    public static int no_paging = -1;

    private int iPageCount = 1; // 总页码
    private int iPageIndex = 1; // 当前页码
    private int iPageSize = -1; // 每页记录数
    private long iTotalRecord = 0; // 总记录数

    /***************************************************************************
     * Returns: the pageCount > 0
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:12
     ***************************************************************************/
    public int getPageCount()
    {
        return iPageCount;
    }

    /***************************************************************************
     * Returns: the pageIndex > 0
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:12
     ***************************************************************************/
    public int getPageIndex()
    {
        return iPageIndex;
    }

    /***************************************************************************
     * Returns: the pageSize
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:12
     ***************************************************************************/
    public int getPageSize()
    {
        return iPageSize;
    }

    /***************************************************************************
     * Returns: the recordTotal
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:23
     ***************************************************************************/
    public long getTotalRecord()
    {
        return iTotalRecord;
    }

    /***************************************************************************
     * Params: pageIndex the pageIndex to set
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:12
     ***************************************************************************/
    public PageInfo setPageIndex(int pageIndex)
    {
        if (pageIndex < 0)
        {
            return this;
        }

        iPageIndex = pageIndex;

        return this;
    }

    /***************************************************************************
     * Params: pageSize the pageSize to set
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:12
     ***************************************************************************/
    public PageInfo setPageSize(int pageSize)
    {
        if (pageSize < no_paging)
        {
            return this;
        }

        iPageSize = pageSize;

        return this;
    }

    /***************************************************************************
     * Params: recordTotal the recordTotal to set
     * Authors: Rocex Wang
     * Date: 2019-8-7 22:19:23
     ***************************************************************************/
    public PageInfo setTotalRecord(long recordTotal)
    {
        if (recordTotal < 0)
        {
            return this;
        }

        iTotalRecord = recordTotal;

        iPageCount = iPageSize == no_paging ? 1 : cast(int)(
                iTotalRecord / iPageSize + (iTotalRecord % iPageSize == 0 ? 0 : 1));

        return this;
    }
}
