module org.rocex.ui.widgets.LeftControl;

import std.conv;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Tree;
import org.eclipse.swt.widgets.TreeItem;
import org.rocex.ui.widgets.CompositeControl;
import org.rocex.utils.UIHelper;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2019-5-21 22:01:16
 ***************************************************************************/
public class LeftControl : CompositeControl
{
    protected Tree tree;

    /***************************************************************************
     * Params: parent
     * Params: iStyle
     * Authors: Rocex Wang
     * Date: 2020-6-3 22:50:47
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, iStyle);

        setLayout(UIHelper.getFillGridLayout(1, true));

        createControl();
    }

    /***************************************************************************
     * Authors: Rocex Wang
     * Date: 2019-5-28 22:51:47
     ***************************************************************************/
    protected void createControl()
    {
        tree = new Tree(this, SWT.BORDER);
        tree.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

        for (int i = 0; i < 40; i++)
        {
            auto iItem = new TreeItem(tree, 0);
            iItem.setText("TreeItem (0) - " ~ to!(string)(i));
            for (int j = 0; j < 4; j++)
            {
                TreeItem jItem = new TreeItem(iItem, 0);
                jItem.setText("TreeItem (1) - " ~ to!(string)(j));
                for (int k = 0; k < 4; k++)
                {
                    TreeItem kItem = new TreeItem(jItem, 0);
                    kItem.setText("TreeItem (2) - " ~ to!(string)(k));
                    for (int l = 0; l < 4; l++)
                    {
                        TreeItem lItem = new TreeItem(kItem, 0);
                        lItem.setText("TreeItem (3) - " ~ to!(string)(l));
                    }
                }
            }
        }

        UIHelper.addMouseTrackListener(tree);
    }

    /***************************************************************************
     * Returns:
     * Authors: Rocex Wang
     * Date: 2019-5-28 22:52:46
     ***************************************************************************/
    override public Control getControl()
    {
        return tree;
    }
}
