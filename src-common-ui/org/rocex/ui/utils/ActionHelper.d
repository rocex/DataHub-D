module org.rocex.ui.utils.ActionHelper;

import java.util.StringTokenizer;
import org.eclipse.swt.SWT;
import std.conv;
import std.string;

/***************************************************************************
 * <br>
 * Authors: Rocex Wang
 * Date: 2020-5-29 21:16:50
 ***************************************************************************/
public final class ActionHelper
{
    private static int[string] keyCodes = null;

    private static string[int] keyStrings = null;

    /*****************************************************************************
     * Converts an accelerator key code to a string representation.
     * Params: keyCode the key code to be translated
     * Returns: a string representation of the key code
     ****************************************************************************/
    public static string convertAccelerator(int keyCode)
    {
        const string strModifier = getModifierString(keyCode);

        string strFullKey = strModifier is null || strModifier.length == 0
            ? findKeyString(keyCode) : (strModifier ~ "+" ~ findKeyString(keyCode));

        return strFullKey;
    }

    /*****************************************************************************
     * Parses the given accelerator text, and converts it to an accelerator key code.
     * Params: acceleratorText the accelerator text
     * Returns: the SWT key code, or 0 if there is no accelerator
     ****************************************************************************/
    public static int convertAccelerator(string acceleratorText)
    {
        int strAccelerator = 0;

        StringTokenizer strToken = new StringTokenizer(acceleratorText, "+");

        int keyCode = -1;

        bool hasMoreTokens = strToken.hasMoreTokens();

        while (hasMoreTokens)
        {
            string token = strToken.nextToken();
            hasMoreTokens = strToken.hasMoreTokens();

            // Every token except the last must be one of the modifiers Ctrl, Shift, Alt, or Command
            if (hasMoreTokens)
            {
                const int modifier = findModifier(token);
                if (modifier != 0)
                {
                    strAccelerator |= modifier;
                }
                else
                {
                    return 0; // Leave if there are none
                }
            }
            else
            {
                keyCode = findKeyCode(token);
            }
        }

        if (keyCode != -1)
        {
            strAccelerator |= keyCode;
        }

        return strAccelerator;
    }

    /*****************************************************************************
     * Maps a standard keyboard key name to an SWT key code. Key names are converted to upper case before
     * comparison. If the key name is a single letter, for example "S", its character code is returned.
     * <p>
     * The following key names are known (case is ignored):
     * </p>
     * <ul>
     * <li><code>"BACKSPACE"</code></li>
     * <li><code>"TAB"</code></li>
     * <li><code>"RETURN"</code></li>
     * <li><code>"ENTER"</code></li>
     * <li><code>"ESC"</code></li>
     * <li><code>"ESCAPE"</code></li>
     * <li><code>"DELETE"</code></li>
     * <li><code>"SPACE"</code></li>
     * <li><code>"ARROW_UP"</code>, <code>"ARROW_DOWN"</code>,
     * <code>"ARROW_LEFT"</code>, and <code>"ARROW_RIGHT"</code></li>
     * <li><code>"PAGE_UP"</code> and <code>"PAGE_DOWN"</code></li>
     * <li><code>"HOME"</code></li>
     * <li><code>"END"</code></li>
     * <li><code>"INSERT"</code></li>
     * <li><code>"F1"</code>, <code>"F2"</code> through <code>"F12"</code></li>
     * </ul>
     * Params: strToken the key name
     * Returns: the SWT key code, <code>-1</code> if no match was found
     * @see SWT
     ****************************************************************************/
    public static int findKeyCode(string strToken)
    {
        if (keyCodes is null || keyCodes.length == 0)
        {
            initKeyCodes();
        }

        strToken = toLower(strToken);
        int i = keyCodes.get(strToken, -9999);

        if (i != -9999)
        {
            return i;
        }

        if (strToken.length == 1)
        {
            return strToken[0];
        }

        return -1;
    }

