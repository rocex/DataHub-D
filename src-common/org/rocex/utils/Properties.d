module org.rocex.utils.Properties;

import org.rocex.utils.Logger;
import std.algorithm;
import std.file;
import std.path;
import std.stdio : writefln;
import std.string;

/***************************************************************************
 * key有序，并且有注释的Properties<br>
 * @author Rocex Wang
 * @since 2020-08-11 21:20:41
 ***************************************************************************/
public class Properties
{
    version (Windows)
    {
        private auto lineSep = "\r\n";
    }
    else
    {
        private auto lineSep = "\n";
    }

    /** */
    struct Entity
    {
        ///
        string strKey;
        ///
        string strValue;
        ///
        string strComment;

        /** */
        this(string strKey, string strValue, string strComment = null)
        {
            this.strKey = strKey;
            this.strValue = strValue;
            this.strComment = strComment;
        }

        /** */
        public bool equals(Entity entity)
        {
            if (is(typeof(entity) == typeof(null)))
            {
                return false;
            }

            return equal(strKey, entity.strKey) && equal(strValue,
                    entity.strValue) && equal(strComment, entity.strComment);
        }
    }

    private string strFileComment; //整个Properties文件的注释
    private Entity[string] mapKeyValues; //

    public ~this()
    {
        dispose();
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public void clear()
    {
        if (mapKeyValues !is null)
        {
            mapKeyValues.clear();
        }
    }
    /***************************************************************************
     * @author Rocex Wang
     * @since 2021-3-22 22:25:41
     ***************************************************************************/
    public Properties clone()
    {
        Properties prop = new Properties();

        prop.setFileComment(getFileComment());

        prop.putAll(this);

        return prop;
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2021-3-22 22:20:49
     ***************************************************************************/
    public void dispose()
    {
        if (mapKeyValues !is null)
        {
            mapKeyValues.clear();
            mapKeyValues = null;
        }
    }

    /****************************************************************************
     * @author Rocex Wang
     * @since 2021-3-22 21:36:13
     ****************************************************************************/
    public bool equals(Properties prop)
    {
        if (prop == this)
        {
            return true;
        }

        // 如果key都不相等，则这两个properties也不相等
        if (keys() != prop.keys())
        {
            return false;
        }

        foreach (Properties.Entity entity; prop.values())
        {
            if (entity.strValue != get(entity.strKey))
            {
                return false;
            }
        }

        return true;
    }

    /***************************************************************************
     * @param strKey
     * @return string
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public string get(string strKey)
    {
        return (strKey in mapKeyValues) ? mapKeyValues[strKey].strValue : null;
    }

    /***************************************************************************
     * @param strKey
     * @return string
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public string getComment(string strKey)
    {
        return (strKey in mapKeyValues) ? mapKeyValues[strKey].strComment : null;
    }

    /***************************************************************************
     * @return the fileComment
     * @author Rocex Wang
     * @since 2021-3-22 22:42:08
     ***************************************************************************/
    public string getFileComment()
    {
        return strFileComment;
    }

    /***************************************************************************
     * @return bool
     * @author Rocex Wang
     * @since 2020-8-11 21:20:49
     ***************************************************************************/
    public bool isEmpty()
    {
        return mapKeyValues is null || mapKeyValues.length == 0;
    }

    /***************************************************************************
     * @return Properties
     * @author Rocex Wang
     * @since 2020-08-12 21:11:01
     ***************************************************************************/
    public auto keys()
    {
        return mapKeyValues.keys();
    }

    /***************************************************************************
     * @param strFilePath
     * @author Rocex Wang
     * @since 2020-8-11 21:52:02
     ***************************************************************************/
    public void load(string strFilePath)
    {
        Logger.getLogger().infof("load properties from [%s]", strFilePath);

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

        bool blFileComment = true;
        auto strFileComment = "";

        Entity entity = Entity();

        foreach (line; lines)
        {
            line = strip(line);

            if (blFileComment && line.startsWith("##"))
            {
                strFileComment ~= line[2 .. $] ~ lineSep;
            }
            else if (line.startsWith("#"))
            {
                blFileComment = false;
                entity.strComment ~= line[1 .. $];
            }
            else if (line.indexOf("=") > 0)
            {
                blFileComment = false;

                auto index = line.indexOf("=");

                entity.strKey = strip(line[0 .. index]);
                entity.strValue = strip(line[index + 1 .. $]);

                mapKeyValues[entity.strKey] = entity;

                Logger.getLogger().tracef("[%s] = [%s] [%s]", entity.strKey,
                        entity.strValue, entity.strComment);

                entity = Entity();
            }
        }

        setFileComment(strFileComment);
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
        if (strKey in mapKeyValues)
        {
            mapKeyValues[strKey].strValue = strValue;

            if (strComment !is null)
            {
                mapKeyValues[strKey].strComment = strComment;
            }
        }
        else
        {
            const Entity entity = Entity(strKey, strValue, strComment);

            mapKeyValues[strKey] = entity;
        }

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
            put(entity.strKey, entity.strValue, entity.strComment);
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
    public Properties putComment(string strKey, string strComment)
    {
        if (strKey !in mapKeyValues)
        {
            return this;
        }

        mapKeyValues[strKey].strComment = strComment;

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
            mapKeyValues.remove(strKey);
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
            if (strKey in mapKeyValues)
            {
                mapKeyValues[strKey].strComment = null;
            }
        }

        return this;
    }

    /***************************************************************************
     * 整个 Properties 文件的注释
     * @param strKey
     * @param strFileComment
     * @return Properties
     * @author Rocex Wang
     * @since 2020-8-11 21:17:41
     ***************************************************************************/
    public Properties setFileComment(string strFileComment)
    {
        this.strFileComment = strFileComment;

        return this;
    }

    /***************************************************************************
     * @param strFilePath
     * @param strFileComment
     * @author Rocex Wang
     * @since 2020-8-11 21:53:05
     ***************************************************************************/
    public void store(string strFilePath, string strFileComment = null)
    {
        Logger.getLogger().warningf("save properties to [%s]", strFilePath);

        try
        {
            auto parentPath = dirName(strFilePath);

            if (!exists(parentPath))
            {
                mkdirRecurse(parentPath);
            }

            auto strKeys = mapKeyValues.keys();

            sort(strKeys);

            write(strFilePath, "## " ~ (strFileComment is null
                    ? this.strFileComment : strFileComment) ~ lineSep ~ lineSep);

            foreach (strKey; strKeys)
            {
                Entity entity = mapKeyValues[strKey];

                if (entity.strComment !is null && entity.strComment.length > 0)
                {
                    append(strFilePath, lineSep ~ "#" ~ (entity.strComment.startsWith(" ")
                            ? "" : " ") ~ entity.strComment ~ lineSep);
                }

                append(strFilePath, entity.strKey ~ " = " ~ entity.strValue ~ lineSep);
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
        return mapKeyValues.values();
    }
}
