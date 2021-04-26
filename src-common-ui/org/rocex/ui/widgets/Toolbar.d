module org.rocex.ui.widgets.Toolbar;

import std.conv;
import java.lang.Math;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.ToolBar;
import org.eclipse.swt.widgets.ToolItem;
import org.rocex.settings.SettingConst;
import org.rocex.settings.Settings;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.IAction;
import org.rocex.ui.action.Separator;
import org.rocex.ui.Context;
import org.rocex.utils.ActionHelper;
import org.rocex.utils.ResHelper;
import org.rocex.utils.UIHelper;

/***************************************************************************
 * 工具栏<br>
 * Authors: Rocex Wang
 * Date: 2019-5-7 22:03:01
 ***************************************************************************/
public class Toolbar : ToolBar
{
    /** 自适应大小的空白占位符，会挤占剩余的所有空间 */
    private const string auto_width_spacer = "auto_width_spacer";

    private Context context;

    /** 是否已添加 自适应大小的空白占位符 的监听 */
    private bool isAddAutoSpacerListener = false;

    /***************************************************************************
     * Params: parent
     * Params: iStyle
     * Authors: Rocex Wang
     * Date: 2019-5-8 22:03:48
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, SWT.FLAT | iStyle);

        context = UIHelper.getContext(parent);

        // addMouseMoveListener(evt -> showHintMessage(evt));
    }

    /***************************************************************************
     * Params: action
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:20:26
     ***************************************************************************/
    public ToolItem addAction(IAction action)
    {
        return addAction(action, getItemCount());
    }

    /***************************************************************************
     * Params: action
     * Params: iIndex
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:20:26
     ***************************************************************************/
    public ToolItem addAction(IAction action, int iIndex)
    {
        if (is(typeof(action) == typeof(Separator.classinfo)))
        {
            return addSeparator(iIndex);
        }

        ToolItem item = new ToolItem(this, SWT.PUSH, iIndex);

        item.setData(ActionConst.bind_action_with_item, cast(Object) action);
        item.setImage(ResHelper.getImage(action.getIconPath()));
        item.setToolTipText(action.getToolTip() ~ "  (" ~ ActionHelper.convertAccelerator(
                action.getAccelerator()) ~ ")");

        action.addBindingItem(item);
        action.setContext(getContext());

        if (Settings.getBoolean(SettingConst.toolbar_show_text, false))
        {
            item.setText(action.getText());
        }

        if (action.getAccelerator() != SWT.NONE)
        {
        }

        Listener listener = new class Listener
        {
            void handleEvent(Event evt)
            {
                if (evt.widget !is null)
                {
                    getContext().getApplication().showHintMessage(action.getToolTip());

                    action.run(evt);
                }
            }
        };

        item.addListener(SWT.Selection, listener);

        return item;
    }

    /***************************************************************************
     * Params: strActionIds
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:20:26
     ***************************************************************************/
    public void addAction(int iIndex, string[] strActionIds...)
    {
        foreach (string strActionId; strActionIds)
        {
            if (ActionConst.id_separator == (strActionId))
            {
                addSeparator(iIndex);
            }
            else
            {
                IAction action = getContext().getActionManager().getAction(strActionId);

                addAction(action, iIndex);
            }
        }
    }

    /***************************************************************************
     * Params: strActionIds
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:20:26
     ***************************************************************************/
    public void addAction(string[] strActionIds...)
    {
        foreach (string strActionId; strActionIds)
        {
            if (ActionConst.id_separator == (strActionId))
            {
                addSeparator();
            }
            else
            {
                IAction action = getContext().getActionManager().getAction(strActionId);

                addAction(action);
            }
        }
    }

    /***************************************************************************
     * 自适应大小的空白占位符，会挤占剩余的所有空间
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:19:20
     ***************************************************************************/
    public ToolItem addAutoWidthSpacer()
    {
        return addAutoWidthSpacer(getItemCount());
    }

