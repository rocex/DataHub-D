module org.rocex.vo.PageInfo;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-8-7 22:15:47
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
     * @return the pageCount > 0
     * @author Rocex Wang
     * @since 2019-8-7 22:19:12
     ***************************************************************************/
    public int getPageCount()
    {
        return iPageCount;
    }

    /***************************************************************************
     * @return the pageIndex > 0
     * @author Rocex Wang
     * @since 2019-8-7 22:19:12
     ***************************************************************************/
    public int getPageIndex()
    {
        return iPageIndex;
    }

    /***************************************************************************
     * @return the pageSize
     * @author Rocex Wang
     * @since 2019-8-7 22:19:12
     ***************************************************************************/
    public int getPageSize()
    {
        return iPageSize;
    }

    /***************************************************************************
     * @return the recordTotal
     * @author Rocex Wang
     * @since 2019-8-7 22:19:23
     ***************************************************************************/
    public long getTotalRecord()
    {
        return iTotalRecord;
    }

    /***************************************************************************
     * @param pageIndex the pageIndex to set
     * @author Rocex Wang
     * @since 2019-8-7 22:19:12
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
     * @param pageSize the pageSize to set
     * @author Rocex Wang
     * @since 2019-8-7 22:19:12
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
     * @param recordTotal the recordTotal to set
     * @author Rocex Wang
     * @since 2019-8-7 22:19:23
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
