module org.rocex.utils;

import org.rocex.vo.SuperVO;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @since 2020-7-4 22:50:54
 ***************************************************************************/
public class VOHelper
{
    private static Method[String][String] mapAllGetter = null;
    private static Method[String][String] mapAllSetter = null;

    /***************************************************************************
     * @param clazz
     * @return Map<String, Method>
     * @author Rocex Wang
     * @since 2020-7-4 22:05:49
     ***************************************************************************/
    public static Method[String] getGetter(TypeInfo_Class clazz)
    {
        String strClassKey = clazz.name;

        const Method[String] mapGetter = mapAllGetter[strClassKey];

        if (mapGetter is null || mapGetter.length == 0)
        {
            initGetterSetter(clazz);
        }

        return mapAllGetter.get(strClassKey);
    }

    /***************************************************************************
     * 得到 strFieldName 的 getter 方法
     * @param strFieldName 不区分大小写
     * @return Method
     * @author Rocex Wang
     * @since 2020-5-26 22:30:56
     ***************************************************************************/
    public static Method getGetter(TypeInfo_Class clazz, String strFieldName)
    {
        String strClassKey = clazz.name;

        const Method[String] mapGetter = mapAllGetter[strClassKey];

        if (mapGetter is null || mapGetter.length == 0)
        {
            initGetterSetter(clazz);
        }

        Method method = mapAllGetter[strClassKey][strFieldName.toLowerCase()];

        return method;
    }

    /***************************************************************************
     * 得到 strFieldName 的 setter 方法
     * @param strFieldName 不区分大小写
     * @return Method
     * @author Rocex Wang
     * @since 2020-5-18 22:15:26
     ***************************************************************************/
    public static Method getSetter(TypeInfo_Class clazz, String strFieldName)
    {
        String strClassKey = clazz.name;

        const Method[String] mapSetter = mapAllSetter[strClassKey];

        if (mapSetter is null || mapSetter.length == 0)
        {
            initGetterSetter(clazz);
        }

        Method method = mapAllSetter[strClassKey][strFieldName.toLowerCase()];

        return method;
    }

    /***************************************************************************
     * 初始化收集 VO 的所有 getter
     * @author Rocex Wang
     * @since 2020-5-26 22:51:22
     ***************************************************************************/
    protected static synchronized void initGetterSetter(TypeInfo_Class clazz)
    {
        MemberInfo[] memberInfos = Object.factory(clazz.name).getMembers(null);

        if (memberInfos is null || memberInfos.length == 0)
        {
            return;
        }

        Method[String] mapGetter = null;
        Method[String] mapSetter = null;

        mapAllGetter[clazz.name] = mapGetter;
        mapAllSetter[clazz.name] = mapSetter;

        foreach (MemberInfo memberInfo; memberInfos)
        {

        }

        for (PropertyDescriptor propertyDescriptor; propertyDescriptors)
        {
            // write method
            Method writeMethod = propertyDescriptor.getWriteMethod();

            String strWriteKey = writeMethod.getName().substring(3).toLowerCase();

            mapSetter.put(strWriteKey, writeMethod);

            // read methon
            Method readMethod = propertyDescriptor.getReadMethod();

            String strName = readMethod.getName();

            if (strName.startsWith("get"))
            {
                String strReadKey = strName.substring(3).toLowerCase();

                mapGetter.put(strReadKey, readMethod);
            }
            else if (strName.startsWith("is") && readMethod.getReturnType() == Boolean.class)
            {
                String strReadKey = strName.substring(2).toLowerCase();

                mapGetter.put(strReadKey, readMethod);
            }
        }
    }
}
