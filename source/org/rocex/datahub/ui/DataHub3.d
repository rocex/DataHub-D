module org.rocex.datahub.ui.DataHub3;

import org.eclipse.swt.all;

public class DataHub3 : Shell
{
    /**
	 * Create contents of the window.
	 */
    this()
    {
        this.setLayout(new FormLayout());

        Menu menu = new Menu(this, SWT.BAR);
        this.setMenuBar(menu);

        MenuItem mntmFile = new MenuItem(menu, SWT.CASCADE);
        mntmFile.setText("File");

        Menu menu_1 = new Menu(mntmFile);
        mntmFile.setMenu(menu_1);

        MenuItem mntmEdit = new MenuItem(menu, SWT.CASCADE);
        mntmEdit.setText("Edit");

        Menu menu_2 = new Menu(mntmEdit);
        mntmEdit.setMenu(menu_2);

        ToolBar toolBar = new ToolBar(this, SWT.FLAT | SWT.WRAP);
        FormData fd_toolBar = new FormData();
        fd_toolBar.right = new FormAttachment(100);
        fd_toolBar.left = new FormAttachment(0);
        fd_toolBar.top = new FormAttachment(0);
        toolBar.setLayoutData(fd_toolBar);

        ToolItem tltmNew = new ToolItem(toolBar, SWT.NONE);
        tltmNew.setText("new");

        ToolItem tltmEdit = new ToolItem(toolBar, SWT.NONE);
        tltmEdit.setText("edit");

        ToolItem tltmNewItem = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem.setText("New Item");

        ToolItem tltmNewItem_1 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_1.setText("New Item");

        ToolItem tltmNewItem_2 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_2.setText("New Item");

        ToolItem tltmNewItem_3 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_3.setText("New Item");

        ToolItem tltmNewItem_4 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_4.setText("New Item");

        ToolItem tltmNewItem_5 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_5.setText("New Item");

        ToolItem tltmNewItem_6 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_6.setText("New Item");

        ToolItem tltmNewItem_7 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_7.setText("New Item");

        ToolItem tltmNewItem_8 = new ToolItem(toolBar, SWT.NONE);
        tltmNewItem_8.setText("New Item");

        Composite composite_1 = new Composite(this, SWT.BORDER);
        composite_1.setLayout(new FormLayout());
        FormData fd_composite_1 = new FormData();
        fd_composite_1.top = new FormAttachment(toolBar, 1);
        fd_composite_1.right = new FormAttachment(toolBar, 0, SWT.RIGHT);
        fd_composite_1.left = new FormAttachment(0);
        composite_1.setLayoutData(fd_composite_1);

        Composite composite = new Composite(this, SWT.BORDER);
        composite.setLayout(new RowLayout(SWT.HORIZONTAL));
        FormData fd_composite = new FormData();
        fd_composite.top = new FormAttachment(100, -29);
        fd_composite.bottom = new FormAttachment(100);
        fd_composite.right = new FormAttachment(toolBar, 0, SWT.RIGHT);
        fd_composite.left = new FormAttachment(0);
        composite.setLayoutData(fd_composite);
        fd_composite_1.bottom = new FormAttachment(composite, -1);

        SashForm sashForm = new SashForm(composite_1, SWT.NONE);
        FormData fd_sashForm = new FormData();
        fd_sashForm.top = new FormAttachment(0, 0);
        fd_sashForm.left = new FormAttachment(0, 0);
        fd_sashForm.bottom = new FormAttachment(100);
        fd_sashForm.right = new FormAttachment(100);
        sashForm.setLayoutData(fd_sashForm);

        Tree tree = new Tree(sashForm, SWT.BORDER);

        CTabFolder tabFolder = new CTabFolder(sashForm, SWT.BORDER);
        tabFolder.setSelectionBackground(Display.getCurrent().getSystemColor(SWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT));

        CTabItem tabItem = new CTabItem(tabFolder, SWT.NONE);
        tabItem.setText("New Item");

        SashForm sashForm_1 = new SashForm(tabFolder, SWT.VERTICAL);
        tabItem.setControl(sashForm_1);

        StyledText styledText = new StyledText(sashForm_1, SWT.BORDER);

        CTabFolder tabFolder_1 = new CTabFolder(sashForm_1, SWT.BORDER | SWT.BOTTOM);
        tabFolder_1.setSelectionBackground(Display.getCurrent().getSystemColor(SWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT));

        CTabItem tabItem_1 = new CTabItem(tabFolder_1, SWT.NONE);
        tabItem_1.setText("New Item");

        Table table = new Table(tabFolder_1, SWT.BORDER | SWT.FULL_SELECTION);
        tabItem_1.setControl(table);
        table.setHeaderVisible(true);
        table.setLinesVisible(true);

        CTabItem tabItem_2 = new CTabItem(tabFolder_1, SWT.NONE);
        tabItem_2.setText("New Item");

        Table table_1 = new Table(tabFolder_1, SWT.BORDER | SWT.FULL_SELECTION);
        tabItem_2.setControl(table_1);
        table_1.setHeaderVisible(true);
        table_1.setLinesVisible(true);
        sashForm_1.setWeights([1, 1]);
        sashForm.setWeights([1, 9]);

        Label lblNewLabel_2 = new Label(composite, SWT.NONE);
        lblNewLabel_2.setText("New Label");

        Label lblNewLabel_1 = new Label(composite, SWT.NONE);
        lblNewLabel_1.setText("New Label");

        Label lblNewLabel = new Label(composite, SWT.NONE);
        lblNewLabel.setText("New Label");

        Label lblNewLabel_3 = new Label(composite, SWT.NONE);
        lblNewLabel_3.setText("New Label");
    }
}
