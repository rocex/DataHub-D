module org.rocex.ui.widgets.StatusBar;

import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.rocex.ui.widgets.CompositeControl;
import org.rocex.utils.ResHelper;
import org.rocex.utils.UIHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-7 22:02:30
 ***************************************************************************/
public class StatusBar : CompositeControl
{
    private Label labelHintMessage;

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-5-8 22:37:56
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, SWT.BORDER | iStyle);

        setLayout(UIHelper.getFillGridLayout(7, false));

        GridData gridDataStatusBar = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
        gridDataStatusBar.heightHint = UIHelper.iBarHeight;
        setLayoutData(gridDataStatusBar);

        labelHintMessage = new Label(this, SWT.NONE);
        GridData layoutData = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1);
        layoutData.horizontalIndent = 3;
        labelHintMessage.setLayoutData(layoutData);
        labelHintMessage.setText("");

        addSeparator();

        Label lblNewLabel2 = new Label(this, SWT.NONE);
        lblNewLabel2.setLayoutData(getGridData());
        lblNewLabel2.setText(" 行 0 列 0 ");

        addSeparator();

        Label lblNewLabel3 = new Label(this, SWT.NONE);
        lblNewLabel3.setLayoutData(getGridData());
        lblNewLabel3.setText(" 行 1 列 1 ");

        addSeparator();

        Label lblNewLabel4 = new Label(this, SWT.NONE);
        lblNewLabel4.setLayoutData(getGridData());
        lblNewLabel4.setText(" 行 2 列 2 ");
    }

    /***************************************************************************
     * @param statusBar
     * @author Rocex Wang
     * @since 2019-5-6 22:37:36
     ***************************************************************************/
    public void addSeparator()
    {
        UIHelper.createBarSeparator(this);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.CompositeControl#getControl()
     * @author Rocex Wang
     * @since 2019-5-28 22:00:17
     ****************************************************************************/
    override public Label getControl()
    {
        return labelHintMessage;
    }

    /***************************************************************************
     * @return GridData
     * @author Rocex Wang
     * @since 2019-5-23 22:43:16
     ***************************************************************************/
    private GridData getGridData()
    {
        GridData gridData = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
        gridData.horizontalIndent = 3;

        return gridData;
    }

    /***************************************************************************
     * @param strMessage
     * @author Rocex Wang
     * @since 2020-6-9 22:52:15
     ***************************************************************************/
    public void showErrorMessage(string strMessage)
    {
        if (strMessage !is null)
        {
            labelHintMessage.setForeground(ResHelper.getColor(SWT.COLOR_RED));

            labelHintMessage.setText(strMessage);
        }
    }

    /***************************************************************************
     * @param strMessage
     * @author Rocex Wang
     * @since 2019-5-23 22:35:10
     ***************************************************************************/
    public void showHintMessage(string strMessage)
    {
        if (strMessage !is null)
        {
            labelHintMessage.setForeground(ResHelper.getColor(SWT.COLOR_BLACK));

            labelHintMessage.setText(strMessage);
        }
    }
}
