module org.rocex.ui.Context;

import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.ActionManager;
import org.rocex.ui.app;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-14 22:21:07
 ***************************************************************************/
public class Context
{
    private ActionManager actionManager;

    private Application application;

    /***************************************************************************
     * Params: evt
     * Authors: Rocex Wang
     * Date: 2019-7-9 22:56:17
     ***************************************************************************/
    public void fireEvent(Event evt)
    {
        try
        {
            getActionManager().refreshActionState();
        }
        catch (Exception ex)
        {
            getApplication().showErrorMessage(ex.msg, ex);
        }
    }

    /***************************************************************************
     * Returns: the actionManager
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:38:39
     ***************************************************************************/
    public ActionManager getActionManager()
    {
        return actionManager;
    }

    /***************************************************************************
     * Returns: the application
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:38:39
     ***************************************************************************/
    public Application getApplication()
    {
        return application;
    }

    /***************************************************************************
     * Params: actionManager the actionManager to set
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:38:39
     ***************************************************************************/
    public void setActionManager(ActionManager actionManager)
    {
        this.actionManager = actionManager;
    }

    /***************************************************************************
     * Params: application the application to set
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:38:39
     ***************************************************************************/
    public void setApplication(Application application)
    {
        this.application = application;
    }
}
