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

        multiLogger.logLevel(LogLevel.info);

        SysTime today = Clock.currTime();

        auto loggerFile = new FileLogger("./logs/access_" ~ (cast(Date) today)
                .toISOExtString() ~ ".log");

        import std.stdio : console = stdout;

        auto loggerConsole = new FileLogger(console);

        multiLogger.insertLogger("loggerFile", loggerFile);
        multiLogger.insertLogger("loggerConsole", loggerConsole);
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
        if (icmp("all", strEnableLogLevel) > -1)
        {
            Logger.getLogger().logLevel(LogLevel.all);
        }
        else if (icmp("trace", strEnableLogLevel) > -1)
        {
            Logger.getLogger().logLevel(LogLevel.trace);
        }
        else if (icmp("info", strEnableLogLevel) > -1)
        {
            Logger.getLogger().logLevel(LogLevel.info);
        }
        else if (icmp("warn", strEnableLogLevel) > -1)
        {
            Logger.getLogger().logLevel(LogLevel.warning);
        }
        else if (icmp("error", strEnableLogLevel) > -1)
        {
            Logger.getLogger().logLevel(LogLevel.error);
        }
        else if (icmp("critical", strEnableLogLevel) > -1)
        {
            Logger.getLogger().logLevel(LogLevel.critical);
        }
        else
        {
            Logger.getLogger().logLevel(LogLevel.fatal);
        }
    }
}
