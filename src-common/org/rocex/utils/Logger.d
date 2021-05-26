module org.rocex.utils.Logger;

import std.datetime;
import std.experimental.logger;
import std.string;

/***************************************************************************
 * all < trace < info < warn < error < critical < fatal <br>
 * Authors: Rocex Wang
 * Date: 2019-5-21 21:13:04
 ***************************************************************************/
public class Logger
{
    private static MonoTime[string] mapTimer;

    private static std.experimental.logger.Logger logger;

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2020-08-15 21:32:21
     ***************************************************************************/
    private static this()
    {
        auto multiLogger = new MultiLogger();

        multiLogger.logLevel(LogLevel.error);

        SysTime today = Clock.currTime();

        auto loggerFile = new RollingFileLogger("./logs/access_" ~ (cast(Date) today)
                .toISOExtString() ~ ".log");

        multiLogger.insertLogger("loggerFile", loggerFile);

        debug
        {
            import std.stdio : console = stdout;

            auto loggerConsole = new FileLogger(console);

            multiLogger.insertLogger("loggerConsole", loggerConsole);
        }

        logger = multiLogger;
    }

    /***************************************************************************
     * Params: strMessage 必须和 end(string) 的参数值相同
     * Authors: Rocex Wang
     * Date: 2020-5-8 21:54:39
     ***************************************************************************/
    public static void begin(string strMessage)
    {
        mapTimer[strMessage] = MonoTime.currTime;

        Logger.getLogger.warning(strMessage);
    }

    /***************************************************************************
     * Params: strMessage 必须和 start(string) 的参数值相同
     * Authors: Rocex Wang
     * Date: 2020-5-8 21:54:37
     ***************************************************************************/
    public static void end(string strMessage)
    {
        if (strMessage !in mapTimer)
        {
            return;
        }

        auto lTime = MonoTime.currTime - mapTimer[strMessage];

        string strMsg = "%s, cost: %s";

        Logger.getLogger.warningf(strMsg, strMessage, lTime);

        mapTimer.remove(strMessage);
    }

    /***************************************************************************
     * Returns: std.experimental.logger.Logger
     * Authors: Rocex Wang
     * Date: 2020-08-15 21:31:53
     ***************************************************************************/
    public static std.experimental.logger.Logger getLogger()
    {
        return logger;
    }
    /***************************************************************************
     * Params: strLogLevel
     * Authors: Rocex Wang
     * Date: 2020-08-15 21:31:53
     ***************************************************************************/
    public static void setEnableLevel(string strEnableLogLevel)
    {
        strEnableLogLevel = toLower(strip(strEnableLogLevel));

        if ("all" == strEnableLogLevel)
        {
            Logger.getLogger().logLevel = LogLevel.all;
        }
        else if ("trace" == strEnableLogLevel)
        {
            Logger.getLogger().logLevel = LogLevel.trace;
        }
        else if ("info" == strEnableLogLevel)
        {
            Logger.getLogger().logLevel = LogLevel.info;
        }
        else if ("warn" == strEnableLogLevel || "warning" == strEnableLogLevel)
        {
            Logger.getLogger().logLevel = LogLevel.warning;
        }
        else if ("error" == strEnableLogLevel)
        {
            Logger.getLogger().logLevel = LogLevel.error;
        }
        else if ("critical" == strEnableLogLevel)
        {
            Logger.getLogger().logLevel = LogLevel.critical;
        }
        else
        {
            Logger.getLogger().logLevel = LogLevel.fatal;
        }
    }
}

import std.stdio;
import std.concurrency : Tid;
import std.experimental.logger;
import std.path;
import std.conv;

/****************************************************************************** 
 * 
 * Authors: Rocex Wang 
 * Date: 2021-05-08 10:20:29
 ******************************************************************************/
class RollingFileLogger : FileLogger
{
    private int index = 0;
    private ulong maxSize = 5 * 1024 * 1024;
    private string baseFileName;

    this(in string fn, const LogLevel lv = LogLevel.all) @safe
    {
        super(fn, lv);

        baseFileName = filename;
    }

    ///
    this(in string fn, const LogLevel lv, CreateFolder createFileNameFolder) @safe
    {
        super(fn, lv, createFileNameFolder);

        baseFileName = filename;
    }

    ///
    this(File file, const LogLevel lv = LogLevel.all) @safe
    {
        super(file, lv);

        baseFileName = filename;
    }

    ///
    override protected void beginLogMsg(string file2, int line, string funcName, string prettyFuncName, string moduleName,
            LogLevel logLevel, Tid threadId, SysTime timestamp,
            std.experimental.logger.Logger logger) @safe
    {
        rollover();

        super.beginLogMsg(file2, line, funcName, prettyFuncName, moduleName,
                logLevel, threadId, timestamp, logger);
    }

    ///
    void rollover() @safe
    {
        while (this.file_.size() > maxSize)
        {
            const auto newFileName = buildPath(dirName(baseFileName), baseName(baseFileName,
                    extension(baseFileName)) ~ "-" ~ to!string(index++) ~ extension(baseFileName));

            this.filename = newFileName;

            this.file_ = File(this.filename, "a");

            writefln("filename is %s", filename);
        }

        this.file_.open(this.filename, "a");
    }
}
