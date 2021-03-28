module org.rocex.datahub.ui.app;

import org.eclipse.swt.custom.CTabFolder;
import org.eclipse.swt.custom.CTabItem;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;

import org.rocex.ui.app;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * DataHub应用启动入口类<br>
 * @author Rocex Wang
 * @since 2019-8-26 22:56:11
 ***************************************************************************/
public class DataHubApp : Application
{
    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-24 22:43:17
     ***************************************************************************/
    public this()
    {
        super();

        setText("DataHub");
    }

    protected override Composite createMainControl(Composite parent)
    {
        CTabFolder tabFolder = new CTabFolder(parent, SWT.BORDER | SWT.FLAT);
        tabFolder.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

        Composite queryAnalyzer = new Composite(tabFolder, SWT.NONE);

        CTabItem tabItem = new CTabItem(tabFolder, SWT.NONE);
        tabItem.setImage(ResHelper.getImage(ResHelper.res_icon_path ~ "script.png"));
        tabItem.setText(" [无标题1] * ");
        tabItem.setControl(queryAnalyzer);

        tabItem = new CTabItem(tabFolder, SWT.NONE);
        tabItem.setImage(ResHelper.getImage(ResHelper.res_icon_path ~ "script.png"));
        tabItem.setText(" [无标题2] * ");
        tabItem.setControl(queryAnalyzer);

        tabFolder.setSelection(0);

        return tabFolder;
    }
}
