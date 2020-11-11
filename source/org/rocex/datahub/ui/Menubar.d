module org.rocex.datahub.ui.Menubar;

import std.stdio;
import org.eclipse.swt.all;

public class Menubar : Menu
{
	this(Shell shell,int style)
	{
		super(shell,style);

		initUI();		
	}

	protected void initUI()
	{
	    auto fileItem = new MenuItem (this, SWT.CASCADE);
	    fileItem.setText ("&File");
	    auto submenu = new Menu (getShell(), SWT.DROP_DOWN);
	    fileItem.setMenu (submenu);
	    auto item = new MenuItem (submenu, SWT.PUSH);
	    item.addListener (SWT.Selection, new class Listener {
	        public void handleEvent (Event e) {
	            writeln("Select All");
	        }
	    });
	    item.setText ("Select &All\tCtrl+A");
	    item.setAccelerator (SWT.CTRL + 'A');
	}
}
