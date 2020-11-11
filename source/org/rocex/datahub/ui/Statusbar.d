module org.rocex.datahub.ui.Statusbar;

import org.eclipse.swt.all;

public class Statusbar : Composite
{
	this(Shell shell, int style)
	{
		super(shell, style);

		initUI();		
	}

	protected void initUI()
	{
        Button btn = new Button(this,SWT.NONE);
        btn.setText("status");
	}
}