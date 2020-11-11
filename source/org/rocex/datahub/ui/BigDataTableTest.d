module org.rocex.datahub.ui.BigDataTableTest;

import std.conv;

import java.lang.String;
import java.lang.Runnable;
import java.lang.System;

import org.eclipse.swt.all;

import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2019年4月28日 上午10:15:48
 ***************************************************************************/
public class BigDataTableTest : Shell
{
    /**
     * Create contents of the window.
     */
    this()
    {
        immutable auto cols = 50;
        immutable auto rows = 100;

        //	    auto image = ResHelper.getImage!("DataHub.gif");

        //    	rows = 10;

        setText("BigDataTableTest");
        setLayout(new GridLayout(1, false));

        auto table = new Table(this, SWT.BORDER | SWT.FULL_SELECTION | SWT.VERTICAL);
        table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        table.setHeaderVisible(true);
        table.setLinesVisible(true);

        Label status = new Label(this, SWT.NONE);
        status.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));

        for (int i = 0; i < cols; i++)
        {
            TableColumn tblclmnNewColumn = new TableColumn(table, SWT.NONE);
            tblclmnNewColumn.setWidth(100);
            tblclmnNewColumn.setText("New Column" ~ to!(String)(i));
        }

        Menu menu = new Menu(table);
        table.setMenu(menu);

        MenuItem mntmFillNormal = new MenuItem(menu, SWT.NONE);
        mntmFillNormal.setText("填充(普通)");
        mntmFillNormal.addSelectionListener(new class SelectionAdapter
            {
            override void widgetSelected(SelectionEvent e)
            {
                Display.getDefault().syncExec(new class Runnable
                {
                    public void run()
                    {
                        auto start = System.currentTimeMillis(); for (int i = 0; i < rows;
                            i++)
                        {
                            TableItem tableItem = new TableItem(table, SWT.NONE); for (int j = 0;
                                j < cols; j++)
                            {
                                tableItem.setText(j, to!(String)(i) ~ "_" ~ to!(String)(j));
                            }
                        }

                        status.setText("cost time:" ~ to!(String)(
                        (System.currentTimeMillis() - start)));}
                    }
);}
                }
);
                auto data = new String[cols][rows];

                table.addListener(SWT.SetData, new class Listener
                {
                    override public void handleEvent(Event evt)
                    {
                        Logger.getLogger().info("begin virtual fill table rows"); TableItem item = to!(
                        TableItem)(evt.item); int index = evt.index; item.setText(data[index]);
                        status.setText(data[index][0]); Logger.getLogger().info(data[index][0]);
                    }
                }
);
                table.setItemCount(rows);

                MenuItem mntmFillVirtual = new MenuItem(menu, SWT.NONE);
                mntmFillVirtual.setText("填充(虚拟)");
                mntmFillVirtual.addSelectionListener(new class SelectionAdapter
                {
                    override void widgetSelected(SelectionEvent e)
                    {
                        Display.getDefault().syncExec(new class Runnable
                    {
                            public void run()
                            {
                                Logger.getLogger().info("begin virtual fill table");

                                auto start = System.currentTimeMillis(); for (int i = 0;
                                    i < rows; i++)
                                {
                                    for (int j = 0; j < cols; j++)
                                    {
                                        data[i][j] = to!(String)(i) ~ "_" ~ to!(String)(j);
                                        status.setText(data[i][j]);}
                                    }

                                    //                     status.setText( "cost time:" ~ to!(String)((System.currentTimeMillis() - start)));
                                }
                            }
);}
                        }
);
                        new MenuItem(menu, SWT.SEPARATOR);

                        MenuItem mntmClean = new MenuItem(menu, SWT.NONE);
                        mntmClean.setText("清空");
                        mntmClean.addSelectionListener(new class SelectionAdapter
                    {
                            override void widgetSelected(SelectionEvent e)
                            {
                                table.clearAll(); table.removeAll(); status.setText("");
                            }
                        }
);
                    }
                }
