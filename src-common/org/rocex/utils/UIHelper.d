module org.rocex.utils.UIHelper;

import java.lang.String;

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

import org.rocex.ui.Application;
import org.rocex.ui.Context;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-21 21:21:25
 ***************************************************************************/
public class UIHelper
{
    ///
    public static int iBarHeight = 28;

    ///
    public static int iSashDefaultWidth = 4;

    /***************************************************************************
     * 鼠标进入时，控件自动获得焦点，鼠标离开时，让控件所在的shell获得焦点
     * @param control
     * @author Rocex Wang
     * @since 2019-5-28 21:35:12
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
     * @param parent
     * @return
     * @author Rocex Wang
     * @since 2019-5-9 21:22:07
     ***************************************************************************/
    public static Label createBarSeparator(Composite parent)
    {
        return createBarSeparator(parent, iBarHeight);
    }

    /***************************************************************************
     * @param parent
     * @param heightHint
     * @return
     * @author Rocex Wang
     * @since 2019-5-8 21:04:11
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
     * @param control
     * @return Context
     * @author Rocex Wang
     * @since 2020-7-25 21:28:01
     ***************************************************************************/
    public static Context getContext(Control control)
    {
        Control control2 = control;

        while (true)
        {
            if (control2.classinfo.name == Application.classinfo.name)
            {
                return (cast(Application) control2).getContext();
            }

            control2 = control2.getParent();
        }
    }

    /***************************************************************************
     * @param iNumColumns
     * @param blMakeColumnsEqualWidth
     * @return GridLayout
     * @author Rocex Wang
     * @since 2019-5-8 21:04:15
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
     * @param shell
     * @return Point 打开shell的位置
     * @author Rocex Wang
     * @since 2019-5-23 21:03:43
     ***************************************************************************/
    public static Point getLocation(Shell shell)
    {
        Display display = Display.getCurrent() is null ? Display.getDefault() : Display.getCurrent();

        Rectangle boundScreen = display.getBounds();

        Rectangle boundParent = shell.getParent().getBounds();

        Rectangle boundDialog = shell.getBounds();

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
     * 把shell显示在屏幕中心，shell中心和屏幕中心位置重合
     * @return Point 打开shell的位置
     * @author Rocex Wang
     * @since 2019-5-28 21:09:01
     ***************************************************************************/
    public static Point getScreenCenterLocation(Shell shell)
    {
        Display display = Display.getCurrent() is null ? Display.getDefault() : Display.getCurrent();

        Rectangle boundScreen = display.getBounds();

        Rectangle boundDialog = shell.getBounds();

        int x = boundScreen.width / 2 - boundDialog.width / 2;
        int y = boundScreen.height / 2 - boundDialog.height / 2;

        return new Point(x, y);
    }

    /***************************************************************************
     * @param strTitle
     * @return strTitle 占用的像素
     * @author Rocex Wang
     * @since 2019-5-30 21:45:01
     ***************************************************************************/
    public static int getTitleWidth(String strTitle)
    {
        GC gc = new GC(Display.getCurrent());

        Point pointChar = gc.stringExtent(strTitle);

        gc.dispose();

        return pointChar.x;
    }
}
