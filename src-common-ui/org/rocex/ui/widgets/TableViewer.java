package org.rocex.ui.widgets;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.rocex.datahub.vo.ResultVO;
import org.rocex.ui.utils.UIHelper;
import org.rocex.utils.ResHelper;
import org.rocex.vo.PageInfo;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-4-23 22:13:24
 ***************************************************************************/
public class TableViewer extends CompositeControl implements IWidget<Object>
{
    private PagingBar pagingBar;
    
    private String strTableValues[][];
    
    private CTable table;
    
    private Toolbar toolbar;
    
    private CText<String> txtSearch;
    
    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-4-23 22:41:52
     ***************************************************************************/
    public TableViewer(Composite parent, int iStyle)
    {
        super(parent, SWT.BORDER | iStyle);
        
        setLayout(UIHelper.getFillGridLayout(1, true));
        
        createToolBar();
        
        createTable();
    }
    
    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-7 22:14:28
     ***************************************************************************/
    protected void createStatusBar()
    {
        StatusBar statusBar = new StatusBar(this, SWT.NONE);
        
        GridData gridDataFooter = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
        gridDataFooter.heightHint = UIHelper.iBarHeight;
        statusBar.setLayoutData(gridDataFooter);
    }
    
    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-7 22:18:36
     ***************************************************************************/
    protected void createTable()
    {
        table = new CTable(this, SWT.FULL_SELECTION);
        table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        table.getControl().setHeaderVisible(true);
        table.getControl().setLinesVisible(true);
    }
    
    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-7 22:19:27
     ***************************************************************************/
    protected void createToolBar()
    {
        toolbar = new Toolbar(this, SWT.FLAT | SWT.RIGHT);
        toolbar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
        
        toolbar.addAutoWidthSpacer();
        toolbar.setContext(getContext());
        
        pagingBar = new PagingBar(toolbar, SWT.NONE);
        
        toolbar.addCustomControl(pagingBar);
        
        toolbar.addCustomControl(new Label(toolbar, SWT.NONE), 5);
        
        txtSearch = new CText<>(toolbar, SWT.BORDER | SWT.SEARCH | SWT.ICON_SEARCH);
        txtSearch.setMessage("Search...");
        
        txtSearch.addListener(SWT.Modify, evt -> filterTableData());
        txtSearch.addListener(SWT.FocusIn, evt -> fireEvent(null));
        
        toolbar.addCustomControl(txtSearch, 120);
        
        addDisposeListener(evt -> ResHelper.dispose(pagingBar, toolbar));
    }
    
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * @author Rocex Wang
     * @since 2020-7-4 22:05:25
     ****************************************************************************/
    @Override
    public void dispose()
    {
        strTableValues = null;
        
        ResHelper.dispose(pagingBar, toolbar, table);
        
        super.dispose();
    }
    
    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-7-1 22:58:09
     ***************************************************************************/
    protected void filterTableData()
    {
        if (strTableValues == null)
        {
            return;
        }
        
        List<String[]> list = new ArrayList<>();
        
        String strSearchText = txtSearch.getText().toLowerCase();
        
        for (String[] strRowValues : strTableValues)
        {
            for (String strCellValue : strRowValues)
            {
                if (strCellValue != null && strCellValue.toLowerCase().contains(strSearchText))
                {
                    list.add(strRowValues);
                    break;
                }
            }
        }
        
        String[][] strNewValues = list.toArray(new String[0][]);
        
        table.setValue(strNewValues);
        
        String strHintMsg = MessageFormat.format("{0} / {1}", strNewValues == null ? 0 : strNewValues.length,
                strTableValues == null ? 0 : strTableValues.length);
        
        getContext().getApplication().showHintMessage(strHintMsg);
    }
    
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.CompositeControl#getControl()
     * @author Rocex Wang
     * @since 2019-5-28 22:00:54
     ****************************************************************************/
    @Override
    public CTable getControl()
    {
        return table;
    }
    
    /***************************************************************************
     * @return PageInfo
     * @author Rocex Wang
     * @since 2020-6-22 22:28:04
     ***************************************************************************/
    public PageInfo getPageInfo()
    {
        return getPagingBar().getPageInfo();
    }
    
    /***************************************************************************
     * @return the pagingBar
     * @author Rocex Wang
     * @since 2019-5-9 22:09:55
     ***************************************************************************/
    public PagingBar getPagingBar()
    {
        return pagingBar;
    }
    
    /***************************************************************************
     * @return the toolbar
     * @author Rocex Wang
     * @since 2019-5-9 22:09:55
     ***************************************************************************/
    public Toolbar getToolBar()
    {
        return toolbar;
    }
    
    /***************************************************************************
     * @return
     * @author Rocex Wang
     * @since 2019-5-9 22:10:09
     ***************************************************************************/
    public CText<String> getTxtSearch()
    {
        return txtSearch;
    }
    
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#getValue()
     * @author Rocex Wang
     * @since 2020-6-22 22:33:19
     ****************************************************************************/
    @Override
    public String[][] getValue()
    {
        return getControl().getValue();
    }
    
    /***************************************************************************
     * @param pageInfo
     * @author Rocex Wang
     * @since 2020-6-22 22:28:51
     ***************************************************************************/
    public void setPageInfo(PageInfo pageInfo)
    {
        getPagingBar().setPageInfo(pageInfo);
    }
    
    /***************************************************************************
     * @param resultVO
     * @author Rocex Wang
     * @since 2020-6-22 22:34:39
     ***************************************************************************/
    public void setResultVO(ResultVO resultVO)
    {
        setPageInfo(resultVO.getPageInfo());
        
        getControl().setResultVO(resultVO);
        
        strTableValues = getControl().getValue();
    }
    
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2020-6-22 22:33:19
     ****************************************************************************/
    @Override
    public void setValue(Object objValue)
    {
        String[][] strValue = (String[][]) objValue;
        
        this.strTableValues = strValue;
        
        getControl().setValue(strValue);
    }
}
