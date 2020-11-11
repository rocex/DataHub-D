module org.rocex.datahub.ui.DataHub;

import org.rocex.datahub.ui.Menubar;
import org.rocex.datahub.ui.Toolbar;
import org.rocex.datahub.ui.LeftWidget;
import org.rocex.datahub.ui.MainWidget;
import org.rocex.datahub.ui.Statusbar;

import org.eclipse.swt.all;

import org.rocex.utils.Logger;

public class DataHub : Shell
{
    private
    {
        Menubar menubar;
        Toolbar toolbar;
        Statusbar statusbar;
    }

    this()
    {
        super(Display.getDefault());

        Logger.getLogger().info("this is in data hub");

        initUI();
    }

    protected void initUI()
    {
        setLayout(new GridLayout(1, false));
        setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));

        menubar = createMenubar();
        setMenuBar(menubar);

        toolbar = createToolbar();

        SashForm form = new SashForm(this, SWT.HORIZONTAL);

        form.setBackground(Display.getDefault().getSystemColor(SWT.COLOR_CYAN));

        Composite child1 = new LeftWidget(form, SWT.NONE);
        child1.setBackground(Display.getDefault().getSystemColor(SWT.COLOR_DARK_CYAN));

        Composite child2 = new MainWidget(this, SWT.NONE);

        //	    form.setWeights([30,70]);

        statusbar = createStatusbar();

        setMaximized(true);
    }

    protected Menubar createMenubar()
    {
        return new Menubar(this, SWT.BAR);
    }

    protected Toolbar createToolbar()
    {
        Toolbar toolbar = new Toolbar(this, SWT.FLAT);
        // toolbar.setBackground(Display.getDefault().getSystemColor(SWT.COLOR_BLUE));

        // Rectangle clientArea = getClientArea();
        // toolbar.setLocation(clientArea.x, clientArea.y);
        // toolbar.pack();

        return toolbar;
    }

    protected Statusbar createStatusbar()
    {
        Statusbar statusbar = new Statusbar(this, SWT.NONE);

        return statusbar;
    }
}
