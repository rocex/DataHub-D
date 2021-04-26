module org.rocex.utils.FileHelper;

import java.lang.Thread;
import org.rocex.utils.Logger;
import std.file;
import std.path;
import std.string;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2020-4-28 21:19:15
 ***************************************************************************/
public class FileHelper
{
    /***************************************************************************
     * 拷贝文件夹下所有的文件夹和文件
     * Params: pathFrom
     * Params: pathTo
     * Authors: Rocex Wang
     * Date: 2020-4-28 21:36:51
     ***************************************************************************/
    public static void copyFolder(string pathFrom, string pathTo)
    {
        if (!exists(pathFrom))
        {
            throw new FileException("源文件夹不存在");
        }

        if (!exists(pathTo))
        {
            mkdirRecurse(pathTo);
        }

        auto entries = dirEntries(pathFrom, SpanMode.breadth);

        foreach (entry; entries)
        {
            // todo copy();
        }
    }

    /***************************************************************************
     * 在新线程下拷贝文件夹下所有的文件夹和文件
     * Params: pathFrom
     * Params: pathTo
     * Params: options
     * Authors: Rocex Wang
     * Date: 2020-5-11 21:36:23
     ***************************************************************************/
    public static void copyFolderThread(string pathFrom, string pathTo)
    {
        Thread thread = new class Thread
        {
            override public void run()
            {
                try
                {
                    copyFolder(pathFrom, pathTo);
                }

                catch (FileException ex)
                {
                    Logger.getLogger().error(ex.msg, ex);
                }
            }
        };

        thread.start();
    }

    /***************************************************************************
     * Params: strFilePath
     * Authors: Rocex Wang
     * Date: 2019-8-9 21:03:57
     ***************************************************************************/
    public static void deleteFile(string strFilePath)
    {
        if (isDir(strFilePath) || !exists(strFilePath))
        {
            return;
        }

        remove(strFilePath);
    }

    /***************************************************************************
     * 删除文件夹下所有的文件夹和文件
     * Params: path
     * Params: pathTo
     * Params: options
     * Authors: Rocex Wang
     * Date: 2020-4-28 21:36:51
     ***************************************************************************/
    public static void deleteFolder(string path)
    {
        if (isFile(path) || !exists(path))
        {
            return;
        }

        rmdirRecurse(path);
    }

    /***************************************************************************
     * 写文件
     * Params: strFilePath
     * Params: strContent
     * Authors: Rocex Wang
     * Date: 2020-4-26 21:24:35
     ***************************************************************************/
    public static void writeFile(string strFilePath, string strContent)
    {
        try
        {
            auto parentPath = dirName(strFilePath);

            if (!exists(parentPath))
            {
                mkdirRecurse(parentPath);
            }

            write(strFilePath, strContent);
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }
    }

    /***************************************************************************
     * 在新线程下写文件
     * Params: strFilePath
     * Params: strContent
     * Authors: Rocex Wang
     * Date: 2020-5-11 21:36:58
     ***************************************************************************/
    public static void writeFileThread(string strFilePath, string strContent)
    {
        Thread thread = new class Thread
        {
            override public void run()
            {
                writeFile(strFilePath, strContent);
            }
        };

        thread.start();
    }
}
