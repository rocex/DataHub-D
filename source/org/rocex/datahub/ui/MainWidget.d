module org.rocex.datahub.ui.MainWidget;

import std.conv;

import java.lang.String;
import org.eclipse.swt.all;

public class MainWidget: Composite
{
	this(Composite parent, int style)
	{
		super(parent, style);
		
		initUI();
	}
	
	public void initUI()
	{
		setLayout(new FillLayout());
		
		auto table = new Table (this, SWT.MULTI | SWT.BORDER | SWT.FULL_SELECTION | SWT.H_SCROLL | SWT.V_SCROLL);
	    table.setLinesVisible (true);
	    table.setHeaderVisible (true);
	    String[] titles = [" ", "C", "!", "Description", "Resource", "In Folder", "Location"];
	    int[]    styles = [SWT.NONE, SWT.LEFT, SWT.RIGHT, SWT.CENTER, SWT.NONE, SWT.NONE, SWT.NONE];
	    foreach (i,title; titles) {
	        auto column = new TableColumn (table, styles[i]);
	        column.setText (title);
	    }
	    int count = 128;
	    for (int i=0; i<count; i++) {
	        auto item = new TableItem (table, SWT.NONE);
	        item.setText (0, "x");
	        item.setText (1, "y");
	        item.setText (2, "!");
	        item.setText (3, "this stuff behaves the way I expect");
	        item.setText (4, "almost everywhere");
	        item.setText (5, "some.folder");
	        item.setText (6, "line " ~ to!(String)(i) ~ " in nowhere");
	    }
	    for (int i=0; i<titles.length; i++) {
	        table.getColumn (i).pack ();
	    }
//	    table.setSize (table.computeSize (SWT.DEFAULT, 200));
	}
}