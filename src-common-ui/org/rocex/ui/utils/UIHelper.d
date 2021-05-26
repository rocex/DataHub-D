module org.rocex.ui.utils.UIHelper;

import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.rocex.ui.app;
import org.rocex.ui.Context;
import org.rocex.utils.Logger;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-21 21:21:25
 ***************************************************************************/
public class UIHelper
{
    ///
    public static int iBarHeight = 28;

    ///
    public static int iSashDefaultWidth = 4;

    ///
    public static Context context;

    /***************************************************************************
     * 鼠标进入时，控件自动获得焦点，鼠标离开时，让控件所在的shell获得焦点
     * Params: control
     * Authors: Rocex Wang
     * Date: 2019-5-28 21:35:12
     ***************************************************************************/
    public static void addMouseTrackListener(Control control)
    {
        if (control is null || control.isDisposed())
        {
            return;
        }

        // control.addListener(SWT.MouseEnter, evt -> ((Control) evt.widget).forceFocus());
        // control.addListener(SWT.MouseExit, evt -> ((Control) evt.widget).getShell().forceFocus());
    }

    /***************************************************************************
     * 把shell居中屏幕显示
     * Params: shell
     * Authors: Rocex Wang
     * Date: 2021-3-30 22:33:15
     ***************************************************************************/
    public static void centerScreen(Shell shell)
    {
        Display display = Display.getCurrent() is null ? Display.getDefault() : Display.getCurrent();

        Rectangle boundScreen = display.getBounds();

        centerScreen(shell, boundScreen.width / 2, boundScreen.height / 2);
    }

    /***************************************************************************
     * 先给shell设置大小，然后再居中屏幕显示
     * Params: shell
     * Params: iWidth
     * Params: iHeight
     * Authors: Rocex Wang
     * Date: 2021-3-30 22:40:55
     ***************************************************************************/
    public static void centerScreen(Shell shell, int iWidth, int iHeight)
    {
        shell.setSize(iWidth, iHeight);

        shell.setLocation(getScreenCenterLocation(shell));
    }

    /***************************************************************************
     * Params: parent
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-9 21:22:07
     ***************************************************************************/
    public static Label createBarSeparator(Composite parent)
    {
        return createBarSeparator(parent, iBarHeight);
    }

    /***************************************************************************
     * Params: parent
     * Params: heightHint
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-8 21:04:11
     ***************************************************************************/
    public static Label createBarSeparator(Composite parent, int heightHint)
    {
        Label label = new Label(parent, SWT.SEPARATOR);

        GridData gridData = new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1);
        gridData.heightHint = heightHint < iBarHeight
            || heightHint > iBarHeight + 10 ? iBarHeight : heightHint;
        label.setLayoutData(gridData);

        return label;
    }

    /***************************************************************************
     * 查找上下文
     * Params: control
     * Returns: Context
     * Authors: Rocex Wang
     * Date: 2020-7-25 21:28:01
     ***************************************************************************/
    public static Context getContext(Control control)
    {
        Control control2 = control;

        while (true)
        {
            if (control2 is null || control2.classinfo is null)
            {
                Logger.getLogger.warning("control is null,return default context!");
                return context;
            }

            if (Application.classinfo.name == typeof(control2).classinfo.name
                    || Application.classinfo.name == typeid(control2).base.name)
            {
                return (cast(Application) control2).getContext();
            }

            control2 = control2.getParent();
        }
    }

    /***************************************************************************
     * Params: iNumColumns
     * Params: blMakeColumnsEqualWidth
     * Returns: GridLayout
     * Authors: Rocex Wang
     * Date: 2019-5-8 21:04:15
     ***************************************************************************/
    public static GridLayout getFillGridLayout(int iNumColumns, bool blMakeColumnsEqualWidth)
    {
        GridLayout layout = new GridLayout(iNumColumns, blMakeColumnsEqualWidth);

        layout.marginWidth = 0;
        layout.marginHeight = 0;
        layout.verticalSpacing = 0;
        layout.horizontalSpacing = 0;

        return layout;
    }

    /***************************************************************************
     * 把shell显示在相对于parent的中间位置（shell中心和parent中心位置重合），如果parent靠近四边，则显示在附近可完整显示的区域
     * Params: shell
     * Returns: Point 打开shell的位置
     * Authors: Rocex Wang
     * Date: 2019-5-23 21:03:43
     ***************************************************************************/
    public static Point getLocation(Shell shell)
    {
        Display display = Display.getCurrent() is null ? Display.getDefault() : Display.getCurrent();

        const Rectangle boundDialog = shell.getBounds();
        const Rectangle boundScreen = display.getBounds();
        const Rectangle boundParent = shell.getParent().getBounds();

        int x = boundParent.width / 2 + boundParent.x - boundDialog.width / 2;
        int y = boundParent.height / 2 + boundParent.y - boundDialog.height / 2;

        x = x >= 30 ? x : 30;
        y = y >= 30 ? y : 30;

        x = x + boundDialog.width > boundScreen.width ? boundScreen.width - boundDialog.width
            - 30 : x;
        y = y + boundDialog.height > boundScreen.height
            ? boundScreen.height - boundDialog.height - 60 : y;

        return new Point(x, y);
    }

    /***************************************************************************
     * shell显示在屏幕中心，shell中心和屏幕中心位置重合
     * Returns: Point shell居中时左上角的位置
     * Authors: Rocex Wang
     * Date: 2019-5-28 21:09:01
     ***************************************************************************/
    public static Point getScreenCenterLocation(Shell shell)
    {
        Display display = Display.getCurrent() is null ? Display.getDefault() : Display.getCurrent();

        const Rectangle boundScreen = display.getBounds();
        const Rectangle boundDialog = shell.getBounds();

        const int x = boundScreen.width / 2 - boundDialog.width / 2;
        const int y = boundScreen.height / 2 - boundDialog.height / 2;

        return new Point(x, y);
    }

    /***************************************************************************
     * Params: strTitle
     * Returns: strTitle 占用的像素
     * Authors: Rocex Wang
     * Date: 2019-5-30 21:45:01
     ***************************************************************************/
    public static int getTitleWidth(string strTitle)
    {
        GC gc = new GC(Display.getCurrent());

        Point pointChar = gc.stringExtent(strTitle);

        gc.dispose();

        return pointChar.x;
    }
}
