module org.rocex.utils.ResHelper;

import core.thread;
import java.lang.String;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.ImageData;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Widget;
import org.rocex.utils.Logger;
import std.conv;
import std.file;
import std.stdio;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-8 21:22:11
 ***************************************************************************/
public class ResHelper
{
    private static Color[string] resColor;
    private static Font[string] resFont;
    private static Image[string] resImage;

    /***/
    public static String res_icon_path = "resource/icon/";

    /***/
    public static String res_progress_path = "resource/icon/progress/";

    /***/
    public static String res_root_path = "resource/";

    /***************************************************************************
     * @param closeables
     * @author Rocex Wang
     * @since 2020-5-25 21:23:18
     ***************************************************************************/
    public static void close(File[] closeables...)
    {
        if (closeables is null || closeables.length == 0)
        {
            return;
        }

        foreach (File closeable; closeables)
        {
            if (is(typeof(closeable) == typeof(null)))
            {
                continue;
            }

            try
            {
                closeable.close();
            }
            catch (Exception ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
        }
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-7-1 21:16:48
     ***************************************************************************/
    public static void dispose()
    {
        disposeColors();
        disposeImages();
        disposeFonts();
    }

    /***************************************************************************
     * @param widgets
     * @author Rocex Wang
     * @since 2020-7-4 21:24:40
     ***************************************************************************/
    public static void dispose(Widget[] widgets)
    {
        if (widgets is null || widgets.length == 0)
        {
            return;
        }

        foreach (Widget widget; widgets)
        {
            if (widget !is null && !widget.isDisposed())
            {
                widget.dispose();
            }
        }
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-7-18 21:55:54
     ***************************************************************************/
    public static void disposeColors()
    {
        if (resColor is null)
        {
            return;
        }

        Logger.getLogger().infof("dispose [%d] colors", (resColor.length));

        foreach (key, color; resColor)
        {
            if (color !is null && !color.isDisposed())
            {
                color.dispose();
            }
        }

        resColor.clear();
        resColor = null;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-7-18 21:56:02
     ***************************************************************************/
    public static void disposeFonts()
    {
        if (resFont is null)
        {
            return;
        }

        Logger.getLogger().infof("dispose [%d] fonts", resFont.length);

        foreach (key, font; resFont)
        {
            if (font !is null && !font.isDisposed())
            {
                font.dispose();
            }
        }

        resFont.clear();
        resFont = null;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-07-31 21:50:31
     ***************************************************************************/
    public static void disposeImage(String strFilePath)
    {
        if (resImage is null)
        {
            return;
        }

        Logger.getLogger().infof("dispose [%d] image ", resImage.length);

        if (strFilePath in resImage)
        {
            auto image = resImage[strFilePath];

            if (image !is null && !image.isDisposed())
            {
                image.dispose();
            }

        }

        resImage.clear();
        resImage = null;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-7-1 21:16:55
     ***************************************************************************/
    public static void disposeImages()
    {
        if (resImage is null)
        {
            return;
        }

        Logger.getLogger().infof("dispose [%d] images", resImage.length);

        foreach (key, image; resImage)
        {
            if (image !is null && !image.isDisposed())
            {
                image.dispose();
            }
        }

        resImage.clear();
        resImage = null;
    }

    /***************************************************************************
     * @param iSystemColorID
     * @return Color
     * @author Rocex Wang
     * @since 2019-7-18 21:02:44
     ***************************************************************************/
    public static Color getColor(int iSystemColorID)
    {
        String strKey = to!String(iSystemColorID);

        Color color = strKey in resColor ? resColor[strKey] : null;

        if (color is null || color.isDisposed())
        {
            color = Display.getDefault().getSystemColor(iSystemColorID);

            resColor[strKey] = color;
        }

        return color;
    }

    /***************************************************************************
     * @param r
     * @param g
     * @param b
     * @return Color
     * @author Rocex Wang
     * @since 2019-7-18 21:10:45
     ***************************************************************************/
    public static Color getColor(int r, int g, int b)
    {
        return getColor(new RGB(r, g, b));
    }

    /***************************************************************************
     * @param rgb
     * @return Color
     * @author Rocex Wang
     * @since 2019-7-18 21:05:38
     ***************************************************************************/
    public static Color getColor(RGB rgb)
    {
        string strRGB = to!string(rgb);

        Color color = strRGB in resColor ? resColor[strRGB] : null;

        if (color is null)
        {
            color = new Color(Display.getDefault(), rgb);

            resColor[strRGB] = color;
        }

        return color;
    }

    /***************************************************************************
     * @param name
     * @param height
     * @param style
     * @return Font
     * @author Rocex Wang
     * @since 2019-7-18 21:54:59
     ***************************************************************************/
    public static Font getFont(String name, int height, int style)
    {
        String fontName = name ~ '|' ~ to!String(height) ~ '|' ~ to!String(style);

        Font font = resFont[fontName];

        if (font is null)
        {
            FontData fontData = new FontData(name, height, style);

            font = new Font(Display.getDefault(), fontData);

            resFont[fontName] = font;
        }

        return font;
    }

    /***************************************************************************
     * @param strFilePath
     * @return Image
     * @author Rocex Wang
     * @since 2019-7-1 21:17:07
     ***************************************************************************/
    public static Image getImage(String strFilePath)
    {
        Logger.getLogger().info("image: " ~ strFilePath);

        Image image = null;

        if (resImage !is null && strFilePath in resImage)
        {
            return resImage[strFilePath];
        }

        Logger.getLogger().warningf("image [%s] is not cached, load it from disk", strFilePath);

        try
        {
            image = new Image(Display.getDefault(), "./" ~ strFilePath);

            // auto data = cast(immutable(byte[])) import(strFilePath);

            // auto bin = new ByteArrayInputStream(cast(byte[]) import("DataHub.gif"));
            // image = new Image(Display.getDefault(), new ImageData(bin));
        }
        catch (Exception ex)
        {
            Logger.getLogger().error("load image error: " ~ ex.toString());

            image = getMissingImage();
        }

        resImage[strFilePath] = image;

        return image;
    }

    private static Image getMissingImage()
    {
        Image image = new Image(Display.getCurrent(), 9, 9);

        GC gc = new GC(image);
        gc.setBackground(getColor(SWT.COLOR_RED));
        gc.fillRectangle(0, 0, 9, 9);
        gc.dispose();

        return image;
    }

    /***************************************************************************
     * 得到 resource\icon 目录下的图片
     * @param strFileName icon文件名
     * @return Image
     * @author Rocex Wang
     * @since 2020-6-9 21:55:06
     ***************************************************************************/
    public static Image getImageIcon(String strFileName)
    {
        return getImage(res_icon_path ~ strFileName);
    }

    /***************************************************************************
     * @param lMillis
     * @author Rocex Wang
     * @since 2020-6-8 21:16:22
     ***************************************************************************/
    public static void sleep(long lMillis)
    {
        Thread.sleep(dur!("msecs")(lMillis));
    }
}
