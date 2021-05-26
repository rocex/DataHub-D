package org.rocex.ui.widgets;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.LineStyleEvent;
import org.eclipse.swt.custom.LineStyleListener;
import org.eclipse.swt.custom.StyleRange;
import org.rocex.utils.ResHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2019-7-23 22:57:27
 ***************************************************************************/
public abstract class TextSyntaxListener implements LineStyleListener
{
    /***************************************************************************
     * @param keyword
     * @author Rocex Wang
     * @since 2019-7-23 22:01:44
     ***************************************************************************/
    protected TextSyntaxListener()
    {
        super();
    }
    
    /***************************************************************************
     * @return List<String>
     * @author Rocex Wang
     * @since 2019-7-23 22:12:12
     ***************************************************************************/
    public abstract String[] getKeyword();
    
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see org.eclipse.swt.custom.LineStyleListener#lineGetStyle(org.eclipse.swt.custom.LineStyleEvent)
     * @author Rocex Wang
     * @since 2019-7-23 22:00:37
     ****************************************************************************/
    @Override
    public void lineGetStyle(LineStyleEvent evt)
    {
        List<StyleRange> styles = new ArrayList<>();
        
        String[] strKeywords = getKeyword();
        
        for (String strKeyword : strKeywords)
        {
            for (int i = 0, iLength = evt.lineText.length(); i < iLength;)
            {
                int indexOf = evt.lineText.toLowerCase().indexOf(strKeyword, i);
                
                if (indexOf < 0)
                {
                    break;
                }
                
                styles.add(new StyleRange(evt.lineOffset + indexOf, strKeyword.length() - 1, ResHelper.getColor(SWT.COLOR_BLUE), null, SWT.BOLD));
                
                i = indexOf + strKeyword.length();
            }
        }
        
        evt.styles = styles.toArray(new StyleRange[0]);
    }
}
