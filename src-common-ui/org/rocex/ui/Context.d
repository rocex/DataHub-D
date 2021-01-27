module org.rocex.ui.Context;

import org.eclipse.swt.widgets.Event;
import org.rocex.ui.action.ActionManager;
import org.rocex.ui.Application;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-14 22:21:07
 ***************************************************************************/
public class Context
{
    private ActionManager actionManager;

    private Application application;

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2019-7-9 22:56:17
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
     * @return the actionManager
     * @author Rocex Wang
     * @since 2019-5-14 22:38:39
     ***************************************************************************/
    public ActionManager getActionManager()
    {
        return actionManager;
    }

    /***************************************************************************
     * @return the application
     * @author Rocex Wang
     * @since 2019-5-14 22:38:39
     ***************************************************************************/
    public Application getApplication()
    {
        return application;
    }

    /***************************************************************************
     * @param actionManager the actionManager to set
     * @author Rocex Wang
     * @since 2019-5-14 22:38:39
     ***************************************************************************/
    public void setActionManager(ActionManager actionManager)
    {
        this.actionManager = actionManager;
    }

    /***************************************************************************
     * @param application the application to set
     * @author Rocex Wang
     * @since 2019-5-14 22:38:39
     ***************************************************************************/
    public void setApplication(Application application)
    {
        this.application = application;
    }
}
