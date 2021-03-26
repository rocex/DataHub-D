module org.rocex.ui.widgets.MessageDialog;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;
import org.rocex.utils.StringHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-21 22:20:20
 ***************************************************************************/
public class MessageDialog : MessageBox
{
    /***************************************************************************
     * 询问: ok|cancel
     * @param parent
     * @param strMessage
     * @return <code>true</code> if the user presses the OK button, <code>false</code> otherwise
     * @author Rocex Wang
     * @since 2019-5-22 22:32:34
     ***************************************************************************/
    public static bool showConfirm(Shell parent, string strMessage)
    {
        MessageDialog dialog = new MessageDialog(parent, SWT.OK | SWT.CANCEL | SWT.ICON_QUESTION);

        dialog.setText("询问");
        dialog.setMessage(StringHelper.defaultString(strMessage));

        const int iResult = dialog.open();

        return SWT.OK == iResult;
    }

    /***************************************************************************
     * 错误
     * @param parent
     * @param strMessage
     * @author Rocex Wang
     * @since 2019-5-22 22:34:34
     ***************************************************************************/
    public static void showError(Shell parent, string strMessage)
    {
        MessageDialog dialog = new MessageDialog(parent, SWT.ICON_ERROR);

        dialog.setText("错误");
        dialog.setMessage(StringHelper.defaultString(strMessage));

        dialog.open();
    }

    /***************************************************************************
     * 信息
     * @param parent
     * @param strMessage
     * @author Rocex Wang
     * @since 2019-5-22 22:32:36
     ***************************************************************************/
    public static void showInformation(Shell parent, string strMessage)
    {
        MessageDialog dialog = new MessageDialog(parent, SWT.ICON_INFORMATION);

        dialog.setText("信息");
        dialog.setMessage(StringHelper.defaultString(strMessage));

        dialog.open();
    }

    /***************************************************************************
     * 询问:yes|no|cancel
     * @param parent
     * @param strMessage
     * @return <code>true</code> if the user presses the Yes button, <code>false</code> otherwise
     * @author Rocex Wang
     * @since 2019-5-22 22:34:30
     ***************************************************************************/
    public static int showQuestion(Shell parent, string strMessage)
    {
        MessageDialog dialog = new MessageDialog(parent,
                SWT.YES | SWT.NO | SWT.CANCEL | SWT.ICON_QUESTION);

        dialog.setText("询问");
        dialog.setMessage(StringHelper.defaultString(strMessage));

        return dialog.open();
    }

    /***************************************************************************
     * 警告
     * @param parent
     * @param strMessage
     * @author Rocex Wang
     * @since 2019-5-22 22:34:28
     ***************************************************************************/
    public static void showWarning(Shell parent, string strMessage)
    {
        MessageDialog dialog = new MessageDialog(parent, SWT.ICON_WARNING);

        dialog.setText("警告");
        dialog.setMessage(StringHelper.defaultString(strMessage));

        dialog.open();
    }

    /***************************************************************************
     * @param parent
     * @param style
     * @author Rocex Wang
     * @since 2019-5-21 22:20:20
     ***************************************************************************/
    private this(Shell parent, int style)
    {
        super(parent, style);
    }

    override protected void checkSubclass()
    {
    }
}
