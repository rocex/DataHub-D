module org.rocex.ui.action.ActionManager;

import std.range;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.IAction;
import org.rocex.ui.action.Separator;
import org.rocex.ui.Context;
import org.rocex.ui.widgets.MessageDialog;
import org.rocex.ui.utils.ActionHelper;
import org.rocex.utils.Logger;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-13 22:54:06
 ***************************************************************************/
public class ActionManager
{
    private Context context;

    private IAction[string] mapAction; // action.id -> action

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-6-3 22:38:25
     ***************************************************************************/
    ~this()
    {
        dispose();
    }

    /***************************************************************************
     * 检查并打印快捷键冲突的action
     * Params: action=
     * Authors: Rocex Wang
     * Date: 2019-6-3 22:36:42
     ***************************************************************************/
    protected void checkAcceleratorConflict(IAction action)
    {
        if (action is null || action.getAccelerator() == SWT.NONE)
        {
            return;
        }

        foreach (strKey, actionExist; mapAction)
        {
            if (actionExist != action && actionExist.getAccelerator() == action.getAccelerator())
            {
                Logger.getLogger().error("the conflict accelerator [" ~ ActionHelper.convertAccelerator(
                        action.getAccelerator()) ~ "] between [" ~ actionExist.classinfo.name
                        ~ "] and [" ~ action.classinfo.name ~ "]");
            }
        }
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2020-7-6 22:11:57
     ***************************************************************************/
    public void dispose()
    {
        foreach (strKey, action; mapAction)
        {
            action.dispose();
        }
    }

    /***************************************************************************
     * Params: strActionId=
     * Returns: IAction
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:18:05
     ***************************************************************************/
    public IAction getAction(string strActionId)
    {
        IAction action = strActionId in mapAction ? mapAction[strActionId] : null;

        return action;
    }

    /***************************************************************************
     * Returns: the context
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:47:23
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-7-9 22:20:08
     ***************************************************************************/
    public void refreshActionState()
    {
        foreach (action; mapAction)
        {
            action.setEnabled(action.isEnabled());
        }
    }

    /***************************************************************************
     * Params: actions=
     * Authors: Rocex Wang
     * Date: 2019-7-23 22:54:34
     ***************************************************************************/
    public void registerAction(IAction[] actions...)
    {
        if (actions is null || actions.length == 0)
        {
            return;
        }

        foreach (IAction action; actions)
        {
            //todo 这种判断方式可能有问题，需要以后验证调整
            if (action is null || typeof(action).classinfo.name == Separator.classinfo.name)
            {
                continue;
            }

            if (action.getId() in mapAction)
            {
                Logger.getLogger()
                    .info("duplicate action key: " ~ action.getId() ~ ", and replace by new action!");
            }

            mapAction[action.getId()] = action;
        }
    }

    /***************************************************************************
     * 注册action
     * Params: 
     *      strActionId=
     *      actionClass=
     * Authors: Rocex Wang
     * Date: 2019-8-23 22:10:06
     ***************************************************************************/
    public void registerAction(string strActionId, ClassInfo actionClass)
    {
        try
        {
            IAction action = cast(IAction) Object.factory(actionClass.name);

            action.setContext(getContext());

            mapAction[strActionId] = action;

            checkAcceleratorConflict(action);
        }

        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }
    }

    /***************************************************************************
     * Params: 
     *  evt=
     *  strActionId=
     * Authors: Rocex Wang
     * Date: 2020-6-3 22:38:27
     ***************************************************************************/
    public void runAction(Event evt, string[] strActionIds...)
    {
        if (strActionIds is null || strActionIds.length == 0)
        {
            return;
        }

        foreach (string strActionId; strActionIds)
        {
            IAction action = getAction(strActionId);

            if (action is null)
            {
                continue;
            }

            try
            {
                action.run(evt);
            }
            catch (Exception ex)
            {
                getContext().getApplication().showErrorMessage(ex.msg, ex);

                MessageDialog.showError(getContext().getApplication(), ex.msg);
            }
        }
    }

    /***************************************************************************
     * 设置所有Action状态
     * Params: blEnable=
     * Authors: Rocex Wang
     * Date: 2019-7-9 22:17:14
     ***************************************************************************/
    public void setActionEnable(bool blEnable)
    {
        foreach (action; mapAction)
        {
            action.setEnabled(blEnable);
        }
    }

    /***************************************************************************
     * 设置指定Action状态
     * Params: blEnable=
     * Params: strActionIds=
     * Authors: Rocex Wang
     * Date: 2019-6-9 22:40:25
     ***************************************************************************/
    public void setActionEnable(bool blEnable, string[] strActionIds...)
    {
        if (strActionIds is null || strActionIds.length == 0)
        {
            return;
        }

        foreach (string strActionId; strActionIds)
        {
            IAction action = mapAction[strActionId];

            action.setEnabled(blEnable);
        }
    }

    /***************************************************************************
     * Params: context=the context to set
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:47:23
     ***************************************************************************/
    public void setContext(Context context)
    {
        this.context = context;
    }

    /***************************************************************************
     * Params: actions=
     * Authors: Rocex Wang
     * Date: 2020-7-4 22:15:10
     ***************************************************************************/
    public void unregister(IAction[] actions...)
    {
        if (actions is null || actions.length == 0)
        {
            return;
        }

        foreach (IAction action; actions)
        {
            action.dispose();

            mapAction.remove(action.getId());
        }
    }

    /***************************************************************************
     * 注销action
     * Params: strActionIds
     * Authors: Rocex Wang
     * Date: 2020-6-24 22:38:44
     ***************************************************************************/
    public void unregister(string[] strActionIds...)
    {
        if (strActionIds is null || strActionIds.length == 0)
        {
            return;
        }

        foreach (string strActionId; strActionIds)
        {
            mapAction[strActionId].dispose();

            mapAction.remove(strActionId);
        }
    }
}
