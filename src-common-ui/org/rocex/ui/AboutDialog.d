module org.rocex.ui.AboutDialog;

import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.rocex.ui.widgets.Dialog;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2019-5-23 22:21:09
 ***************************************************************************/
public class AboutDialog : Dialog
{
    /****************************************************************************
     * @author Rocex Wang
     * @version 2020-6-1 22:02:07
     ****************************************************************************/
    public this(Shell parent, int iStyle)
    {
        super(parent, SWT.NONE | iStyle);

        setTitle("关于...");

        setSize(700, 400);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.Dialog#createButtonArea(org.eclipse.swt.widgets.Composite)
     * @author Rocex Wang
     * @version 2020-6-1 22:02:07
     ****************************************************************************/
    override protected void createButtonArea(Composite parent)
    {
        Button btnClose = new Button(parent, SWT.NONE);
        btnClose.setText("&Close");

        Listener listener = new class Listener
        {
            void handleEvent(Event evt)
            {
                closeCancel(evt);
            }
        };

        btnClose.addListener(SWT.Selection, listener);

        shell.setDefaultButton(btnClose);
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.rocex.ui.widgets.Dialog#createDialogArea(org.eclipse.swt.widgets.Composite)
     * @author Rocex Wang
     * @version 2019-5-24 22:34:22
     ****************************************************************************/
    override protected void createDialogArea(Composite parent)
    {
        parent.setLayout(new GridLayout(2, false));

        Label lblAboutImage = new Label(parent, SWT.NONE);
        lblAboutImage.setImage(ResHelper.getImage(ResHelper.res_root_path ~ "About.jpg"));

        StyledText styledText = new StyledText(parent, SWT.BORDER | SWT.READ_ONLY | SWT.WRAP);
        styledText.setBackground(ResHelper.getColor(245, 245, 245));
        styledText.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
        styledText.setText("* [DLang](https://dlang.org)\n\n* [SWT](http://www.eclipse.org/swt)\n\n* [DWT](https://code.dlang.org/packages/dwt) \n\n* [DWT Forum](https://forum.dlang.org/group/dwt))\n\n");
    }
}
