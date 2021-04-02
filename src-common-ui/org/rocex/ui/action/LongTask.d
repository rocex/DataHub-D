module org.rocex.ui.action.LongTask;

import java.lang.all;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Cursor;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Widget;
import org.rocex.ui.app;
import org.rocex.ui.action.Action;
import org.rocex.ui.widgets.ProgressCircle;
import org.rocex.utils.Logger;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * 处理长任务抽象类，一个长任务的执行流程 beforeTask() => doTask() => afterTask() => finallyTask()<br>
 * @author Rocex Wang
 * @since 2020-6-11 22:50:25
 ***************************************************************************/
public abstract class LongTask : Thread, Runnable
{
    protected Action action;

    protected Event evt;

    private int iTaskWait = 300;

    protected ProgressCircle progress = null;

    private TaskState taskState;

    /** 任务状态：初始态=>校验通过态=>校验异常态=>运行中=>完成态 */
    public enum TaskState
    {
        check_exception,
        check_pass,
        finished,
        init,
        running
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-6-17 22:52:47
     ***************************************************************************/
    public this()
    {
        super();
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2020-6-13 22:11:30
     ***************************************************************************/
    public this(Action action, Event evt)
    {
        super();

        this.evt = evt;
        this.action = action;
    }

    /***************************************************************************
     * 可处理任何操作，和界面相关的、无关的都可以<br>
     * 主要是一些任务执行后向界面放数等操作，有异常直接抛出，系统会自动中断操作<br>
     * @throws Exception
     * @author Rocex Wang
     * @since 2020-6-13 22:12:19
     ***************************************************************************/
    protected void afterTask()
    {
    }

    /***************************************************************************
     * 可处理任何操作，和界面相关的、无关的都可以<br>
     * 主要是一些任务执行前的校验、从界面存取数操作，有异常直接抛出，系统会自动中断操作<br>
     * 子类继承的时候要在最后调用父类的beforeTask()，因为要调用getProgressWidget()，而ui操作要在子类的beforeTask()里实现<br>
     * @throws Exception
     * @author Rocex Wang
     * @since 2020-6-13 22:12:11
     ***************************************************************************/
    protected void beforeTask()
    {
        Widget progressWidget = getProgressWidget();

        if (progressWidget !is null && !progressWidget.isDisposed())
        {
            progress = new ProgressCircle(progressWidget).start();

            Cursor cursor = progressWidget.getDisplay().getSystemCursor(SWT.CURSOR_WAIT);

            showCursor(progressWidget, cursor);
        }
    }

    /***************************************************************************
     * 只处理长任务，任何和界面相关的都不能在这儿处理，执行完的结果放到线程成员变量里面待afterTask()使用<br>
     * @throws Exception
     * @author Rocex Wang
     * @since 2020-6-13 22:12:16
     ***************************************************************************/
    protected abstract void doTask();

    /***************************************************************************
     * 可处理任何操作，和界面相关的、无关的都可以<br>
     * 任务最后的收尾工作
     * @throws Exception
     * @author Rocex Wang
     * @since 2020-6-13 22:12:52
     ***************************************************************************/
    protected void finallyTask()
    {
        Widget progressWidget = getProgressWidget();

        if (progress !is null && progressWidget !is null && !progressWidget.isDisposed())
        {
            progress.stop();

            progress = null;

            showCursor(progressWidget, null);
        }
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2020-6-17 22:57:12
     ***************************************************************************/
    protected void fireEvent(Event evt)
    {
        action.fireEvent(evt);
    }

    /***************************************************************************
     * @return Application
     * @author Rocex Wang
     * @since 2020-6-17 22:20:26
     ***************************************************************************/
    protected Application getApplication()
    {
        return action.getApplication();
    }

    /***************************************************************************
     * @return Widget
     * @author Rocex Wang
     * @since 2020-6-17 22:10:14
     ***************************************************************************/
    protected abstract Widget getProgressWidget();

    /***************************************************************************
     * @return the taskState
     * @author Rocex Wang
     * @since 2020-6-16 22:04:30
     ***************************************************************************/
    public TaskState getTaskState()
    {
        return taskState;
    }

    /***************************************************************************
     * @param ex
     * @author Rocex Wang
     * @since 2020-6-13 22:12:49
     ***************************************************************************/
    protected void handleException(Exception ex)
    {
        action.handleException(ex);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see java.lang.Runnable#run()
     * @author Rocex Wang
     * @since 2020-6-13 22:10:47
     ****************************************************************************/
    override public void run()
    {
        Display display = Display.getDefault();

        setTaskState(TaskState.init);

        try
        {
            Runnable beforeTaskRunnable = new class Runnable
            {
                override public void run()
                {
                    try
                    {
                        Logger.getLogger().trace("beforeTask");

                        beforeTask();

                        setTaskState(TaskState.check_pass);
                    }
                    catch (Exception ex)
                    {
                        setTaskState(TaskState.check_exception);

                        handleException(ex);
                    }
                }
            };

            display.asyncExec(beforeTaskRunnable);

            while (getTaskState() == TaskState.init)
            {
                Logger.getLogger().trace("wait for beforeTask finish");

                ResHelper.sleep(iTaskWait);
            }

            if (getTaskState() != TaskState.check_pass)
            {
                return;
            }

            Logger.getLogger().trace("doTask");

            setTaskState(TaskState.running);

            doTask();

            if (display.isDisposed())
            {
                return;
            }

            Runnable afterTaskRunnable = new class Runnable
            {
                override public void run()
                {
                    Logger.getLogger().trace("afterTask");

                    try
                    {
                        afterTask();
                    }
                    catch (Exception ex)
                    {
                        handleException(ex);
                    }
                }
            };

            display.asyncExec(afterTaskRunnable);
        }
        catch (Exception ex)
        {
            if (display.isDisposed())
            {
                return;
            }

            auto handleExceptionRunnable = new class Runnable
            {
                public void run()
                {
                    handleException(ex);
                }
            };

            display.asyncExec(handleExceptionRunnable);
        }
        finally
        {
            if (!display.isDisposed())
            {
                Runnable finallyTaskRunnable = new class() Runnable
                {
                    override public void run()
                    {
                        Logger.getLogger().trace("finallyTask");

                        try
                        {
                            finallyTask();

                            setTaskState(TaskState.finished);
                        }
                        catch (Exception ex)
                        {
                            handleException(ex);
                        }
                    }
                };

                display.asyncExec(finallyTaskRunnable);
            }
        }
    }

    /***************************************************************************
     * @param action
     * @author Rocex Wang
     * @since 2020-6-17 22:56:40
     ***************************************************************************/
    public void setAction(Action action)
    {
        this.action = action;
    }

    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2020-6-17 22:58:11
     ***************************************************************************/
    public void setEvent(Event evt)
    {
        this.evt = evt;
    }

    /***************************************************************************
     * @param taskState the taskState to set
     * @author Rocex Wang
     * @since 2020-6-16 22:04:30
     ***************************************************************************/
    public void setTaskState(TaskState taskState)
    {
        this.taskState = taskState;
    }

    /***************************************************************************
     * 设置鼠标样式
     * @param progressWidget
     * @param cursor
     * @author Rocex Wang
     * @since 2020-7-9 22:12:38
     ***************************************************************************/
    protected void showCursor(Widget progressWidget, Cursor cursor)
    {
        Shell[] shells = progressWidget.getDisplay().getShells();

        if (shells is null || shells.length == 0)
        {
            return;
        }

        foreach (Shell shell; shells)
        {
            if (!shell.isDisposed())
            {
                shell.setCursor(cursor);
            }
        }
    }

    /***************************************************************************
     * @param strMsg
     * @author Rocex Wang
     * @since 2020-6-17 22:21:22
     ***************************************************************************/
    protected void showHintMessage(String strMsg)
    {
        action.showHintMessage(strMsg);
    }
}
