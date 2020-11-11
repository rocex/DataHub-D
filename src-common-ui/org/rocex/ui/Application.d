module org.rocex.ui.Application;

import java.lang.all;
import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.rocex.settings.SettingConst;
import org.rocex.settings.Settings;
import org.rocex.ui.action.AboutAction;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.ActionManager;
import org.rocex.ui.action.ExitAction;
import org.rocex.ui.Context;
import org.rocex.ui.widgets.LeftControl;
import org.rocex.ui.widgets.MenuBar;
import org.rocex.ui.widgets.MessageDialog;
import org.rocex.ui.widgets.StatusBar;
import org.rocex.ui.widgets.Toolbar;
import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;
import org.rocex.utils.UIHelper;

// import org.rocex.ui.action.paging.FirstPageAction;
// import org.rocex.ui.action.paging.LastPageAction;
// import org.rocex.ui.action.paging.NextPageAction;
// import org.rocex.ui.action.paging.PreviousPageAction;
// import org.rocex.ui.widgets.action.CopyAction;
// import org.rocex.ui.widgets.action.CutAction;
// import org.rocex.ui.widgets.action.PasteAction;
// import org.rocex.ui.widgets.action.SelectAllAction;

/***************************************************************************
 * 应用启动入口类<br> 
 * @author Rocex Wang
 * @version 2019-5-21 22:56:52
 ***************************************************************************/
public class Application : Shell
{
    private ActionManager actionManager;

    private Context context;

    private LeftControl leftControl;

    private Composite mainControl;

    private MenuBar menuBar;

    private SashForm sashMainBaseControl;

    private StatusBar statusBar;

    private Toolbar toolbar;

    /***************************************************************************
     * @author Rocex Wang
     * @version 2019-5-21 22:56:52
     ***************************************************************************/
    public this()
    {
        super();

        setText("Application");
        setImage(ResHelper.getImage(ResHelper.res_root_path ~ "app.png"));

        setLayout(UIHelper.getFillGridLayout(1, true));

        context = createContext();

        actionManager = createActionManager();
        actionManager.setContext(getContext());

        getContext().setApplication(this);
        getContext().setActionManager(actionManager);

        registerActions();

        createContents();

        getActionManager().refreshActionState();

        Listener listener = new class Listener
        {
            void handleEvent(Event evt)
            {
                getActionManager().runAction(evt, ActionConst.id_exit);
            }
        };

        addListener(SWT.Close, listener);
    }

    override protected void checkSubclass()
    {
    }

    /***************************************************************************
     * @return
     * @author Rocex Wang
     * @version 2019-5-21 22:53:25
     ***************************************************************************/
    protected ActionManager createActionManager()
    {
        return new ActionManager();
    }

    /***************************************************************************
     * @return
     * @author Rocex Wang
     * @version 2019-5-8 22:05:04
     * @param shell
     ***************************************************************************/
    protected void createContents()
    {
        // 菜单栏
        menuBar = createMenuBar(this);
        menuBar.setContext(getContext());

        // 工具栏
        toolbar = createToolBar(this);
        toolbar.setContext(getContext());

        // 主界面
        sashMainBaseControl = createMainBaseControl(this);

        // 左边控件
        leftControl = createLeftControl(sashMainBaseControl);
        leftControl.setContext(getContext());

        // 右边主控件
        mainControl = createMainControl(sashMainBaseControl);

        if (leftControl is null)
        {
            sashMainBaseControl.setMaximizedControl(mainControl);
        }
        else
        {
            sashMainBaseControl.setWeights([2, 8]);
        }

        // 状态栏
        statusBar = createStatusBar(this);
        statusBar.setContext(getContext());
    }

    /***************************************************************************
     * @return Context
     * @author Rocex Wang
     * @version 2020-6-1 22:44:07
     ***************************************************************************/
    protected Context createContext()
    {
        return new Context();
    }

    /***************************************************************************
     * @param sashForm
     * @author Rocex Wang
     * @version 2019-5-6 22:49:51
     ***************************************************************************/
    protected LeftControl createLeftControl(Composite parent)
    {
        LeftControl tree = new LeftControl(parent, SWT.BORDER);

        return tree;
    }

