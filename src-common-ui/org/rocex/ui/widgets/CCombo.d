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
 * Authors: Rocex Wang
 * Date: 2020-6-19 22:49:00
 ***************************************************************************/
public class CCombo(T) : Combo, IWidget!(T)
{
    private FieldProp fieldProp;

    private List listModel;

    private T objValue;

    /***************************************************************************
     * Params: parent
     * Params: style
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:49:00
     ***************************************************************************/
    public this(Composite parent, int style)
    {
        super(parent, style);
    }

    /***************************************************************************
     * Params: strText
     * Params: objValue
     * Returns: Combo
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:53:53
     ***************************************************************************/
    public Combo addItem(String strText, T objValue)
    {
        if (listModel is null)
        {
            listModel = new ArrayList();
        }

        listModel.add(new Pair!(string, T)(strText, objValue));

        setModel(listModel);

        return this;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Combo#checkSubclass()
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:21:34
     ****************************************************************************/
    override protected void checkSubclass()
    {
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.widgets.Widget#dispose()
     * Authors: Rocex Wang
     * Date: 2020-7-4 22:29:47
     ****************************************************************************/
    override public void dispose()
    {
        fieldProp = null;
        // objValue = null;

        listModel.clear();
        listModel = null;

        super.dispose();
    }

    /***************************************************************************
     * Returns: the fieldProp
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:07:29
     ***************************************************************************/
    public FieldProp getProp()
    {
        return fieldProp;
    }

    /***************************************************************************
     * Returns: the value
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:50:34
     ***************************************************************************/
    override public T getValue()
    {
        assert(listModel is null, "listModel is null");
        // if (listModel is null)
        // {
        //     string strValue = getText();
        //     return cast(T) strValue;
        // }

        return (cast(Pair!(string, T)) listModel.get(getSelectionIndex())).getValue();
    }

    /***************************************************************************
     * Params: listModel
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:55:17
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
            listItem.add((cast(Pair!(string, T)) key).getKey());
        }

        setItems(listItem.toArray(new String[0]));

        setValue(objValue);
    }

    /***************************************************************************
     * Params: fieldProp the fieldProp to set
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:07:29
     ***************************************************************************/
    public void setProp(FieldProp prop)
    {
        fieldProp = prop;
    }

    /***************************************************************************
     * Params: objValue the value to set
     * Authors: Rocex Wang
     * Date: 2020-6-19 22:50:34
     ***************************************************************************/
    override public void setValue(T objValue)
    {
        assert(listModel is null, "listModel is null");

        this.objValue = objValue;

        // if (listModel is null)
        // {
        //     setText(StringHelper.defaultString(objValue));

        //     return;
        // }

        for (int i = 0; i < listModel.size(); i++)
        {
            Pair!(string, T) entry = cast(Pair!(string, T)) listModel.get(i);

            if (entry.getValue() == objValue)
            {
                select(i);

                break;
            }
        }
    }
}
