module org.rocex.utils.TimerLogger;

import core.time;
import java.lang.String;
import org.rocex.utils.Logger;

/***************************************************************************
 * 计算耗时<br>
 * @author Rocex Wang
 * @since 2020-5-8 21:43:26
 ***************************************************************************/
public class TimerLogger
{
    private static TimerLogger timerLogger;

    private MonoTime[String] mapTimer;

    /***************************************************************************
     * @return TimerLogger
     * @author Rocex Wang
     * @since 2020-5-8 21:54:34
     ***************************************************************************/
    public static TimerLogger getLogger()
    {
        if (timerLogger is null)
        {
            timerLogger = new TimerLogger();
        }

        return timerLogger;
    }

    /***************************************************************************
     * @param strMessage 必须和 end(String) 的参数值相同
     * @author Rocex Wang
     * @since 2020-5-8 21:54:39
     ***************************************************************************/
    public void begin(String strMessage)
    {
        mapTimer[strMessage] = MonoTime.currTime;

        Logger.getLogger().trace("begin " ~ strMessage);
    }

    /***************************************************************************
     * @param strMessage 必须和 start(String) 的参数值相同
     * @author Rocex Wang
     * @since 2020-5-8 21:54:37
     ***************************************************************************/
    public void end(String strMessage)
    {
        if (strMessage !in mapTimer)
        {
            return;
        }

        auto lTime = MonoTime.currTime - mapTimer[strMessage];

        String strMsg = "end   %-50s 耗时: %10.0fms, %10.3fs, %10.3fm";

        Logger.getLogger().tracef(strMsg, strMessage, lTime, lTime / 1000, lTime / 60000);

        mapTimer.remove(strMessage);
    }
}
