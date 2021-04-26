module org.rocex.ui.widgets.PagingBar;

import std.conv;
import std.format;

import java.lang.all;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.ActionManager;
import org.rocex.ui.action.paging.PageAction;
import org.rocex.ui.action.paging.PageModel;
import org.rocex.ui.form.FieldProp;
import org.rocex.ui.widgets.CCombo;
import org.rocex.ui.widgets.CText;
import org.rocex.ui.widgets.Toolbar;
import org.rocex.vo.PageInfo;
import org.rocex.vo.Pair;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-4-25 22:40:57
 ***************************************************************************/
public class PagingBar : Toolbar
{
    private PageAction actionFirstPage;

    private PageAction actionLastPage;
    private PageAction actionNextPage;
    private PageAction actionPrevPage;

    private CCombo comboPageSize;

    private Listener listener;

    private PageInfo pageInfo;

    private PageModel pageModel;

    private CText txtPageIndex;

    /***************************************************************************
     * Params: parent
     * Params: iStyle
     * Authors: Rocex Wang
     * Date: 2019-4-25 22:42:07
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, iStyle | SWT.FLAT);

        comboPageSize = new CCombo(this, SWT.READ_ONLY | SWT.FLAT);

        List list = new ArrayList();
        list.add(new Pair!(string, int)("--不分页--", PageInfo.no_paging));
        list.add(new Pair!(string, int)("10条/页", 10));
        list.add(new Pair!(string, int)("20条/页", 20));
        list.add(new Pair!(string, int)("50条/页", 50));
        list.add(new Pair!(string, int)("100条/页", 100));
        list.add(new Pair!(string, int)("500条/页", 500));
        list.add(new Pair!(string, int)("1000条/页", 1000));
        list.add(new Pair!(string, int)("5000条/页", 5000));

        comboPageSize.setModel(list);

        addCustomControl(comboPageSize);

        ActionManager actionManager = getContext().getActionManager();

        actionFirstPage = cast(PageAction) actionManager.getAction(ActionConst.id_page_first);
        actionPrevPage = cast(PageAction) actionManager.getAction(ActionConst.id_page_prev);

        addAction(actionFirstPage);
        addAction(actionPrevPage);

        txtPageIndex = new CText(this, SWT.BORDER | SWT.RIGHT);
        txtPageIndex.setProp(new FieldProp("PageIndex", null, false,
                FieldProp.datatype_integer, 10).setMin(1));

        addCustomControl(txtPageIndex, 50);

        actionNextPage = cast(PageAction) actionManager.getAction(ActionConst.id_page_next);
        actionLastPage = cast(PageAction) actionManager.getAction(ActionConst.id_page_last);

        addAction(actionNextPage);
        addAction(actionLastPage);

        actionFirstPage.setPagingBar(this);
        actionPrevPage.setPagingBar(this);
        actionNextPage.setPagingBar(this);
        actionLastPage.setPagingBar(this);

        listener = new class Listener
        {
            void handleEvent(Event evt)
            {
                if (evt.widget == comboPageSize && to!(int)(comboPageSize.getValue()
                        .toString) == PageInfo.no_paging)
                {
                    txtPageIndex.setValue(stringcast("1"));
                }

                txtPageIndex.setEnabled(to!(int)(
                        stringcast(comboPageSize.getValue())) != PageInfo.no_paging);

                if (pageModel !is null)
                {
                    pageModel.doAction(evt);
                }
            }
        };

        txtPageIndex.addListener(SWT.FocusOut, listener);
        comboPageSize.addListener(SWT.Modify, listener);

        setPageInfo(new PageInfo());
    }

    /***************************************************************************
     * Returns: the pageInfo
     * Authors: Rocex Wang
     * Date: 2020-6-18 22:06:57
     ***************************************************************************/
    public PageInfo getPageInfo()
    {
        if (pageInfo is null)
        {
            pageInfo = new PageInfo();
        }

        Object objPageIndex = txtPageIndex.getValue();
        pageInfo.setPageIndex(objPageIndex is null ? 1 : to!(int)(stringcast(objPageIndex)));
        pageInfo.setPageSize(to!(int)(comboPageSize.getValue().toString));

        return pageInfo;
    }

    /***************************************************************************
     * Params: pageInfo the pageInfo to set
     * Authors: Rocex Wang
     * Date: 2020-6-18 22:06:57
     ***************************************************************************/
    public void setPageInfo(PageInfo pageInfo)
    {
        this.pageInfo = pageInfo;

        txtPageIndex.removeListener(SWT.FocusOut, listener);
        comboPageSize.removeListener(SWT.Modify, listener);

        txtPageIndex.setToolTipText(format("第 %s 页，共 %s 页",
                pageInfo.getPageIndex(), pageInfo.getPageCount()));

        comboPageSize.setValue(stringcast(to!string(pageInfo.getPageSize())));

        txtPageIndex.setValue(stringcast(to!string(pageInfo.getPageIndex())));
        txtPageIndex.getProp().setMax(pageInfo.getPageCount());
        txtPageIndex.setEnabled(pageInfo.getPageSize() != PageInfo.no_paging);

        actionFirstPage.setPageInfo(pageInfo);
        actionPrevPage.setPageInfo(pageInfo);
        actionNextPage.setPageInfo(pageInfo);
        actionLastPage.setPageInfo(pageInfo);

        if (pageModel !is null)
        {
            pageModel.setPageInfo(pageInfo);
        }

        txtPageIndex.addListener(SWT.FocusOut, listener);
        comboPageSize.addListener(SWT.Modify, listener);
    }

    /***************************************************************************
     * Params: pageModel
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:25:26
     ***************************************************************************/
    public void setPageModel(PageModel pageModel)
    {
        this.pageModel = pageModel;

        actionFirstPage.setPageModel(pageModel);
        actionPrevPage.setPageModel(pageModel);
        actionNextPage.setPageModel(pageModel);
        actionLastPage.setPageModel(pageModel);
    }
}