    /***************************************************************************
     * 自适应大小的空白占位符，会挤占剩余的所有空间
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:19:20
     ***************************************************************************/
    public ToolItem addAutoWidthSpacer(int iIndex)
    {
        Label lblSpace = new Label(this, SWT.NONE);

        ToolItem item = addCustomControl(lblSpace, lblSpace.getSize().x, iIndex);

        // item.setData(auto_width_spacer, cast(Object)(auto_width_spacer.dup()));

        if (!isAddAutoSpacerListener)
        {
            // addListener(SWT.Resize, evt -> getDisplay().asyncExec(() -> autoWidthSpacer()));
            Listener listener = new class Listener
            {
                void handleEvent(Event evt)
                {
                    autoWidthSpacer();
                }
            };

            addListener(SWT.Resize, listener);

            isAddAutoSpacerListener = true;
        }

        return item;
    }

    /***************************************************************************
     * Params: control
     * Authors: Rocex Wang
     * Date: 2019-5-13 22:18:53
     ***************************************************************************/
    public ToolItem addCustomControl(Control control)
    {
        control.pack();

        return addCustomControl(control, control.getSize().x);
    }

    /***************************************************************************
     * Params: control
     * Params: iWidth
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:46:29
     ***************************************************************************/
    public ToolItem addCustomControl(Control control, int iWidth)
    {
        return addCustomControl(control, iWidth, getItemCount());
    }

    /***************************************************************************
     * Params: control
     * Params: iWidth
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:46:29
     ***************************************************************************/
    public ToolItem addCustomControl(Control control, int iWidth, int iIndex)
    {
        ToolItem item = addSeparator(iIndex);

        item.setWidth(iWidth + 1);
        item.setControl(control);

        return item;
    }

    /***************************************************************************
     * Returns: Separator item
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:58:44
     ***************************************************************************/
    public ToolItem addSeparator()
    {
        return addSeparator(getItemCount());
    }

    /***************************************************************************
     * Returns: Separator item
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:58:44
     ***************************************************************************/
    public ToolItem addSeparator(int iIndex)
    {
        return new ToolItem(this, SWT.SEPARATOR, iIndex);
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:23:25
     ***************************************************************************/
    protected void autoWidthSpacer()
    {
        // pack();

        ToolItem[] items = getItems();

        ToolItem[] itemSpacer;

        int iTotalWidth = 0;

        foreach (ToolItem item; items)
        {
            if (auto_width_spacer == (to!(string)(item.getData(auto_width_spacer))))
            {
                itemSpacer[$] = item;
                continue;
            }

            iTotalWidth += item.getWidth();
        }

        if (itemSpacer is null || itemSpacer.length == 0)
        {
            return;
        }

        int iSpacerWidth = cast(int)((getParent().getSize().x - iTotalWidth) / itemSpacer.length);

        foreach (ToolItem spacer; itemSpacer)
        {
            spacer.setWidth(Math.abs(iSpacerWidth));
        }
    }

    override protected void checkSubclass()
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * Authors: Rocex Wang
     * Date: 2020-7-4 22:29:09
     ****************************************************************************/
    override public void dispose()
    {
        ToolItem[] items = getItems();

        if (items !is null && items.length > 0)
        {
            foreach (ToolItem item; items)
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

                if (item.getControl() !is null && !item.getControl().isDisposed())
                {
                    item.getControl().dispose();
                }

                if (!item.isDisposed())
                {
                    item.dispose();
                }
            }
        }

        super.dispose();
    }

    /***************************************************************************
     * Returns: the context
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:58:05
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }

    /***************************************************************************
     * Params: context the context to set
     * Authors: Rocex Wang
     * Date: 2020-6-1 22:58:05
     ***************************************************************************/
    public void setContext(Context context)
    {
        this.context = context;
    }

    /***************************************************************************
     * Params: evt
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:18:32
     ***************************************************************************/
    protected void showHintMessage(MouseEvent evt)
    {
        ToolItem item = getItem(new Point(evt.x, evt.y));

        if (item is null)
        {
            return;
        }

        Object data = item.getData(ActionConst.bind_action_with_item);

        if (data is null || (data.classinfo !is IAction.classinfo))
        {
            return;
        }

        string strHintMessage = (cast(IAction) data).getToolTip();

        getContext().getApplication().showHintMessage(strHintMessage);
    }
}
