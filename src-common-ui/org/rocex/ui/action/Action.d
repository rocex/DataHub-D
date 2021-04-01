module org.rocex.ui.action.Action;

import java.lang.String;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Item;
import org.eclipse.swt.widgets.MenuItem;
import org.eclipse.swt.widgets.ToolItem;
import org.eclipse.swt.widgets.Widget;
import org.rocex.ui.action.ActionManager;
import org.rocex.ui.action.IAction;
import org.rocex.ui.app;
import org.rocex.ui.Context;
import org.rocex.ui.widgets.MessageDialog;
import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;
import std.algorithm;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-14 22:47:34
 ***************************************************************************/
public abstract class Action : IAction
{
    private bool blEnabled = true;

    private Context context;

    private int iAccelerator = SWT.NONE;

    private Item[] bindingItems; // 绑定的所有item，包括按钮和菜单项

    private String strIconPath;

    private String strId;

    private String strText;

    private String strToolTip;

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-14 22:47:34
     ***************************************************************************/
    public this()
    {
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-14 22:49:36
     ***************************************************************************/
    ~this()
    {
        dispose();
    }

    /***************************************************************************
     * @param strId
     * @author Rocex Wang
     * @since 2019-5-9 22:15:57
     ***************************************************************************/
    protected this(String strId)
    {
        this();

        this.strId = strId;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#addBindingItem(org.eclipse.swt.widgets.Item)
     * @author Rocex Wang
     * @since 2019-5-14 22:03:56
     ****************************************************************************/
    override public void addBindingItem(Item item)
    {
        bindingItems ~= item;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#afterAction()
     * @author Rocex Wang
     * @since 2020-6-13 22:47:51
     ****************************************************************************/
    override public void afterAction()
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#beforeAction()
     * @author Rocex Wang
     * @since 2019-5-09 22:15:44
     ****************************************************************************/
    override public void beforeAction()
    {
        showHintMessage(getText());
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#dispose()
     * @author Rocex Wang
     * @since 2020-7-6 22:09:21
     ****************************************************************************/
    override public void dispose()
    {
        if (bindingItems !is null && bindingItems.length > 0)
        {
            ResHelper.dispose(cast(Widget[]) bindingItems);

            bindingItems = null;
        }
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2019-5-11 22:23:10
     * @throws Exception
     ***************************************************************************/
    public abstract void doAction(Event evt);

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#finallyAction()
     * @author Rocex Wang
     * @since 2020-6-13 22:47:51
     ****************************************************************************/
    override public void finallyAction()
    {
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2019-7-11 22:07:49
     ***************************************************************************/
    public void fireEvent(Event evt)
    {
        getContext().fireEvent(evt);
    }

    /***************************************************************************
     * @return the accelerator
     * @author Rocex Wang
     * @since 2019-5-13 22:36:48
     ***************************************************************************/
    override public int getAccelerator()
    {
        return iAccelerator;
    }

    /***************************************************************************
     * @return ActionManager
     * @author Rocex Wang
     * @since 2019-6-9 22:54:34
     ***************************************************************************/
    protected ActionManager getActionManager()
    {
        return getApplication().getActionManager();
    }

    /***************************************************************************
     * @return Application
     * @author Rocex Wang
     * @since 2019-6-3 22:01:44
     ***************************************************************************/
    public Application getApplication()
    {
        return getContext().getApplication();
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#getBindingItems()
     * @author Rocex Wang
     * @since 2019-5-14 22:03:56
     ****************************************************************************/
    override public Item[] getBindingItems()
    {
        return bindingItems;
    }

    /***************************************************************************
     * @return the context
     * @author Rocex Wang
     * @since 2019-5-14 22:42:37
     ***************************************************************************/
    override public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * @return Display
     * @author Rocex Wang
     * @since 2020-6-11 22:20:45
     ***************************************************************************/
    public Display getDisplay()
    {
        return getApplication().getDisplay();
    }

    /***************************************************************************
     * @return the iconPath
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public String getIconPath()
    {
        return strIconPath;
    }

    /***************************************************************************
     * @return the strId
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public String getId()
    {
        return strId;
    }

    /***************************************************************************
     * @return the text
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public String getText()
    {
        return strText;
    }

    /***************************************************************************
     * @return the toolTip
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public String getToolTip()
    {
        return strToolTip;
    }

    /***************************************************************************
     * @param ex
     * @author Rocex Wang
     * @since 2020-6-11 22:22:06
     ***************************************************************************/
    public void handleException(Exception ex)
    {
        Logger.getLogger().error(ex.msg, ex);

        showErrorMessage(ex.msg, ex);

        MessageDialog.showError(getApplication(), ex.msg);

        throw ex;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#isEnabled()
     * @author Rocex Wang
     * @since 2020-6-16 22:29:23
     ****************************************************************************/
    override public bool isEnabled()
    {
        return blEnabled;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.IAction#removeBindingItem(org.eclipse.swt.widgets.Item)
     * @author Rocex Wang
     * @since 2020-7-4 22:56:40
     ****************************************************************************/
    override public void removeBindingItem(Item item)
    {
        //todo 查找索引
        auto iIndex = countUntil(bindingItems, item);

        if (iIndex != -1)
        {
            remove(bindingItems, iIndex);
        }
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-9 22:15:59
     ***************************************************************************/
    override public void run(Event evt)
    {
        Logger.getLogger().info("enter action " ~ this.classinfo.name);

        try
        {
            if (!isEnabled()) // 按钮不可用的情况下，不执行动作
            {
                Logger.getLogger().info("action is disable, return");

                return;
            }

            beforeAction();

            Logger.getLogger().infof("run action %s", this.classinfo.name);

            doAction(evt);

            afterAction();
        }
        catch (Exception ex)
        {
            handleException(ex);
        }
        finally
        {
            finallyAction();

            // System.gc();

            Logger.getLogger().info("leave action " ~ this.classinfo.name);
        }
    }

    /***************************************************************************
     * @param accelerator the accelerator to set
     * @author Rocex Wang
     * @since 2019-5-13 22:36:48
     ***************************************************************************/
    override public void setAccelerator(int accelerator)
    {
        iAccelerator = accelerator;
    }

    /***************************************************************************
     * @param context the context to set
     * @author Rocex Wang
     * @since 2019-5-14 22:42:37
     ***************************************************************************/
    override public void setContext(Context context)
    {
        this.context = context;
    }

    /***************************************************************************
     * @param enabled the enabled to set
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public final void setEnabled(bool enabled)
    {
        blEnabled = enabled;

        if (bindingItems is null || bindingItems.length == 0)
        {
            return;
        }

        foreach (Item item; bindingItems)
        {
            if (item is MenuItem.classinfo)
            {
                (cast(MenuItem) item).setEnabled(blEnabled);
            }
            else if (item is ToolItem.classinfo)
            {
                (cast(ToolItem) item).setEnabled(blEnabled);
            }
        }
    }

    /***************************************************************************
     * @param iconPath the iconPath to set
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public void setIconPath(String iconPath)
    {
        strIconPath = iconPath;
    }

    /***************************************************************************
     * @param strId the strId to set
     * @author Rocex Wang
     * @since 2019-5-13 22:14:13
     ***************************************************************************/
    override public void setId(String strId)
    {
        this.strId = strId;
    }

    /***************************************************************************
     * @param text the text to set
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public void setText(String text)
    {
        strText = text;
    }

    /***************************************************************************
     * @param toolTip the toolTip to set
     * @author Rocex Wang
     * @since 2019-05-09 22:14:34
     ***************************************************************************/
    override public void setToolTip(String toolTip)
    {
        strToolTip = toolTip;
    }

    /***************************************************************************
     * @param strMessage
     * @param ex
     * @author Rocex Wang
     * @since 2020-6-9 22:02:48
     ***************************************************************************/
    public void showErrorMessage(String strMessage, Exception ex)
    {
        getApplication().showErrorMessage(strMessage, ex);
    }

    /***************************************************************************
     * @param strMessage
     * @author Rocex Wang
     * @since 2019-6-18 22:59:19
     ***************************************************************************/
    public void showHintMessage(String strMessage)
    {
        getApplication().showHintMessage(strMessage);
    }
}
