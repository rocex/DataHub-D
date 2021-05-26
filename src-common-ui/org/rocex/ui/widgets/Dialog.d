module org.rocex.ui.widgets.Dialog;

import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.rocex.ui.widgets.IWidget;
import org.rocex.ui.widgets.MessageDialog;
import org.rocex.ui.utils.UIHelper;
import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-23 22:21:09
 ***************************************************************************/
public class Dialog(T) : IWidget!(T)
{
    private int iReturnCode = SWT.NONE;

    protected Shell shell;

    /***************************************************************************
     * Params: parent
     * Params: iStyle
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:42:00
     ***************************************************************************/
    public this(Shell parent, int iStyle)
    {
        shell = new Shell(parent, SWT.DIALOG_TRIM | SWT.APPLICATION_MODAL | iStyle);

        shell.setText("Dialog");
        shell.setSize(600, 400);
        shell.setImage(ResHelper.getImage(ResHelper.res_root_path ~ "app.png"));

        createContents();

        Listener listener = new class Listener
        {
            void handleEvent(Event evt)
            {
                if (evt.character == SWT.CR)
                {
                    closeOk(evt);
                }
                else if (evt.character == SWT.ESC)
                {
                    closeCancel(evt);
                }
            }
        };

        shell.addListener(SWT.KeyUp, listener);
    }

    /***************************************************************************
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:16:55
     ***************************************************************************/
    protected bool checkBeforeOpen()
    {
        return true;
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:00:54
     ***************************************************************************/
    public void close()
    {
        if (shell is null || shell.isDisposed())
        {
            return;
        }

        shell.close();
    }

    /***************************************************************************
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:20:36
     * Params: evt
     ***************************************************************************/
    protected void closeCancel(Event evt)
    {
        iReturnCode = SWT.CANCEL;

        close();
    }

    /***************************************************************************
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:20:34
     * Params: evt
     ***************************************************************************/
    protected void closeOk(Event evt)
    {
        try
        {
            collectionReturnData();
        }
        catch (Exception ex)
        {
            MessageDialog.showError(shell, ex.msg);

            evt.doit = false;

            return;
        }

        iReturnCode = SWT.OK;

        close();
    }

    /***************************************************************************
     * 关闭对话框之前先收集对话框里面的数据，以备后续使用
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:36:08
     ***************************************************************************/
    protected void collectionReturnData()
    {
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:29:52
     * Params: parent
     ***************************************************************************/
    protected void createButtonArea(Composite parent)
    {
        Button btnOk = new Button(parent, SWT.NONE);
        btnOk.setText("&OK");

        Listener listenerOk = new class Listener
        {
            void handleEvent(Event evt)
            {
                closeOk(evt);
            }
        };

        btnOk.addListener(SWT.Selection, listenerOk);

        Button btnCancel = new Button(parent, SWT.NONE);
        btnCancel.setText("&Cancel");

        Listener listenerCancel = new class Listener
        {
            void handleEvent(Event evt)
            {
                closeCancel(evt);
            }
        };

        btnCancel.addListener(SWT.Selection, listenerCancel);

        shell.setDefaultButton(btnOk);
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:07:54
     ***************************************************************************/
    protected void createContents()
    {
        shell.setLayout(UIHelper.getFillGridLayout(1, true));

        Composite composite = new Composite(shell, SWT.NONE);
        composite.setLayout(new FillLayout());
        composite.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

        createDialogArea(composite);

        Label separator = new Label(shell, SWT.SEPARATOR | SWT.HORIZONTAL);
        separator.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

        Composite buttonArea = new Composite(shell, SWT.NONE);
        FillLayout layoutButtonArea = new FillLayout();
        layoutButtonArea.spacing = 5;
        layoutButtonArea.marginWidth = 5;
        layoutButtonArea.marginHeight = 5;
        buttonArea.setLayout(layoutButtonArea);
        buttonArea.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, true, false, 1, 1));

        createButtonArea(buttonArea);
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:30:09
     * Params: parent
     ***************************************************************************/
    protected void createDialogArea(Composite parent)
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#getValue()
     * Authors: Rocex Wang
     * Date: 2019-6-13 22:16:15
     ****************************************************************************/
    override public T getValue()
    {
        return null;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * Authors: Rocex Wang
     * Date: 2019-5-23 22:22:30
     ****************************************************************************/
    public int open()
    {
        if (!checkBeforeOpen())
        {
            return SWT.NONE;
        }

        shell.setLocation(UIHelper.getLocation(shell));

        shell.open();

        runEventLoop();

        return iReturnCode;
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-6-13 22:16:42
     ***************************************************************************/
    private void runEventLoop()
    {
        Display display = shell is null ? Display.getCurrent() : shell.getDisplay();

        while (shell !is null && !shell.isDisposed())
        {
            try
            {
                if (!display.readAndDispatch())
                {
                    display.sleep();
                }
            }
            catch (Exception ex)
            {
                Logger.getLogger().error(ex.msg, ex);

                MessageDialog.showError(shell, ex.msg);
            }
        }

        display.update();
    }

    /***************************************************************************
     * Params: iWidth
     * Params: iHeight
     * Authors: Rocex Wang
     * Date: 2019-5-25 22:06:04
     ***************************************************************************/
    public void setSize(int iWidth, int iHeight)
    {
        if (shell is null || shell.isDisposed())
        {
            return;
        }

        shell.setSize(iWidth, iHeight);
    }

    /***************************************************************************
     * Params: strTitle
     * Authors: Rocex Wang
     * Date: 2019-5-24 22:43:30
     ***************************************************************************/
    public void setTitle(string strTitle)
    {
        if (shell is null || shell.isDisposed())
        {
            return;
        }

        shell.setText(strTitle);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.IWidget#setValue(java.lang.Object)
     * Authors: Rocex Wang
     * Date: 2019-5-25 22:06:02
     ****************************************************************************/
    override public void setValue(T obj)
    {
    }
}
