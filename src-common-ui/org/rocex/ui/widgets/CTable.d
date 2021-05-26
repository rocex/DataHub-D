module org.rocex.ui.widgets.CTable;

import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.rocex.datahub.vo.ColumnMetaData;
import org.rocex.datahub.vo.ResultVO;
import org.rocex.ui.utils.UIHelper;
import org.rocex.utils.ResHelper;
import org.rocex.utils.StringHelper;

/***************************************************************************
 * 带行号的表格控件<br>
 * @author Rocex Wang
 * @since 2019-5-15 22:56:40
 ***************************************************************************/
public class CTable : CompositeControl, IWidget!(string[][])
{
    private TableColumn columnNO;

    private bool isAutoWidth = true; // 是否自适应列宽度

    private string[][] strAllRowValues; // 主表数据

    private Table table; // 主数据表格
    private Table tableNO; // 行号表格

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-5-15 22:57:12
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, iStyle);

        setLayout(UIHelper.getFillGridLayout(2, false));

        tableNO = new Table(this, SWT.FULL_SELECTION | SWT.NO_SCROLL | SWT.VIRTUAL);
        tableNO.setLinesVisible(true);
        tableNO.setHeaderVisible(true);
        tableNO.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, true, 1, 1));
        tableNO.setBackground(ResHelper.getColor(SWT.COLOR_WIDGET_BACKGROUND));

        columnNO = new TableColumn(tableNO, SWT.CENTER);
        columnNO.setWidth(50);
        columnNO.setResizable(false);

        table = new Table(this, SWT.FULL_SELECTION | SWT.VIRTUAL);
        table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        table.setLinesVisible(true);
        table.setHeaderVisible(true);

        tableNO.addListener(SWT.Selection, evt => {
            table.setTopIndex(table.getTopIndex());
            table.setSelection(tableNO.getSelectionIndices());
        });
        table.addListener(SWT.Selection, evt => {
            tableNO.setTopIndex(table.getTopIndex());
            tableNO.setSelection(table.getSelectionIndices());
        });

        table.addMouseWheelListener(evt => syncScrollbar());

        table.getVerticalBar().addListener(SWT.Selection, evt => syncScrollbar());
        table.getVerticalBar().addListener(SWT.DefaultSelection, evt => syncScrollbar());

        // 左下角横向滚动条的占位符
        final Label lblSpacer = new Label(this, SWT.NONE);
        GridData layoutData = new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1);
        layoutData.heightHint = 0;
        lblSpacer.setLayoutData(layoutData);

        table.addPaintListener(evt => syncSpacer(table, lblSpacer));
        table.addListener(SWT.Resize, evt => syncSpacer(table, lblSpacer));

        tableNO.addListener(SWT.SetData, event => {
            TableItem item = cast(TableItem) event.item;
            if (strAllRowValues !is null && event.index < strAllRowValues.length)
            {
                item.setText(string.valueOf(event.index + 1));
            }
        });

        table.addListener(SWT.SetData, event => {
            TableItem item = cast(TableItem) event.item;
            if (strAllRowValues !is null && event.index < strAllRowValues.length)
            {
                item.setText(strAllRowValues[event.index]);
            }
        });
    }

    /***************************************************************************
     * @param strText TableColumn's title
     * @param style
     * @return TableColumn
     * @author Rocex Wang
     * @since 2019-5-15 22:17:27
     ***************************************************************************/
    public TableColumn addColumn(string strText, int style)
    {
        TableColumn column = new TableColumn(table, style);
        column.setWidth(120);
        column.setText(strText.toLowerCase());

        // 以下开始处理数据
        if (strAllRowValues is null || strAllRowValues.length == 0)
        {
            return column;
        }

        // 二维数组最后增加一列
        for (int i = 0; i < strAllRowValues.length; i++)
        {
            string[] strDataNew = new string[strAllRowValues[i].length + 1];

            System.arraycopy(strAllRowValues[i], 0, strDataNew, 0, strAllRowValues[i].length);

            strAllRowValues[i] = strDataNew;
        }

        return column;
    }

    /***************************************************************************
     * @return TableItem
     * @author Rocex Wang
     * @since 2019-5-15 22:17:30
     ***************************************************************************/
    public TableItem addRow()
    {
        return addRow(new string[]);
    }

    /***************************************************************************
     * @param strData
     * @return TableItem
     * @author Rocex Wang
     * @since 2019-5-17 22:17:31
     ***************************************************************************/
    public TableItem addRow(string[] strData...)
    {
        TableItem tableItemNo = new TableItem(tableNO, SWT.NONE);
        tableItemNo.setText(string.valueOf(tableNO.getItemCount()));

        TableItem tableItem = new TableItem(table, SWT.NONE);

        table.showItem(tableItem);

        // 以下开始处理数据
        string[][] strDataNew = null;

        if (strAllRowValues is null || strAllRowValues.length == 0)
        {
            const int iColumns = strData.length > table.getColumnCount()
                ? strData.length : table.getColumnCount();

            strDataNew = new string[1][iColumns];
        }
        else
        {
            const int iColumns = strAllRowValues[0].length > table.getColumnCount()
                ? strAllRowValues[0].length : table.getColumnCount();

            strDataNew = new string[strAllRowValues.length + 1][iColumns];

            System.arraycopy(strAllRowValues, 0, strDataNew, 0, strAllRowValues.length);
        }

        System.arraycopy(strData, 0, strDataNew[strDataNew.length - 1], 0, strData.length);

        strAllRowValues = strDataNew;

        return tableItem;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-6-18 22:28:01
     ***************************************************************************/
    public void deleteAllColumn()
    {
        setValue((string[][]));

        if (table.getColumnCount() == 0)
        {
            return;
        }

        for (int i = table.getColumnCount() - 1; i > -1; i--)
        {
            table.getColumn(i).dispose();
        }
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-7-1 22:06:37
     ***************************************************************************/
    public void deleteAllRow()
    {
        table.removeAll();
        tableNO.removeAll();
    }

    /***************************************************************************
     * @param iColumnIndices
     * @author Rocex Wang
     * @since 2019-5-20 22:44:29
     ***************************************************************************/
    public void deleteColumn(int[] iColumnIndices...)
    {
        if (iColumnIndices is null || iColumnIndices.length == 0)
        {
            return;
        }

        Arrays.sort(iColumnIndices);

        for (int i = iColumnIndices.length - 1; i > -1; i--)
        {
            int iColumnIndex = iColumnIndices[i];

            if (iColumnIndex > -1 && iColumnIndex < table.getColumnCount())
            {
                table.getColumn(iColumnIndex).dispose();
            }

            if (strAllRowValues is null || strAllRowValues.length == 0 || iColumnIndex < 0)
            {
                continue;
            }

            // 以下开始处理数据
            for (int j = 0; j < strAllRowValues.length; j++)
            {
                if (iColumnIndex > strAllRowValues[j].length - 1)
                {
                    continue;
                }

                string[] strDataNew = new string[strAllRowValues[j].length - 1];

                System.arraycopy(strAllRowValues[j], 0, strDataNew, 0, iColumnIndex);
                System.arraycopy(strAllRowValues[j], iColumnIndex + 1,
                        strDataNew, iColumnIndex, strDataNew.length - iColumnIndex);

                strAllRowValues[j] = strDataNew;
            }
        }

        if (table.getColumnCount() == 0)
        {
            setValue((string[][]));
        }
    }

    /***************************************************************************
     * @param iRowIndices
     * @author Rocex Wang
     * @since 2019-5-17 22:07:03
     ***************************************************************************/
    public void deleteRow(int[] iRowIndices...)
    {
        if (iRowIndices is null || iRowIndices.length == 0)
        {
            return;
        }

        Arrays.sort(iRowIndices);

        // 以下开始处理数据
        for (int i = iRowIndices.length - 1; i > -1; i--)
        {
            int iRowIndex = iRowIndices[i];

            if (iRowIndex > -1 && iRowIndex < table.getItemCount())
            {
                table.remove(iRowIndices);
                tableNO.remove(iRowIndices);
            }

            if (strAllRowValues is null || strAllRowValues.length == 0
                    || iRowIndex < 0 || iRowIndex > strAllRowValues.length)
            {
                continue;
            }

            int iColumns = strAllRowValues[0].length > table.getColumnCount()
                ? strAllRowValues[0].length : table.getColumnCount();

            string[][] strDataNew = new string[strAllRowValues.length - 1][iColumns];

            System.arraycopy(strAllRowValues, 0, strDataNew, 0, iRowIndex);
            System.arraycopy(strAllRowValues, iRowIndex + 1, strDataNew,
                    iRowIndex, strDataNew.length - iRowIndex);

            strAllRowValues = strDataNew;
        }

        syncRowNO(iRowIndices[0]);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * @author Rocex Wang
     * @since 2020-7-4 22:06:28
     ****************************************************************************/
    override public void dispose()
    {
        strAllRowValues = null;

        ResHelper.dispose(columnNO, table, tableNO);

        super.dispose();
    }

    /***************************************************************************
     * @return int
     * @author Rocex Wang
     * @since 2019-5-17 22:48:11
     ***************************************************************************/
    public int getColumnCount()
    {
        return table.getColumnCount();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.CompositeControl#getControl()
     * @author Rocex Wang
     * @since 2019-5-28 22:53:37
     ****************************************************************************/
    override public Table getControl()
    {
        return table;
    }

    /***************************************************************************
     * @return int
     * @author Rocex Wang
     * @since 2019-5-17 22:48:13
     ***************************************************************************/
    public int getRowCount()
    {
        return table.getItemCount();
    }

    /***************************************************************************
     * @return string[][]
     * @author Rocex Wang
     * @since 2019-6-26 22:09:22
     ***************************************************************************/
    override public string[][] getValue()
    {
        return strAllRowValues;
    }

    /***************************************************************************
     * @return the isAutoWidth
     * @author Rocex Wang
     * @since 2020-6-22 22:38:08
     ***************************************************************************/
    public bool isAutoWidth()
    {
        return isAutoWidth;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-6-5 22:37:52
     ***************************************************************************/
    public void packAllColumnWidth()
    {
        if (!isAutoWidth())
        {
            return;
        }

        columnNO.pack();

        if (table.getColumnCount() == 0)
        {
            return;
        }

        for (int i = table.getColumnCount() - 1; i > -1; i--)
        {
            table.getColumn(i).pack();
        }
    }

    /***************************************************************************
     * @param isAutoWidth the isAutoWidth to set
     * @author Rocex Wang
     * @since 2020-6-22 22:38:08
     ***************************************************************************/
    public void setAutoWidth(bool isAutoWidth)
    {
        this.isAutoWidth = isAutoWidth;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Control#setFont(org.eclipse.swt.graphics.Font)
     * @author Rocex Wang
     * @since 2020-6-5 22:53:13
     ****************************************************************************/
    override public void setFont(Font font)
    {
        super.setFont(font);

        table.setFont(font);
        tableNO.setFont(font);
    }

    /***************************************************************************
     * @param resultVO
     * @author Rocex Wang
     * @since 2019-6-25 22:13:11
     ***************************************************************************/
    public void setResultVO(ResultVO resultVO)
    {
        setVisible(false);

        // 先清空所有列
        deleteAllColumn();

        if (resultVO is null)
        {
            setVisible(true);

            return;
        }

        List!(ColumnMetaData) colMetaData = resultVO.getColumnVO();

        // 数值型右对齐，其它默认左对齐
        foreach (ColumnMetaData metaData; colMetaData)
        {
            int iStyle = SWT.NONE;

            const Integer iColumnType = cast(Integer) metaData.getColumnType();

            if (Types.BIGINT == iColumnType || Types.DECIMAL == iColumnType || Types.DOUBLE == iColumnType
                    || Types.FLOAT == iColumnType || Types.INTEGER == iColumnType || Types.NUMERIC == iColumnType
                    || Types.REAL == iColumnType || Types.SMALLINT == iColumnType
                    || Types.TINYINT == iColumnType)
            {
                iStyle = iStyle | SWT.RIGHT;
            }

            addColumn(metaData.getColumnLabel(), iStyle);
        }

        List!(List) result = resultVO.getResult();
        string[][] strCellValues = new string[result.size()][colMetaData.size()];

        for (int i = 0; i < result.size(); i++)
        {
            List list = result.get(i);

            for (int j = 0; j < colMetaData.size(); j++)
            {
                strCellValues[i][j] = StringHelper.defaultString(list.get(j));
            }
        }

        resultVO.close();

        setValue(strCellValues);

        packAllColumnWidth();

        setVisible(true);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#setValue(java.lang.Object)
     * @author Rocex Wang
     * @since 2020-6-19 22:51:43
     ****************************************************************************/
    override public void setValue(string[][] objValue)
    {
        strAllRowValues = objValue;

        deleteAllRow();

        if (strAllRowValues is null || strAllRowValues.length == 0)
        {
            return;
        }

        table.setItemCount(strAllRowValues.length);
        tableNO.setItemCount(strAllRowValues.length);
    }

    /***************************************************************************
     * @param iFromIndex
     * @author Rocex Wang
     * @since 2019-5-17 22:49:45
     ***************************************************************************/
    protected void syncRowNO(int iFromIndex)
    {
        int iFromIndexNew = iFromIndex;

        if (iFromIndex < 0)
        {
            iFromIndexNew = 0;
        }

        for (int i = iFromIndexNew; i < table.getItemCount(); i++)
        {
            TableItem item = i < tableNO.getItemCount()
                ? tableNO.getItem(i) : new TableItem(tableNO, SWT.RIGHT);

            if (item is null)
            {
                item = new TableItem(tableNO, SWT.RIGHT);
            }

            item.setText(string.valueOf(i + 1));
        }

        columnNO.pack();
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-15 22:08:46
     ***************************************************************************/
    protected void syncScrollbar()
    {
        tableNO.setTopIndex(table.getTopIndex());

        columnNO.pack();
    }

    /***************************************************************************
     * @param table
     * @param lblSpacer
     * @author Rocex Wang
     * @since 2019-5-15 22:55:22
     ***************************************************************************/
    protected void syncSpacer(Table table, Label lblSpacer)
    {
        bool isHBarVisible = table.getHorizontalBar().isVisible();

        GridData gridDataSpacer = cast(GridData) lblSpacer.getLayoutData();

        if (isHBarVisible)
        {
            gridDataSpacer.heightHint = table.getHorizontalBar().getSize().y;
            lblSpacer.setLayoutData(gridDataSpacer);

            table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 2));
        }
        else
        {
            gridDataSpacer.heightHint = 0;
            lblSpacer.setLayoutData(gridDataSpacer);

            table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        }

        columnNO.pack();

        table.getParent().layout();
    }
}
