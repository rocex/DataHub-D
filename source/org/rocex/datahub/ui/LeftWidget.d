module org.rocex.datahub.ui.LeftWidget;

import std.conv;

import java.lang.String;
import org.eclipse.swt.all;

public class LeftWidget : Composite
{
    this(Composite parent, int style)
    {
        super(parent, style);

        initUI();
    }

    public void initUI()
    {
        setLayout(new FillLayout());

        (new Label(this, SWT.NONE)).setText("left composite");

        Tree tree = new Tree(this, SWT.BORDER);
        for (int i = 0; i < 4; i++)
        {
            auto iItem = new TreeItem(tree, 0);
            iItem.setText("TreeItem (0) -" ~ to!(String)(i));
            for (int j = 0; j < 4; j++)
            {
                TreeItem jItem = new TreeItem(iItem, 0);
                jItem.setText("TreeItem (1) -" ~ to!(String)(j));
                for (int k = 0; k < 4; k++)
                {
                    TreeItem kItem = new TreeItem(jItem, 0);
                    kItem.setText("TreeItem (2) -" ~ to!(String)(k));
                    for (int l = 0; l < 4; l++)
                    {
                        TreeItem lItem = new TreeItem(kItem, 0);
                        lItem.setText("TreeItem (3) -" ~ to!(String)(l));
                    }
                }
            }
        }
    }
}
