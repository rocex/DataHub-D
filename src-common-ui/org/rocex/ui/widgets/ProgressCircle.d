module org.rocex.ui.widgets.ProgressCircle;

import std.conv;

import java.lang.all;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.widgets.Widget;
import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * 把带有图标的控件的图标换成转圈的动画图标，并在任务完成之后恢复成原有图标<br>
 * @author Rocex Wang
 * @since 2020-6-8 22:06:48
 ***************************************************************************/
public class ProgressCircle
{
    private Runnable animationTimer;

    private int iCurrent;

    private Image imageOriginal;

    private Image[] images;

    private int iRepeatCount;

    private Method methodGetImage;
    private Method methodSetImage;

    private Widget widget; // 带有图标的控件

    /***************************************************************************
     * @param widget 带有图标的控件，该控件必须带有 getImage()、setImage(Image) 方法
     * @author Rocex Wang
     * @since 2020-6-8 22:40:49
     ***************************************************************************/
    public this(Widget widget)
    {
        this.widget = widget;

        try
        {
            //todo
            // methodGetImage = widget.getClass().getMethod("getImage");
            // methodSetImage = widget.getClass().getMethod("setImage", Image.classinfo);
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }

        imageOriginal = getWidgetImage();

        const int iLength = 8;

        images = new Image[iLength];

        for (int i = 0; i < iLength; i++)
        {
            images[i] = ResHelper.getImage(ResHelper.res_progress_path ~ (to!string(i + 1)) ~ ".png");
        }
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-7-6 22:09:44
     ***************************************************************************/
    protected void dispose()
    {
        images = null;

        methodGetImage = null;
        methodSetImage = null;

        animationTimer = null;
    }

    /***************************************************************************
     * @return Image
     * @author Rocex Wang
     * @since 2020-6-9 22:06:03
     ***************************************************************************/
    protected Image getWidgetImage()
    {
        try
        {
            if (methodGetImage !is null)
            {
                return cast(Image) methodGetImage.invoke(widget, null);
            }
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }

        return null;
    }

    /***************************************************************************
     * @param image
     * @author Rocex Wang
     * @since 2020-6-9 22:06:11
     ***************************************************************************/
    protected void setWidgetImage(Image image)
    {
        try
        {
            if (methodSetImage !is null)
            {
                //todo methodSetImage.invoke(widget, image);
            }
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }
    }

    /***************************************************************************
     * 开始执行动画图标
     * @author Rocex Wang
     * @since 2020-6-9 22:06:16
     ***************************************************************************/
    public ProgressCircle start()
    {
        if (images is null || images.length < 2)
        {
            return this;
        }

        if (widget is null || widget.isDisposed())
        {
            return this;
        }

        int[] iDelay = new int[1];

        iDelay[0] = (iDelay[0] = images[iCurrent].getImageData().delayTime * 10) <= 60 ? 100
            : iDelay[0];

        animationTimer = new class Runnable
        {
            override public void run()
            {
                if (widget.isDisposed())
                {
                    return;
                }

                iCurrent = cast(int)((iCurrent + 1) % images.length);

                if (iCurrent + 1 == images.length && iRepeatCount != 0 && --iRepeatCount <= 0)
                {
                    return;
                }

                setWidgetImage(images[iCurrent]);

                widget.getDisplay().timerExec(iDelay[0], this);
            }
        };

        widget.getDisplay().timerExec(iDelay[0], animationTimer);

        return this;
    }

    /***************************************************************************
     * 停止执行动画图标
     * @author Rocex Wang
     * @since 2020-6-9 22:06:37
     ***************************************************************************/
    public void stop()
    {
        if (animationTimer is null || widget is null || widget.isDisposed())
        {
            return;
        }

        Runnable stopThread = new class Runnable
        {
            override public void run()
            {
                widget.getDisplay().timerExec(-1, animationTimer);
                setWidgetImage(imageOriginal);

                dispose();
            }
        };

        widget.getDisplay().asyncExec(stopThread);
    }
}
