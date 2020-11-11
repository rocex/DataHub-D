module org.rocex.utils.VOHelper;

import java.lang.all;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.rocex.vo.SuperVO;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2020-7-4 21:50:54
 ***************************************************************************/
public class VOHelper
{
    private static Map mapAllGetter = null;
    private static Map mapAllSetter = null;

    private static Method[String][String] map = null;

    /***************************************************************************
     * @param clazz
     * @return Map<String, Method>
     * @author Rocex Wang
     * @version 2020-7-4 21:05:49
     ***************************************************************************/
    public static Map getGetter(TypeInfo_Class clazz)
    {
        String strKey = clazz.name;

        if (mapAllGetter is null)
        {
            mapAllGetter = new HashMap();
        }

        Map mapGetter = cast(Map) mapAllGetter.get(strKey);

        if (mapGetter is null || mapGetter.isEmpty())
        {
            initGetter(clazz);
        }

        return cast(Map) mapAllGetter.get(strKey);
    }

    /***************************************************************************
     * 得到 strFieldName 的 getter 方法
     * @param strFieldName 不区分大小写
     * @return Method
     * @author Rocex Wang
     * @version 2020-5-26 21:30:56
     ***************************************************************************/
    public static Method getGetter(Class clazz, String strFieldName)
    {
        String strKey = clazz.getName();

        if (mapAllGetter is null)
        {
            mapAllGetter = new HashMap();
        }

        Map mapGetter = cast(Map) mapAllGetter.get(strKey);

        if (mapGetter is null || mapGetter.isEmpty())
        {
            initGetter(clazz);
        }

        Method method = cast(Method)(cast(Map) mapAllGetter.get(strKey)).get(strFieldName.toLowerCase());

        return method;
    }

    /***************************************************************************
     * 得到 strFieldName 的 setter 方法
     * @param strFieldName 不区分大小写
     * @return Method
     * @author Rocex Wang
     * @version 2020-5-18 21:15:26
     ***************************************************************************/
    public static Method getSetter(Class clazz, String strFieldName)
    {
        String strKey = clazz.getName();

        if (mapAllSetter is null)
        {
            mapAllSetter = new HashMap();
        }

        Map mapSetter = cast(Map) mapAllSetter.get(strKey);

        if (mapSetter is null || mapSetter.isEmpty())
        {
            initSetter(clazz);
        }

        Method method = cast(Method)(cast(Map) mapAllSetter.get(strKey)).get(strFieldName.toLowerCase());

        return method;
    }

    /***************************************************************************
     * 初始化收集 VO 的所有 getter
     * @author Rocex Wang
     * @version 2020-5-26 21:51:22
     ***************************************************************************/
    protected static synchronized void initGetter(Class clazz)
    {
        Map mapGetter = new LinkedHashMap();

        mapAllGetter.put(cast(Object) clazz.classinfo, mapGetter);

        Method[] methods = clazz.getMethods();

        foreach (Method method; methods)
        {
            if (method.getParameterCount() != 0)
            {
                continue;
            }

            String strName = method.getName();

            if (strName.startsWith("get") && !"getClass".equals(strName))
            {
                String strKey = strName.substring(3).toLowerCase();

                mapGetter.put(strKey, method);
            }
            else if (strName.startsWith("is") && method.getReturnType() is Boolean)
            {
                String strKey = strName.substring(2).toLowerCase();

                mapGetter.put(strKey, method);
            }
        }
    }

    /***************************************************************************
     * 初始化收集 VO 的所有 setter
     * @author Rocex Wang
     * @version 2020-5-26 21:21:40
     ***************************************************************************/
    protected static synchronized void initSetter(Class clazz)
    {
        Map mapSetter = new LinkedHashMap();

        mapAllSetter.put(clazz.getName(), mapSetter);

        Method[] methods = clazz.getMethods();

        foreach (Method method; methods)
        {
            String strName = method.getName();

            if (strName.startsWith("set") && method.getParameterCount() == 1)
            {
                String strKey = strName.substring(3).toLowerCase();

                mapSetter.put(strKey, method);
            }
        }
    }
}
