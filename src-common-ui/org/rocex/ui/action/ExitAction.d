module org.rocex.ui.action.ExitAction;

import org.rocex.ui.action.Action;
import org.rocex.ui.action.ActionConst;

import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.rocex.settings.SettingConst;
import org.rocex.settings.Settings;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2019-5-13 22:43:11
 ***************************************************************************/
public class ExitAction : Action
{
    /***************************************************************************
     * @author Rocex Wang
     * @version 2019-5-13 22:43:11
     ***************************************************************************/
    public this()
    {
        super(ActionConst.id_exit);

        setText("Exit...");
        setToolTip("Exit App...");
        setAccelerator(SWT.CTRL | 'Q');
        setIconPath(ResHelper.res_icon_path ~ "delete.png");
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @version 2019-7-13 22:58:19
     ***************************************************************************/
    protected void beforeExit(Event evt)
    {
    }

    override public void doAction(Event evt)
    {
        // if (!MessageDialog.showConfirm(getContext().getApplication(), "exit app?"))
        // {
        // evt.doit = false;
        //
        // return;
        // }

        beforeExit(evt);

        saveWindowState();

        ResHelper.dispose();

        getActionManager().dispose();

        Settings.dispose();

        Display display = Display.getDefault();

        if (display !is null && !display.isDisposed())
        {
            display.dispose();
        }
    }

    /***************************************************************************
     * @author Rocex Wang
     * @version 2020-6-30 22:58:12
     ***************************************************************************/
    protected void saveWindowState()
    {
        const bool blMaximized = getApplication().getMaximized();

        Settings.setValue(SettingConst.window_maximized, blMaximized);

        if (!blMaximized)
        {
            Rectangle bounds = getApplication().getBounds();

            Settings.setValue(SettingConst.window_width, bounds.width);
            Settings.setValue(SettingConst.window_heigth, bounds.height);
        }
    }
}