    /*****************************************************************************
     * Maps an SWT key code to a standard keyboard key name. The key code is stripped of modifiers (SWT.CTRL,
     * SWT.ALT, SWT.SHIFT, and SWT.COMMAND). If the key code is not an SWT code (for example if it a key code for
     * the key 'S'), a string containing a character representation of the key code is returned.
     * Params: keyCode the key code to be translated
     * Returns: the string representation of the key code
     * @see SWT
     * Date: 2.0
     ****************************************************************************/
    public static string findKeyString(int keyCode)
    {
        if (keyStrings is null || keyStrings.length == 0)
        {
            initKeyStrings();
        }

        const int i = keyCode & ~(SWT.CTRL | SWT.ALT | SWT.SHIFT | SWT.COMMAND);

        string result = null;

        if (i in keyStrings)
        {
            result = keyStrings[i];
        }

        if (result !is null)
        {
            return result;
        }

        result = to!string(cast(char) i);

        return result;
    }

    /*****************************************************************************
     * Maps standard keyboard modifier key names to the corresponding SWT modifier bit. The following modifier key
     * names are recognized (case is ignored): <code>"CTRL"</code>, <code>"SHIFT"</code>, <code>"ALT"</code>, and
     * <code>"COMMAND"</code>. The given modifier key name is converted to upper case before comparison.
     * Params: strToken the modifier key name
     * Returns: the SWT modifier bit, or <code>0</code> if no match was found
     * @see SWT
     ****************************************************************************/
    public static int findModifier(string strToken)
    {
        // if ("ctrl".equalsIgnoreCase(strToken))
        if (icmp("ctrl", strToken) == 0)
        {
            return SWT.CTRL;
        }
        else if (icmp("shift", strToken) == 0)
        {
            return SWT.SHIFT;
        }
        else if (icmp("alt", strToken) == 0)
        {
            return SWT.ALT;
        }
        else if (icmp("command", strToken) == 0)
        {
            return SWT.COMMAND;
        }

        return 0;
    }

    /*****************************************************************************
     * Returns a string representation of an SWT modifier bit (SWT.CTRL, SWT.ALT, SWT.SHIFT, and SWT.COMMAND).
     * Returns <code>null</code> if the key code is not an SWT modifier bit.
     * Params: keyCode the SWT modifier bit to be translated
     * Returns: the string representation of the SWT modifier bit, or <code>null</code> if the key code was not an
     *         SWT modifier bit
     * @see SWT
     ****************************************************************************/
    public static string findModifierString(int keyCode)
    {
        if (keyCode == SWT.CTRL)
        {
            return "Ctrl";
        }
        else if (keyCode == SWT.ALT)
        {
            return "Alt";
        }
        else if (keyCode == SWT.SHIFT)
        {
            return "Shift";
        }
        else if (keyCode == SWT.COMMAND)
        {
            return "Command";
        }

        return null;
    }

    /*****************************************************************************
     * Returns the string representation of the modifiers (Ctrl, Alt, Shift, Command) of the key event.
     * Params: keyCode The key code for which the modifier string is desired.
     * Returns: The string representation of the key code; never <code>null</code>.
     ****************************************************************************/
    private static string getModifierString(int keyCode)
    {
        string strModifier = "";

        if ((keyCode & SWT.CTRL) != 0)
        {
            strModifier = findModifierString(keyCode & SWT.CTRL);
        }

        if ((keyCode & SWT.ALT) != 0)
        {
            strModifier = strModifier is null || strModifier.length == 0
                ? findModifierString(keyCode & SWT.ALT) : strModifier ~ "+" ~ findModifierString(
                        keyCode & SWT.ALT);
        }

        if ((keyCode & SWT.SHIFT) != 0)
        {
            strModifier = strModifier is null || strModifier.length == 0
                ? findModifierString(keyCode & SWT.SHIFT) : strModifier ~ "+" ~ findModifierString(
                        keyCode & SWT.SHIFT);
        }

        if ((keyCode & SWT.COMMAND) != 0)
        {
            strModifier = strModifier is null || strModifier.length == 0
                ? findModifierString(keyCode & SWT.COMMAND) : strModifier ~ "+" ~ findModifierString(
                        keyCode & SWT.COMMAND);
        }

        return strModifier;
    }

