module org.rocex.ui.widgets.LeftControl;

import java.lang.all;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Tree;
import org.eclipse.swt.widgets.TreeItem;
import org.rocex.ui.widgets.CompositeControl;
import org.rocex.utils.UIHelper;
import std.conv;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-5-21 22:01:16
 ***************************************************************************/
public class LeftControl : CompositeControl
{
    protected Tree tree;

    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2020-6-3 22:50:47
     ***************************************************************************/
    public this(Composite parent, int iStyle)
    {
        super(parent, iStyle);

        setLayout(UIHelper.getFillGridLayout(1, true));

        createControl();
    }

    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-5-28 22:51:47
     ***************************************************************************/
    protected void createControl()
    {
        tree = new Tree(this, SWT.BORDER);
        tree.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

        for (int i = 0; i < 40; i++)
        {
            auto iItem = new TreeItem(tree, 0);
            iItem.setText("TreeItem (0) - " ~ to!(String)(i));
            for (int j = 0; j < 4; j++)
            {
                TreeItem jItem = new TreeItem(iItem, 0);
                jItem.setText("TreeItem (1) - " ~ to!(String)(j));
                for (int k = 0; k < 4; k++)
                {
                    TreeItem kItem = new TreeItem(jItem, 0);
                    kItem.setText("TreeItem (2) - " ~ to!(String)(k));
                    for (int l = 0; l < 4; l++)
                    {
                        TreeItem lItem = new TreeItem(kItem, 0);
                        lItem.setText("TreeItem (3) - " ~ to!(String)(l));
                    }
                }
            }
        }

        UIHelper.addMouseTrackListener(tree);
    }

    /***************************************************************************
     * @return
     * @author Rocex Wang
     * @since 2019-5-28 22:52:46
     ***************************************************************************/
    override public Control getControl()
    {
        return tree;
    }
}
