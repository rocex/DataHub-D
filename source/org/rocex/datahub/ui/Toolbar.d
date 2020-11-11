module org.rocex.datahub.ui.Toolbar;

import org.eclipse.swt.all;
import std.conv;
import java.lang.String;

public class Toolbar : ToolBar
{
    this(Shell shell, int style)
    {
        super(shell, style);

        initUI();
    }

    protected void initUI()
    {
        for (int i = 0; i < 18; i++)
        {
            ToolItem item = i % 4 == 0 ? new ToolItem(this, SWT.SEPARATOR) : new ToolItem(this, SWT.PUSH);
            item.setText("Item " ~ to!(String)(i));
        }
    }
}