    /*****************************************************************************
     * Initializes the internal key code table.
     ****************************************************************************/
    private static void initKeyCodes()
    {
        keyCodes["BACKSPACE"] = 8;
        keyCodes["TAB"] = 9;
        keyCodes["RETURN"] = 13;
        keyCodes["ENTER"] = 13;
        keyCodes["ESCAPE"] = 27;
        keyCodes["ESC"] = 27;
        keyCodes["DELETE"] = 127;

        keyCodes["SPACE"] = cast(int) ' ';
        keyCodes["ARROW UP"] = SWT.ARROW_UP;
        keyCodes["ARROW DOWN"] = SWT.ARROW_DOWN;
        keyCodes["ARROW LEFT"] = SWT.ARROW_LEFT;
        keyCodes["ARROW RIGHT"] = SWT.ARROW_RIGHT;
        keyCodes["PAGE UP"] = SWT.PAGE_UP;
        keyCodes["PAGE DOWN"] = SWT.PAGE_DOWN;
        keyCodes["HOME"] = SWT.HOME;
        keyCodes["END"] = SWT.END;
        keyCodes["INSERT"] = SWT.INSERT;
        keyCodes["F1"] = SWT.F1;
        keyCodes["F2"] = SWT.F2;
        keyCodes["F3"] = SWT.F3;
        keyCodes["F4"] = SWT.F4;
        keyCodes["F5"] = SWT.F5;
        keyCodes["F6"] = SWT.F6;
        keyCodes["F7"] = SWT.F7;
        keyCodes["F8"] = SWT.F8;
        keyCodes["F9"] = SWT.F9;
        keyCodes["F10"] = SWT.F10;
        keyCodes["F11"] = SWT.F11;
        keyCodes["F12"] = SWT.F12;
        keyCodes["F13"] = SWT.F13;
        keyCodes["F14"] = SWT.F14;
        keyCodes["F15"] = SWT.F15;
        // keyCodes["F16"] = SWT.F16;
        // keyCodes["F17"] = SWT.F17;
        // keyCodes["F18"] = SWT.F18;
        // keyCodes["F19"] = SWT.F19;
        // keyCodes["F20"] = SWT.F20;
    }

    /*****************************************************************************
     * Initializes the internal key string table.
     ****************************************************************************/
    private static void initKeyStrings()
    {
        keyStrings[8] = "Backspace";
        keyStrings[9] = "Tab";
        keyStrings[13] = "Return";
        keyStrings[13] = "Enter";
        keyStrings[27] = "Escape";
        keyStrings[27] = "Esc";
        keyStrings[127] = "Delete";

        keyStrings[cast(int) ' '] = "Space";

        keyStrings[SWT.ARROW_UP] = "Arrow Up";
        keyStrings[SWT.ARROW_DOWN] = "Arrow Down";
        keyStrings[SWT.ARROW_LEFT] = "Arrow Left";
        keyStrings[SWT.ARROW_RIGHT] = "Arrow Right";
        keyStrings[SWT.PAGE_UP] = "Page Up";
        keyStrings[SWT.PAGE_DOWN] = "Page Down";
        keyStrings[SWT.HOME] = "Home";
        keyStrings[SWT.END] = "End";
        keyStrings[SWT.INSERT] = "Insert";
        keyStrings[SWT.F1] = "F1";
        keyStrings[SWT.F2] = "F2";
        keyStrings[SWT.F3] = "F3";
        keyStrings[SWT.F4] = "F4";
        keyStrings[SWT.F5] = "F5";
        keyStrings[SWT.F6] = "F6";
        keyStrings[SWT.F7] = "F7";
        keyStrings[SWT.F8] = "F8";
        keyStrings[SWT.F9] = "F9";
        keyStrings[SWT.F10] = "F10";
        keyStrings[SWT.F11] = "F11";
        keyStrings[SWT.F12] = "F12";
        keyStrings[SWT.F13] = "F13";
        keyStrings[SWT.F14] = "F14";
        keyStrings[SWT.F15] = "F15";
        // keyStrings[SWT.F16] = "F16";
        // keyStrings[SWT.F17] = "F17";
        // keyStrings[SWT.F18] = "F18";
        // keyStrings[SWT.F19] = "F19";
        // keyStrings[SWT.F20] = "F20";
    }
}
