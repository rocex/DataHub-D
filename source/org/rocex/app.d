import org.rocex.datahub.ui.DataHub;
import org.rocex.datahub.ui.DataHub2;
import org.rocex.datahub.ui.DataHub3;
import org.rocex.datahub.ui.BigDataTableTest;
import org.rocex.utils.ResHelper;
import org.rocex.utils.Logger;
import org.rocex.ui.action.ActionManager;
import org.rocex.datahub.action.AddDBAction;
import std.experimental.logger.filelogger;

import org.eclipse.swt.graphics.ImageData;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.MessageBox;

import java.io.ByteArrayInputStream;

void testDWT()
{
    Logger.getLogger().info("app start *******************************");

    Logger.getLogger().tracef("this is in main app");

    auto display = Display.getDefault();

    auto application = new DataHub();
    auto application2 = new DataHub2();
    auto application3 = new DataHub3();

    auto bigDataTableTest = new BigDataTableTest();

    application.setText("DataHub");
    application2.setText("DataHub2");
    application3.setText("DataHub3");

    try
    {
        auto image = ResHelper.getImage("DataHub.gif");

        application.setImage(ResHelper.getImage("DataHub.gif"));
        application2.setImage(image);
        application3.setImage(image);
        bigDataTableTest.setImage(ResHelper.getImage("DataHub.gif"));

        auto actionManager = new ActionManager();
        auto action = actionManager.getAction("org.rocex.datahub.action.AddDBAction.AddDBAction");
        Logger.getLogger().info(action.getText());

        auto action2 = actionManager.getAction("org.rocex.datahub.action.AddDBAction.AddDBAction");
        action2.setText("AddDBAction2");
        Logger.getLogger().info(action.getText());
        Logger.getLogger().info(action2.getText());

        action.run();

        application.open();
        // application2.open();
        // application3.open();
        bigDataTableTest.open();

        action2.run();

        while (!application.isDisposed())
        {
            if (!display.readAndDispatch())
            {
                display.sleep();
            }
        }

        ResHelper.disposeImage("eclipse.png");
        ResHelper.dispose();

        display.dispose();

        Logger.getLogger().info("app end *******************************");
    }
    catch (Exception ex)
    {
        Logger.getLogger().error("error:" ~ ex.toString());
        MessageBox.showError(ex.toString(), "Fatal Error");
    }
}
