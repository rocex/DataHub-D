module org.rocex.datahub.ui.DataHub2;

import org.eclipse.swt.all;

import org.rocex.utils.Logger;

public class DataHub2 : Shell
{
    /**
	 * Create contents of the window.
	 */
    this()
    {
        Logger.getLogger().tracef("this is in data hub2");

        setLayout(new GridLayout(1, false));

        Menu menu = new Menu(this, SWT.BAR);
        setMenuBar(menu);

        MenuItem mntmFile = new MenuItem(menu, SWT.CASCADE);
        mntmFile.setText("File");

        Menu menu_1 = new Menu(mntmFile);
        mntmFile.setMenu(menu_1);

        MenuItem mntmNew = new MenuItem(menu_1, SWT.NONE);
        mntmNew.setText("New");

        ToolBar toolBar = new ToolBar(this, SWT.FLAT | SWT.WRAP | SWT.RIGHT);
        toolBar.setLayoutData(new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1));

        ToolItem tltmNewItem = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem.setToolTipText("New Item");
        // tltmNewItem.setImage(SWTResourceManager.getImage(Datahub.class, "/icons/progress/ani/1.png"));

        ToolItem tltmNewItem_1 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_1.setText("New Item");

        ToolItem tltmNewItem_2 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_2.setText("New Item");

        ToolItem tltmNewItem_3 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_3.setText("New Item");

        ToolItem tltmNewItem_4 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_4.setText("New Item");

        ToolItem toolItem = new ToolItem(toolBar, SWT.SEPARATOR);

        ToolItem tltmNewItem_5 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_5.setText("New Item");

        ToolItem tltmNewItem_6 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_6.setText("New Item");

        ToolItem tltmNewItem_7 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_7.setText("New Item");

        ToolItem tltmNewItem_8 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_8.setText("New Item");

        ToolItem tltmNewItem_9 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_9.setText("New Item");

        ToolItem toolItem_1 = new ToolItem(toolBar, SWT.SEPARATOR);

        ToolItem tltmNewItem_10 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_10.setText("New Item");

        ToolItem tltmNewItem_11 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_11.setText("New Item");

        ToolItem tltmNewItem_12 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_12.setText("New Item");

        ToolItem tltmNewItem_13 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_13.setText("New Item");

        Composite composite_1 = new Composite(this, SWT.NONE);
        composite_1.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        composite_1.setLayout(new GridLayout(1, false));

        SashForm sashForm = new SashForm(composite_1, SWT.NONE);
        sashForm.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

        Tree tree = new Tree(sashForm, SWT.BORDER);

        CTabFolder tabFolder = new CTabFolder(sashForm, SWT.BORDER | SWT.CLOSE | SWT.FLAT);
        tabFolder.setSelectionBackground(Display.getCurrent().getSystemColor(SWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT));

        CTabItem tbtmNewItem = new CTabItem(tabFolder, SWT.NONE);
        tbtmNewItem.setText("New Item");

        CTabItem tbtmNewItem_1 = new CTabItem(tabFolder, SWT.NONE);
        tbtmNewItem_1.setText("New Item");

        Text text = new Text(tabFolder, SWT.BORDER | SWT.WRAP | SWT.MULTI);
        tbtmNewItem_1.setControl(text);
        sashForm.setWeights([1, 9]);

        tabFolder.setSelection(0);

        SashForm sashForm_1 = new SashForm(tabFolder, SWT.VERTICAL);
        tbtmNewItem.setControl(sashForm_1);

        StyledText styledText = new StyledText(sashForm_1, SWT.BORDER | SWT.WRAP);

        CTabFolder tabFolder_1 = new CTabFolder(sashForm_1, SWT.BORDER | SWT.BOTTOM);
        tabFolder_1.setSelectionBackground(Display.getCurrent().getSystemColor(SWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT));

        CTabItem tbtmNewItem_2 = new CTabItem(tabFolder_1, SWT.NONE);
        tbtmNewItem_2.setText("New Item");

        Table table = new Table(tabFolder_1, SWT.BORDER | SWT.FULL_SELECTION);
        tbtmNewItem_2.setControl(table);
        table.setHeaderVisible(true);
        table.setLinesVisible(true);

        TableColumn tblclmnNewColumn = new TableColumn(table, SWT.NONE);
        tblclmnNewColumn.setWidth(100);
        tblclmnNewColumn.setText("New Column");

        TableColumn tblclmnNewColumn_1 = new TableColumn(table, SWT.NONE);
        tblclmnNewColumn_1.setWidth(100);
        tblclmnNewColumn_1.setText("New Column");

        TableColumn tblclmnNewColumn_2 = new TableColumn(table, SWT.NONE);
        tblclmnNewColumn_2.setWidth(100);
        tblclmnNewColumn_2.setText("New Column");

        TableItem tableItem = new TableItem(table, SWT.NONE);
        tableItem.setText("New TableItem");

        table.pack();

        CTabItem tbtmNewItem_3 = new CTabItem(tabFolder_1, SWT.NONE);
        tbtmNewItem_3.setText("New Item");

        Table table_1 = new Table(tabFolder_1, SWT.BORDER | SWT.FULL_SELECTION);
        tbtmNewItem_3.setControl(table_1);
        table_1.setHeaderVisible(true);
        table_1.setLinesVisible(true);

        TableColumn tblclmnNewColumn_3 = new TableColumn(table_1, SWT.NONE);
        tblclmnNewColumn_3.setWidth(100);
        tblclmnNewColumn_3.setText("New Column");

        TableColumn tblclmnNewColumn_4 = new TableColumn(table_1, SWT.NONE);
        tblclmnNewColumn_4.setWidth(100);
        tblclmnNewColumn_4.setText("New Column");

        CTabItem tbtmNewItem_4 = new CTabItem(tabFolder_1, SWT.NONE);
        tbtmNewItem_4.setText("New Item");
        sashForm_1.setWeights([4, 6]);

        tabFolder_1.setSelection(0);

        Composite composite = new Composite(this, SWT.BORDER);
        RowLayout rl_composite = new RowLayout(SWT.HORIZONTAL);
        rl_composite.wrap = false;
        rl_composite.justify = true;
        rl_composite.fill = true;
        composite.setLayout(rl_composite);
        GridData gd_composite = new GridData(SWT.LEFT, SWT.FILL, true, false, 1, 1);
        gd_composite.heightHint = 20;
        composite.setLayoutData(gd_composite);

        Label lblNewLabel = new Label(composite, SWT.NONE);
        lblNewLabel.setText("New Label");

        Label lblNewLabel_1 = new Label(composite, SWT.NONE);
        lblNewLabel_1.setText("New Label");

        Label lblNewLabel_2 = new Label(composite, SWT.NONE);
        lblNewLabel_2.setText("New Label");

        Label lblNewLabel_3 = new Label(composite, SWT.NONE);
        lblNewLabel_3.setText("New Label");

        Label lblNewLabel_4 = new Label(composite, SWT.NONE);
        lblNewLabel_4.setText("New Label");
    }
}