    /***************************************************************************
     * @param shell
     * @return SashForm
     * @author Rocex Wang
     * @version 2019-5-7 22:21:11
     ***************************************************************************/
    protected SashForm createMainBaseControl(Composite parent)
    {
        SashForm sashForm = new SashForm(parent, SWT.NONE);
        sashForm.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        sashForm.setSashWidth(Settings.getInt(SettingConst.sash_width, UIHelper.iSashDefaultWidth));

        return sashForm;
    }

    /***************************************************************************
     * @param sashForm
     * @author Rocex Wang
     * @version 2019-5-6 22:59:50
     ***************************************************************************/
    protected Composite createMainControl(Composite parent)
    {
        //todo delete those lines
        import org.eclipse.swt.custom.CTabFolder;
        import org.eclipse.swt.custom.CTabItem;

        CTabFolder tabFolder = new CTabFolder(parent, SWT.BORDER | SWT.FLAT);
        tabFolder.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

        Composite queryAnalyzer = new Composite(tabFolder, SWT.NONE);

        CTabItem tabItem = new CTabItem(tabFolder, SWT.NONE);
        tabItem.setImage(ResHelper.getImage(ResHelper.res_icon_path ~ "script.png"));
        tabItem.setText(" [无标题1] * ");
        tabItem.setControl(queryAnalyzer);

        tabItem = new CTabItem(tabFolder, SWT.NONE);
        tabItem.setImage(ResHelper.getImage(ResHelper.res_icon_path ~ "script.png"));
        tabItem.setText(" [无标题2] * ");
        tabItem.setControl(queryAnalyzer);

        tabFolder.setSelection(0);

        // return new Composite(parent, SWT.NONE);
        return tabFolder;
    }

    /***************************************************************************
     * @param menuBar
     * @author Rocex Wang
     * @version 2019-6-3 22:15:43
     ***************************************************************************/
    protected void createMenuBar(MenuBar menuBar)
    {
        menuBar.addCascadeMenu(menuBar, "&File", ActionConst.id_exit);

        // menuBar.addCascadeMenu(menuBar, "&Edit", ActionConst.id_edit_cut, ActionConst.id_edit_copy,
        //  ActionConst.id_edit_paste, ActionConst.id_separator,
        //  ActionConst.id_edit_select_all);

        menuBar.addCascadeMenu(menuBar, "&Help", ActionConst.id_about);
    }

    /***************************************************************************
     * @param shell
     * @return
     * @author Rocex Wang
     * @version 2019-5-8 22:05:17
     ***************************************************************************/
    protected MenuBar createMenuBar(Shell shell)
    {
        MenuBar menuBar2 = new MenuBar(shell, SWT.BAR);

        menuBar2.setContext(getContext());

        createMenuBar(menuBar2);

        shell.setMenuBar(menuBar2);

        return menuBar2;
    }

