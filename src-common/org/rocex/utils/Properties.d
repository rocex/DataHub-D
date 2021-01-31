module org.rocex.utils.Properties;

import org.rocex.utils.Logger;
import std.algorithm;
import std.file;
import std.path;
import std.stdio : writefln;
import std.string;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2020-08-11 21:20:41
 ***************************************************************************/
public class Properties
{
    ///
    struct Entity
    {
        ///
        string key;
        ///
        string value;
        ///
        string comment;

        /** */
        this(string strKey, string strValue, string strComment = null)
        {
            this.key = strKey;
            this.value = strValue;
            this.comment = strComment;
        }
    }

    private string strComment; //
    private Entity[string] mapValues; //

    version (Windows)
    {
        private auto lineSep = "\r\n";
    }
    else
    {
        private auto lineSep = "\n";
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public void clear()
    {
        mapValues.clear();
    }

    /***************************************************************************
     * @param strKey
     * @return string
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public string get(string strKey)
    {
        if (strKey in mapValues)
        {
            Entity entity = mapValues[strKey];

            return entity.value;
        }

        return null;
    }

    /***************************************************************************
     * @param strKey
     * @return string
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public string getComment(string strKey)
    {
        if (strKey in mapValues)
        {
            return mapValues[strKey].comment;
        }

        return null;
    }

    /***************************************************************************
     * @return bool
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public bool isEmpty()
    {
        return mapValues is null || mapValues.length == 0;
    }

    /***************************************************************************
     * @return Properties
     * @author Rocex Wang
     * @since 2020-08-12 21:11:01
     ***************************************************************************/
    public auto keys()
    {
        return mapValues.keys();
    }

    /***************************************************************************
     * @param strFilePath
     * @author Rocex Wang
     * @since 2020-8-11 21:52:02
     ***************************************************************************/
    public void load(string strFilePath)
    {
        if (!exists(strFilePath))
        {
            auto parentPath = dirName(strFilePath);

            if (!exists(parentPath))
            {
                mkdirRecurse(parentPath);
            }

            //todo 为了创建一个空白文件
            write(strFilePath, "");
        }

        auto fileText = readText(strFilePath);

        auto lines = splitLines(fileText).filter!q{!a.empty};

        bool blFileCommnet = true;

        Entity entity = Entity();

        foreach (line; lines)
        {
            line = strip(line);

            if (blFileCommnet && line.startsWith("##"))
            {
                putComment(line[2 .. $]);
            }
            else if (line.startsWith("#"))
            {
                blFileCommnet = false;
                entity.comment ~= line[1 .. $];
            }
            else if (line.indexOf("=") > 0)
            {
                blFileCommnet = false;

                auto index = line.indexOf("=");

                entity.key = strip(line[0 .. index]);
                entity.value = strip(line[index + 1 .. $]);

                mapValues[entity.key] = entity;

                Logger.getLogger.infof("[%s] = [%s] [%s]", entity.key, entity.value, entity.comment);

                entity = Entity();
            }
        }
    }

    /***************************************************************************
     * @param strKey
     * @param strValue
     * @param strComment
     * @return Properties
     * @author Rocex Wang
     * @since 2020-8-11 21:17:41
     ***************************************************************************/
    public Properties put(string strKey, string strValue, string strComment = null)
    {
        if (strKey in mapValues)
        {
            mapValues[strKey].value = strValue;

            putComment(strKey, strComment);

            return this;
        }

        const Entity entity = Entity(strKey, strValue, strComment);

        mapValues[strKey] = entity;

        return this;
    }

    /***************************************************************************
     * @param properties
     * @return Properties
     * @author Rocex Wang
     * @since 2020-08-12 21:19:59
     ***************************************************************************/
    public Properties putAll(Properties properties)
    {
        auto entities = properties.values();

        foreach (entity; entities)
        {
            put(entity.key, entity.value, entity.comment);
        }

        return this;
    }

    /***************************************************************************
     * @param strKey
     * @param strComment
     * @return Properties
     * @author Rocex Wang
     * @since 2020-8-11 21:17:41
     ***************************************************************************/
    public Properties putComment(string strComment)
    {
        if (strComment is null)
        {
            this.strComment = null;
        }

        this.strComment ~= strComment;

        return this;
    }

    /***************************************************************************
     * @param strKey
     * @param strComment
     * @return Properties
     * @author Rocex Wang
     * @since 2020-8-11 21:17:41
     ***************************************************************************/
    public Properties putComment(string strKey, string strComment)
    {
        if (strKey !in mapValues)
        {
            return this;
        }

        mapValues[strKey].comment = strComment;

        return this;
    }

    /***************************************************************************
     * @param strKeys
     * @return Properties
     * @author Rocex Wang
     * @since 2020-8-11 21:17:41
     ***************************************************************************/
    public Properties remove(string[] strKeys...)
    {
        foreach (strKey; strKeys)
        {
            mapValues.remove(strKey);
        }

        return this;
    }

    /***************************************************************************
     * @param strKeys
     * @return Properties
     * @author Rocex Wang
     * @since 2020-8-11 21:17:41
     ***************************************************************************/
    public Properties removeComment(string[] strKeys...)
    {
        foreach (strKey; strKeys)
        {
            if (strKey in mapValues)
            {
                mapValues[strKey].comment = null;
            }
        }

        return this;
    }

    /***************************************************************************
     * @param strFilePath
     * @param strComment
     * @author Rocex Wang
     * @since 2020-8-11 21:53:05
     ***************************************************************************/
    public void store(string strFilePath, string strComment = null)
    {
        try
        {
            auto parentPath = dirName(strFilePath);

            if (!exists(parentPath))
            {
                mkdirRecurse(parentPath);
            }

            auto strKeys = mapValues.keys();

            sort(strKeys);

            write(strFilePath, "## " ~ (strComment is null ? this.strComment : strComment) ~ lineSep ~ lineSep);

            foreach (strKey; strKeys)
            {
                Entity entity = mapValues[strKey];

                if (entity.comment !is null && entity.comment.length > 0)
                {
                    append(strFilePath, lineSep ~ "#" ~ (entity.comment.startsWith(" ") ? "" : " ") ~ entity.comment ~ lineSep);
                }

                append(strFilePath, entity.key ~ " = " ~ entity.value ~ lineSep);
            }
        }
        catch (FileException ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }
    }

    /***************************************************************************
     * @return Properties
     * @author Rocex Wang
     * @since 2020-08-12 21:12:02
     ***************************************************************************/
    public auto values()
    {
        return mapValues.values();
    }
}
