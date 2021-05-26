package org.rocex.ui.widgets;

import java.util.Random;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.Bullet;
import org.eclipse.swt.custom.LineStyleEvent;
import org.eclipse.swt.custom.ST;
import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.graphics.GlyphMetrics;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.rocex.ui.Context;
import org.rocex.ui.action.ActionConst;
import org.rocex.ui.action.Separator;
import org.rocex.ui.utils.UIHelper;
import org.rocex.ui.widgets.action.CopyAction;
import org.rocex.ui.widgets.action.CutAction;
import org.rocex.ui.widgets.action.PasteAction;
import org.rocex.ui.widgets.action.RedoAction;
import org.rocex.ui.widgets.action.SelectAllAction;
import org.rocex.ui.widgets.action.UndoAction;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * 带行号的StyledText控件<br>
 * @author Rocex Wang
 * @since 2019-5-20 22:02:49
 ***************************************************************************/
public class TextEditor extends StyledText
{
    private Context context;
    
    /***************************************************************************
     * @param parent
     * @param iStyle
     * @author Rocex Wang
     * @since 2019-7-23 22:38:18
     ***************************************************************************/
    public TextEditor(Composite parent, int iStyle)
    {
        super(parent, iStyle);
        
        context = UIHelper.getContext(parent);
        
        addContextMenu();
        
        getContext().getActionManager().refreshActionState();
        
        addLineStyleListener(this::syncRowNO);
        
        addListener(SWT.Modify, evt -> getContext().fireEvent(evt));
        addListener(SWT.Selection, evt -> getContext().fireEvent(evt));
        addListener(SWT.Modify, evt -> getDisplay().asyncExec(this::redraw));
    }
    
    /***************************************************************************
     * @author Rocex Wang
     * @since 2019-7-23 22:44:19
     ***************************************************************************/
    protected void addContextMenu()
    {
        MenuBar menu = new MenuBar(this);
        
        menu.setContext(getContext());
        
        setMenu(menu);
        
        int iRandom = Math.abs(new Random().nextInt());
        
        menu.addAction(menu, new UndoAction(ActionConst.id_edit_undo + "_" + iRandom).setEditor(this),
                new RedoAction(ActionConst.id_edit_redo + "_" + iRandom).setEditor(this), new Separator(),
                new CutAction(ActionConst.id_edit_cut + "_" + iRandom).setEditor(this),
                new CopyAction(ActionConst.id_edit_copy + "_" + iRandom).setEditor(this),
                new PasteAction(ActionConst.id_edit_paste + "_" + iRandom).setEditor(this), new Separator(),
                new SelectAllAction(ActionConst.id_edit_select_all + "_" + iRandom).setEditor(this));
    }
    
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.custom.StyledText#dispose()
     * @author Rocex Wang
     * @since 2020-7-7 22:51:30
     ****************************************************************************/
    @Override
    public void dispose()
    {
        ResHelper.dispose(getMenu());
        
        super.dispose();
    }
    
    /***************************************************************************
     * @return the context
     * @author Rocex Wang
     * @since 2020-6-1 22:58:31
     ***************************************************************************/
    public Context getContext()
    {
        return context;
    }
    
    /***************************************************************************
     * @param context the context to set
     * @author Rocex Wang
     * @since 2020-6-1 22:58:31
     ***************************************************************************/
    public void setContext(Context context)
    {
        this.context = context;
    }
    
    /***************************************************************************
     * @param evt
     * @author Rocex Wang
     * @since 2019-5-27 22:17:13
     ***************************************************************************/
    protected void syncRowNO(LineStyleEvent evt)
    {
        StyleRange styleRange = new StyleRange();
        styleRange.foreground = Display.getCurrent().getSystemColor(SWT.COLOR_DARK_GRAY);
        
        int iMaxLine = getLineCount();
        if (iMaxLine < 100)
        {
            iMaxLine = 100;
        }
        
        int iBulletLength = Integer.toString(iMaxLine).length();
        
        // Width of number character is half the height in monospaced font, add 1 character width for right padding.
        int bulletWidth = (iBulletLength + 1) * getLineHeight() / 2;
        
        styleRange.metrics = new GlyphMetrics(0, 0, bulletWidth);
        
        // Using ST.BULLET_NUMBER sometimes results in weird alignment.
        evt.bullet = new Bullet(ST.BULLET_NUMBER, styleRange);
        evt.bulletIndex = getLineAtOffset(evt.lineOffset);
        
        // getLineAtOffset() returns a zero-based line index.
        // evt.bullet = new Bullet(ST.BULLET_TEXT, styleRange);
        // int iBulletLine = getLineAtOffset(evt.lineOffset) + 1;
        // evt.bullet.text = String.valueOf(iBulletLine);// String.format("%" + iBulletLength + "s", iBulletLine);
    }
}
