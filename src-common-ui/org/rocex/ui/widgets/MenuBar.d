module org.rocex.ui.widgets.MenuBar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Decorations;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.swt.widgets.MenuItem;
import org.eclipse.swt.widgets.Widget;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.IAction;
import org.rocex.ui.action.Separator;
import org.rocex.ui.Context;
import org.rocex.ui.utils.ActionHelper;
import org.rocex.ui.utils.UIHelper;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * 菜单栏<br>
 * Authors: Rocex Wang
 * Date: 2019-5-13 22:09:27
 ***************************************************************************/
public class MenuBar : Menu
{
    private Context context;

    /***************************************************************************
     * Params: parent
     * Authors: Rocex Wang
     * Date: 2019-6-3 22:55:59
     ***************************************************************************/
    public this(Control parent)
    {
        super(parent);

        context = UIHelper.getContext(parent);
    }

    /***************************************************************************
     * Params: parent
     * Params: iStyle
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:34:24
     ***************************************************************************/
    public this(Decorations parent, int iStyle)
    {
        super(parent, iStyle);

        context = UIHelper.getContext(parent);
    }

    /***************************************************************************
     * Params: actions
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:20:26
     ***************************************************************************/
    public void addAction(Menu menu, IAction[] actions...)
    {
        if (actions is null || actions.length == 0)
        {
            return;
        }

        foreach (IAction action; actions)
        {
            if (typeof(action).classinfo.name == Separator.classinfo.name)
            {
                addSeparator(menu);

                continue;
            }

            MenuItem item = new MenuItem(menu, SWT.NONE);

            string strAccelerator = ActionHelper.convertAccelerator(action.getAccelerator());

            item.setData(ActionConst.bind_action_with_item, cast(Object) action);
            item.setText(action.getText() ~ "\t" ~ strAccelerator);
            item.setImage(ResHelper.getImage(action.getIconPath()));
            //item.setToolTipText(action.getToolTip() ~ "\t" ~ strAccelerator);

            action.addBindingItem(item);
            action.setContext(getContext());

            if (action.getAccelerator() != SWT.NONE)
            {
                item.setAccelerator(action.getAccelerator());
            }

            Listener listener = new class Listener
            {
                void handleEvent(Event evt)
                {
                    if (evt.widget !is null)
                    {
                        action.run(evt);
                    }
                }
            };

            item.addListener(SWT.Selection, listener);
        }

        getContext().getActionManager().registerAction(actions);
    }

    /***************************************************************************
     * Params: menu
     * Params: strActionIds
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:20:26
     ***************************************************************************/
    public void addAction(Menu menu, string[] strActionIds...)
    {
        foreach (string strActionId; strActionIds)
        {
            if (ActionConst.id_separator == strActionId)
            {
                addSeparator(menu);
            }
            else
            {
                IAction action = getContext().getActionManager().getAction(strActionId);

                addAction(menu, action);
            }
        }
    }

    /***************************************************************************
     * Params: menu
     * Params: strText
     * Returns: Menu
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:45:53
     ***************************************************************************/
    public Menu addCascadeMenu(Menu menu, string strText)
    {
        MenuItem item = new MenuItem(menu, SWT.CASCADE);
        item.setText(strText);

        Menu menu1 = new Menu(item);
        item.setMenu(menu1);

        return menu1;
    }

    /***************************************************************************
     * Params: menu
     * Params: strText
     * Params: strActionIds
     * Returns: Menu
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:45:53
     ***************************************************************************/
    public Menu addCascadeMenu(Menu menu, string strText, string[] strActionIds...)
    {
        Menu menu1 = addCascadeMenu(menu, strText);

        addAction(menu1, strActionIds);

        return menu1;
    }

    /***************************************************************************
     * Params: menu
     * Authors: Rocex Wang
     * Date: 2019-5-14 22:46:00
     ***************************************************************************/
    public void addSeparator(Menu menu)
    {
        new MenuItem(menu, SWT.SEPARATOR);
    }

    override protected void checkSubclass()
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * Authors: Rocex Wang
     * Date: 2020-7-4 22:49:22
     ****************************************************************************/
    override public void dispose()
    {
        MenuItem[] items = getItems();

        if (items !is null && items.length > 0)
        {
            foreach (MenuItem item; items)
            {
                if (item is null)
                {
                    continue;
                }

                IAction action = cast(IAction) item.getData(ActionConst.bind_action_with_item);

                if (action !is null)
                {
                    action.removeBindingItem(item);
                }

                if (!item.isDisposed())
                {
                    // item.setToolTipText(null);

                    item.dispose();
                }
            }
        }

        super.dispose();
    }

    /***************************************************************************
     * Returns: the context
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:57:01
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * Params: context the context to set
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:57:01
     ***************************************************************************/
    public void setContext(Context context)
    {
        this.context = context;
    }
}
