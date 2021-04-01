module org.rocex.ui.widgets.CCombo;

import std.conv;

import java.lang.all;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.rocex.ui.form.FieldProp;
import org.rocex.ui.widgets.IWidget;
import org.rocex.utils.StringHelper;
import org.rocex.vo.Pair;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2020-6-19 22:49:00
 ***************************************************************************/
public class CCombo : Combo, IWidget
{
    private FieldProp fieldProp;

    private List listModel;

    private Object objValue;

    /***************************************************************************
     * @param parent
     * @param style
     * @author Rocex Wang
     * @since 2020-6-19 22:49:00
     ***************************************************************************/
    public this(Composite parent, int style)
    {
        super(parent, style);
    }

    /***************************************************************************
     * @param strText
     * @param objValue
     * @return Combo
     * @author Rocex Wang
     * @since 2020-6-19 22:53:53
     ***************************************************************************/
    public Combo addItem(String strText, Object objValue)
    {
        if (listModel is null)
        {
            listModel = new ArrayList();
        }

        listModel.add(new Pair!(string, Object)(strText, objValue));

        setModel(listModel);

        return this;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Combo#checkSubclass()
     * @author Rocex Wang
     * @since 2020-6-19 22:21:34
     ****************************************************************************/
    override protected void checkSubclass()
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * @author Rocex Wang
     * @since 2020-7-4 22:29:47
     ****************************************************************************/
    override public void dispose()
    {
        fieldProp = null;
        objValue = null;

        listModel.clear();
        listModel = null;

        super.dispose();
    }

    /***************************************************************************
     * @return the fieldProp
     * @author Rocex Wang
     * @since 2020-6-19 22:07:29
     ***************************************************************************/
    public FieldProp getProp()
    {
        return fieldProp;
    }

    /***************************************************************************
     * @return the value
     * @author Rocex Wang
     * @since 2020-6-19 22:50:34
     ***************************************************************************/
    override public Object getValue()
    {
        return listModel is null ? stringcast(getText()) : (cast(Pair!(string,
                Object)) listModel.get(getSelectionIndex())).getValue();
    }

    /***************************************************************************
     * @param listModel
     * @author Rocex Wang
     * @since 2020-6-19 22:55:17
     ***************************************************************************/
    public void setModel(List listModel)
    {
        this.listModel = listModel;

        if (listModel is null)
        {
            return;
        }

        List listItem = new ArrayList();
        foreach (key; listModel)
        {
            listItem.add((cast(Pair!(string, Object)) key).getKey());
        }

        setItems(listItem.toArray(new String[0]));

        setValue(objValue);
    }

    /***************************************************************************
     * @param fieldProp the fieldProp to set
     * @author Rocex Wang
     * @since 2020-6-19 22:07:29
     ***************************************************************************/
    public void setProp(FieldProp prop)
    {
        fieldProp = prop;
    }

    /***************************************************************************
     * @param objValue the value to set
     * @author Rocex Wang
     * @since 2020-6-19 22:50:34
     ***************************************************************************/
    override public void setValue(Object objValue)
    {
        this.objValue = objValue;

        if (listModel is null)
        {
            setText(StringHelper.defaultString(objValue));

            return;
        }

        for (int i = 0; i < listModel.size(); i++)
        {
            Pair!(string, Object) entry = cast(Pair!(string, Object)) listModel.get(i);

            if (StringHelper.equals(entry.getValue(), objValue))
            {
                select(i);

                break;
            }
        }
    }
}
