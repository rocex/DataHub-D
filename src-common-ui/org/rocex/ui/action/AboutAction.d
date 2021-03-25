module org.rocex.ui.action.AboutAction;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Event;
import org.rocex.ui.AboutDialog;
import org.rocex.ui.action.Action;
import org.rocex.ui.action.ActionConst;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * about<br>
 * @author Rocex Wang
 * @since 2019-5-11 22:32:50
 ***************************************************************************/
public class AboutAction : Action
{
    /***************************************************************************
     * @param strId
     * @author Rocex Wang
     * @since 2019-5-11 22:33:01
     ***************************************************************************/
    public this()
    {
        super(ActionConst.id_about);

        setText("About...");
        setToolTip("About...");
        setAccelerator(SWT.CTRL | '0');
        setIconPath(ResHelper.res_icon_path ~ "new.png");
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.action.Action#doAction(org.eclipse.swt.events.SelectionEvent)
     * @author Rocex Wang
     * @since 2019-5-11 22:32:50
     ****************************************************************************/
    override public void doAction(Event evt)
    {
        AboutDialog dialog = new AboutDialog(getApplication(), SWT.NONE);
        dialog.open();
    }
}
