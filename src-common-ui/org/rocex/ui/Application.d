module org.rocex.ui.app;

import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.custom.CTabFolder;
import org.eclipse.swt.custom.CTabItem;
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
import org.rocex.ui.utils.UIHelper;
import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;

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
 * Authors: Rocex Wang
 * Date: 2019-5-21 22:56:52
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
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:56:52
     ***************************************************************************/
    public this()
    {
        super();

        initUI();
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2021-3-24 21:56:25
     ***************************************************************************/
    protected void initUI()
    {
        setText("Application");
        setImage(ResHelper.getImage(ResHelper.res_root_path ~ "app.png"));

        setLayout(UIHelper.getFillGridLayout(1, true));

        context = createContext();
        UIHelper.context = context;

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
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:53:25
     ***************************************************************************/
    protected ActionManager createActionManager()
    {
        return new ActionManager();
    }

    /***************************************************************************
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-8 22:05:04
     * Params: shell
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

        // 右边主控件
        mainControl = createMainControl(sashMainBaseControl);

        if (leftControl is null)
        {
            sashMainBaseControl.setMaximizedControl(mainControl);
        }
        else
        {
            leftControl.setContext(getContext());
            sashMainBaseControl.setWeights([2, 8]);
        }

        // 状态栏
        statusBar = createStatusBar(this);
        statusBar.setContext(getContext());
    }

    /***************************************************************************
     * Returns: Context
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:44:07
     ***************************************************************************/
    protected Context createContext()
    {
        return new Context();
    }

    /***************************************************************************
     * Params: sashForm
     * Authors: Rocex Wang
     * Date: 2019-5-6 22:49:51
     ***************************************************************************/
    protected LeftControl createLeftControl(Composite parent)
    {
        LeftControl tree = new LeftControl(parent, SWT.BORDER);

        return tree;
    }

    /***************************************************************************
     * Params: shell
     * Returns: SashForm
     * Authors: Rocex Wang
     * Date: 2019-5-7 22:21:11
     ***************************************************************************/
    protected SashForm createMainBaseControl(Composite parent)
    {
        SashForm sashForm = new SashForm(parent, SWT.NONE);
        sashForm.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        sashForm.setSashWidth(Settings.getInt(SettingConst.sash_width, UIHelper.iSashDefaultWidth));

        return sashForm;
    }

    /***************************************************************************
     * Params: sashForm
     * Authors: Rocex Wang
     * Date: 2019-5-6 22:59:50
     ***************************************************************************/
    protected Composite createMainControl(Composite parent)
    {
        return new Composite(parent, SWT.NONE);
    }

    /***************************************************************************
     * Params: menuBar
     * Authors: Rocex Wang
     * Date: 2019-6-3 22:15:43
     ***************************************************************************/
    protected void createMenuBar(MenuBar menuBar)
    {
        menuBar.addCascadeMenu(menuBar, "&File", ActionConst.id_exit);

        // menuBar.addCascadeMenu(menuBar, "&Edit", ActionConst.id_edit_cut, ActionConst.id_edit_copy,
        //         ActionConst.id_edit_paste, ActionConst.id_separator,
        //         ActionConst.id_edit_select_all);

        menuBar.addCascadeMenu(menuBar, "&Help", ActionConst.id_about);
    }

    /***************************************************************************
     * Params: shell
     * Returns: MenuBar
     * Authors: Rocex Wang
     * Date: 2019-5-8 22:05:17
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
     * Params: shell
     * Authors: Rocex Wang
     * Date: 2019-5-8 22:38:26
     ***************************************************************************/
    protected StatusBar createStatusBar(Composite parent)
    {
        StatusBar statusBar2 = new StatusBar(parent, SWT.NONE);
        statusBar2.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));

        return statusBar2;
    }

    /***************************************************************************
     * Params: shell
     * Returns: ToolBar
     * Authors: Rocex Wang
     * Date: 2019-5-5 22:03:44
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
     * Params: toolbar
     * Authors: Rocex Wang
     * Date: 2019-6-3 22:16:19
     ***************************************************************************/
    protected void createToolBar(Toolbar toolbar)
    {
        toolbar.addAction(ActionConst.id_about, ActionConst.id_separator, ActionConst.id_exit);
    }

    /***************************************************************************
     * Returns: the actionManager
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    public ActionManager getActionManager()
    {
        return actionManager;
    }

    /***************************************************************************
     * Returns: the context
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:52:59
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * Returns: the leftControl
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    public LeftControl getLeftControl()
    {
        return leftControl;
    }

    /***************************************************************************
     * Returns: the sashMainBaseControl
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    public SashForm getMainBaseControl()
    {
        return sashMainBaseControl;
    }

    /***************************************************************************
     * Returns: the mainControl
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    public Composite getMainControl()
    {
        return mainControl;
    }

    /***************************************************************************
     * Returns: the menuBar
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    override public MenuBar getMenuBar()
    {
        return menuBar;
    }

    /***************************************************************************
     * Returns: the statusBar
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    public StatusBar getStatusBar()
    {
        return statusBar;
    }

    /***************************************************************************
     * Returns: the toolbar
     * Authors: Rocex Wang
     * Date: 2019-5-21 22:58:02
     ***************************************************************************/
    public Toolbar getToolBar()
    {
        return toolbar;
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-8-23 22:06:18
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
     * Params: window
     * Authors: Rocex Wang
     * Date: 2020-6-30 22:09:22
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

        UIHelper.centerScreen(this, iWidth, iHeight);
    }

    /***************************************************************************
     * Params: strMessage
     * Params: ex
     * Authors: Rocex Wang
     * Date: 2020-6-9 22:51:10
     ***************************************************************************/
    public void showErrorMessage(string strMessage, Exception ex)
    {
        if (getStatusBar() !is null && !getStatusBar().isDisposed())
        {
            getStatusBar().showErrorMessage(strMessage);
        }
    }

    /***************************************************************************
     * Params: strMessage
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:27:04
     ***************************************************************************/
    public void showHintMessage(string strMessage)
    {
        if (getStatusBar() !is null && !getStatusBar().isDisposed())
        {
            getStatusBar().showHintMessage(strMessage);
        }
    }
}

/***************************************************************************
 * Params: args
 * Authors: Rocex Wang
 * Date: 2019-5-21 22:45:00
 ***************************************************************************/
public static void main(string[] args)
{
    Display display = Display.getDefault();

    Logger.setEnableLevel(Settings.getValue(SettingConst.enable_log_level, "all"));

    try
    {
        string strMainClass = Settings.getValue(SettingConst.main_class,
                Application.classinfo.name);

        Logger.getLogger().warningf("main class is [%s]", strMainClass);

        Application window = cast(Application) Object.factory(strMainClass);

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