    /***************************************************************************
     * @param shell
     * @author Rocex Wang
     * @version 2019-5-8 22:38:26
     ***************************************************************************/
    protected StatusBar createStatusBar(Composite parent)
    {
        StatusBar statusBar2 = new StatusBar(parent, SWT.NONE);
        statusBar2.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));

        return statusBar2;
    }

    /***************************************************************************
     * @param shell
     * @return ToolBar
     * @author Rocex Wang
     * @version 2019-5-5 22:03:44
     ***************************************************************************/
    protected Toolbar createToolBar(Shell shell)
    {
        Toolbar toolbar2 = new Toolbar(shell, SWT.FLAT | SWT.WRAP | SWT.RIGHT);
        toolbar2.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

        toolbar2.setContext(getContext());

        createToolBar(toolbar2);

        return toolbar2;
    }

    /***************************************************************************
     * @param toolbar
     * @author Rocex Wang
     * @version 2019-6-3 22:16:19
     ***************************************************************************/
    protected void createToolBar(Toolbar toolbar)
    {
        toolbar.addAction(ActionConst.id_about, ActionConst.id_separator,
                ActionConst.id_about, ActionConst.id_separator, ActionConst.id_exit);
    }

    /***************************************************************************
     * @return the actionManager
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    public ActionManager getActionManager()
    {
        return actionManager;
    }

    /***************************************************************************
     * @return the context
     * @author Rocex Wang
     * @version 2020-6-1 22:52:59
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * @return the leftControl
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    public LeftControl getLeftControl()
    {
        return leftControl;
    }

    /***************************************************************************
     * @return the sashMainBaseControl
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    public SashForm getMainBaseControl()
    {
        return sashMainBaseControl;
    }

    /***************************************************************************
     * @return the mainControl
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    public Composite getMainControl()
    {
        return mainControl;
    }

    /***************************************************************************
     * @return the menuBar
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    override public MenuBar getMenuBar()
    {
        return menuBar;
    }

    /***************************************************************************
     * @return the statusBar
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    public StatusBar getStatusBar()
    {
        return statusBar;
    }

    /***************************************************************************
     * @return the toolbar
     * @author Rocex Wang
     * @version 2019-5-21 22:58:02
     ***************************************************************************/
    public Toolbar getToolBar()
    {
        return toolbar;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @version 2019-8-23 22:06:18
     ***************************************************************************/
    protected void registerActions()
    {
        getActionManager().registerAction(ActionConst.id_about, AboutAction.classinfo);

        // getActionManager().registerAction(ActionConst.id_edit_cut, CutAction);
        // getActionManager().registerAction(ActionConst.id_edit_copy, CopyAction);
        // getActionManager().registerAction(ActionConst.id_edit_paste, PasteAction);
        // getActionManager().registerAction(ActionConst.id_edit_select_all, SelectAllAction);
        getActionManager().registerAction(ActionConst.id_exit, ExitAction.classinfo);
    }

    /***************************************************************************
     * @param window
     * @author Rocex Wang
     * @version 2020-6-30 22:09:22
     ***************************************************************************/
    public void restoreWindowState()
    {
        const bool blMaximized = Settings.getBoolean(SettingConst.window_maximized, true);

        if (blMaximized)
        {
            setMaximized(true);

            return;
        }

        const int iWidth = Settings.getInt(SettingConst.window_width, 800);
        const int iHeight = Settings.getInt(SettingConst.window_heigth, 600);

        setSize(iWidth, iHeight);

        setLocation(UIHelper.getScreenCenterLocation(this));
    }

    /***************************************************************************
     * @param strMessage
     * @param ex
     * @author Rocex Wang
     * @version 2020-6-9 22:51:10
     ***************************************************************************/
    public void showErrorMessage(String strMessage, Exception ex)
    {
        if (getStatusBar() !is null && !getStatusBar().isDisposed())
        {
            getStatusBar().showErrorMessage(strMessage);
        }
    }

    /***************************************************************************
     * @param strMessage
     * @author Rocex Wang
     * @version 2019-5-23 22:27:04
     ***************************************************************************/
    public void showHintMessage(String strMessage)
    {
        if (getStatusBar() !is null && !getStatusBar().isDisposed())
        {
            getStatusBar().showHintMessage(strMessage);
        }
    }
}

/***************************************************************************
 * @param args
 * @author Rocex Wang
 * @version 2019-5-21 22:45:00
 ***************************************************************************/
public static void main(String[] args)
{
    Display display = Display.getDefault();

    Logger.setEnableLevel(Settings.getValue(SettingConst.enable_log_level, "error"));

    try
    {
        String strMainClass = Settings.getValue(SettingConst.main_class,
                Application.classinfo.name);

        Logger.getLogger().error("main class is " ~ strMainClass);

        Application window = cast(Application) Object.factory(strMainClass);

        // todo delete this line
        window = new Application();

        window.restoreWindowState();

        window.open();

        while (!window.isDisposed())
        {
            if (!display.readAndDispatch())
            {
                display.sleep();
            }
        }
    }
    catch (Exception ex)
    {
        Logger.getLogger().error(ex.msg, ex);

        MessageDialog.showError(display.getShells()[0], ex.msg);
    }
    finally
    {
        Settings.save();

        ResHelper.dispose();

        if (display !is null && !display.isDisposed())
        {
            display.dispose();
        }
    }
}
