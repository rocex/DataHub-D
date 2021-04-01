module org.rocex.vo.Pair;

/***************************************************************************
 * <br>
 * @param <K>
 * @param <V>
 * @author Rocex Wang
 * @since 2021-3-30 22:04:22
 ***************************************************************************/
public class Pair(K, V)
{
    /** Key of this <code>Pair</code>. */
    private K objKey;

    /** Value of this this <code>Pair</code>. */
    private V objValue;

    /***************************************************************************
     * @param key
     * @param value
     * @author Rocex Wang
     * @since 2021-3-30 22:04:37
     ***************************************************************************/
    public this(K key, V value)
    {
        this.objKey = key;
        this.objValue = value;
    }

    /***************************************************************************
     * @param obj
     * @author Rocex Wang
     * @since 2021-3-30 22:04:37
     ***************************************************************************/
    public bool equals(Object obj)
    {
        if (this == obj)
        {
            return true;
        }

        if (typeid(obj).classinfo.name == Pair.classinfo.name)
        {
            Pair pair = cast(Pair) obj;

            if (objKey != pair.objKey || objValue != pair.objValue)
            {
                return false;
            }

            return true;
        }

        return false;
    }

    /***************************************************************************
     * @return string
     * @author Rocex Wang
     * @since 2021-3-30 22:04:51
     ***************************************************************************/
    public K getKey()
    {
        return objKey;
    }

    /***************************************************************************
     * @return string
     * @author Rocex Wang
     * @since 2021-3-30 22:04:59
     ***************************************************************************/
    public V getValue()
    {
        return objValue;
    }
}
