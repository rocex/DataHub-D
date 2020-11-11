module org.rocex.vo.SuperVO;

import std.conv;

import java.lang.all;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.Map;

import java.util.Map;

//import java.util.Properties;
import java.util.Set;
import java.util.TreeMap;

import org.rocex.utils.Logger;
import org.rocex.utils.VOHelper;

/***************************************************************************
 * <br>
 * @author Rocex Wang
 * @version 2019-5-29 21:36:12
 ***************************************************************************/
public class SuperVO
{
    /****************************************************************************
     * {@inheritDoc}<br>
     * @see java.lang.Object#clone()
     * @author Rocex Wang
     * @version 2019-6-27 21:53:55
     ****************************************************************************/
    public SuperVO clone()
    {
        SuperVO newVO = null;

        try
        {
            newVO = cast(SuperVO) Object.factory(typeid(this).name);

            newVO.cloneFrom(toMap());
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }

        return newVO;
    }

    /***************************************************************************
     * @param mapKeyValue
     * @author Rocex Wang
     * @version 2019-5-29 21:30:24
     ***************************************************************************/
    public void cloneFrom(Map mapKeyValue)
    {
        Set entrySet = mapKeyValue.keySet();

        foreach (Object entry; entrySet)
        {
            setValue(entry.toString(), mapKeyValue.get(entry));
        }
    }

    /***************************************************************************
     * @param prop
     * @author Rocex Wang
     * @version 2020-1-18 21:04:27
     ***************************************************************************/
    //    public void cloneFrom(Properties prop)
    //    {
    //        Set entrySet = prop.entrySet();
    //
    //        foreach (Entry entry; entrySet)
    //        {
    //setValue(cast(String) entry.getKey(), entry.getValue());
    //        }
    //    }

    /***************************************************************************
     * 从sourceVO复制属性数据
     * @param sourceVO
     * @return targetVO
     * @author Rocex Wang
     * @version 2020-1-17 21:38:47
     ***************************************************************************/
    public void cloneFrom(SuperVO sourceVO)
    {
        cloneFrom(sourceVO.toMap());
    }

    /***************************************************************************
     * 取得 strFieldName 的值
     * @param strFieldName 不区分大小写
     * @return Object
     * @author Rocex Wang
     * @version 2019-6-11 21:05:23
     ***************************************************************************/
    public Object getValue(String strFieldName)
    {
        if (strFieldName is null || strFieldName.trim().length() == 0)
        {
            Logger.getLogger().error("field is null or empty for getValue(): " ~ strFieldName);
            return null;
        }

        Method method = VOHelper.getGetter(typeof(this).classinfo, strFieldName);

        if (method !is null)
        {
            try
            {
                return method.invoke(this, cast(Object[]) null);
            }
            catch (IllegalAccessException ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
            catch (InvocationTargetException ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
            catch (IllegalArgumentException ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
        }

        return null;
    }

    /***************************************************************************
     * 直接给属性赋值
     * @param strFieldName 不区分大小写
     * @param objValue
     * @author Rocex Wang
     * @version 2020-1-18 21:45:45
     ***************************************************************************/
    protected void setFieldValue(String strFieldName, Object objValue)
    {
        Field field = null;
        bool blAccessible = false;

        try
        {
            field = getClass().getDeclaredField(strFieldName);

            blAccessible = field.isAccessible();

            if (!blAccessible)
            {
                field.setAccessible(true);
            }

            field.set(this, objValue);
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }
        finally
        {
            if (!blAccessible && field !is null)
            {
                field.setAccessible(false);
            }
        }
    }

    /***************************************************************************
     * 设置 strFieldName 的值
     * @param strFieldName 不区分大小写
     * @param objValue
     * @author Rocex Wang
     * @version 2019-6-11 21:18:34
     ***************************************************************************/
    public void setValue(String strFieldName, Object objValue)
    {
        if (strFieldName is null || strFieldName.trim().length() == 0)
        {
            Logger.getLogger().info("field is null or empty for setValue(): " ~ strFieldName);
            return;
        }

        Method method = VOHelper.getSetter(getClass(), strFieldName);

        if (method is null)
        {
            Logger.getLogger().info("do not find field method for setValue(): " ~ strFieldName);
            return;
        }

        Logger.getLogger().info(strFieldName ~ ": " ~ to!(String)(objValue));

        Class[] parameterTypes = method.getParameterTypes();

        try
        {
            if (parameterTypes !is null && parameterTypes.length > 0)
            {
                Class classParamType = parameterTypes[0];

                if (classParamType is BigDecimal)
                {
                    setValueToBigDecimal(method, objValue);
                }
                else if (classParamType is Boolean)
                {
                    setValueToBoolean(method, objValue);
                }
                else if (classParamType is Integer)
                {
                    setValueToInt(method, objValue);
                }
                else if (classParamType is String)
                {
                    setValueToString(method, objValue);
                }
                else
                {
                    method.invoke(this, objValue);
                }
            }
            else
            {
                method.invoke(this, objValue);
            }
        }
        catch (Exception ex)
        {
            Logger.getLogger().error(ex.msg, ex);
        }
    }

    /***************************************************************************
     * @param method
     * @param objValue
     * @throws Exception
     * @author Rocex Wang
     * @version 2020-5-18 21:22:43
     ***************************************************************************/
    protected void setValueToBigDecimal(Method method, Object objValue) //throw Exception
    {
        BigDecimal decimal = null;

        if (objValue is null || objValue is BigDecimal)
        {
            decimal = cast(BigDecimal) objValue;
        }
        else if (objValue is Integer)
        {
            decimal = new BigDecimal(objValue.toString());
        }

        method.invoke(this, decimal);
    }

    /***************************************************************************
     * @param method
     * @param objValue
     * @throws Exception
     * @author Rocex Wang
     * @version 2020-5-18 21:19:26
     ***************************************************************************/
    protected void setValueToBoolean(Method method, Object objValue) //throws Exception
    {
        Boolean blValue = null;

        if (objValue is null || objValue is Boolean)
        {
            blValue = cast(Boolean) objValue;
        }
        else if (objValue is BigDecimal)
        {
            blValue = (cast(BigDecimal) objValue) == 1;
        }
        else if (objValue is Integer)
        {
            blValue = (cast(Integer) objValue).intValue() == 1;
        }
        else
        {
            blValue = Boolean.valueOf(objValue.toString());
        }

        method.invoke(this, blValue);
    }

    /***************************************************************************
     * @param method
     * @param objValue
     * @author Rocex Wang
     * @version 2020-1-6 21:23:56
     * @throws Exception
     ***************************************************************************/
    protected void setValueToInt(Method method, Object objValue) // throws Exception
    {
        Integer intValue = null;

        if (objValue is null || objValue is Integer)
        {
            intValue = cast(Integer) objValue;
        }
        else if (objValue is BigDecimal)
        {
            intValue = (cast(BigDecimal) objValue).intValue();
        }
        else
        {
            intValue = Integer.parseInt(objValue.toString());
        }

        method.invoke(this, intValue);
    }

    /***************************************************************************
     * @param method
     * @param objValue
     * @throws Exception
     * @author Rocex Wang
     * @version 2020-5-28 21:44:25
     ***************************************************************************/
    protected void setValueToString(Method method, Object objValue) //throws Exception
    {
        String strValue = null;

        if (objValue is null || objValue is String)
        {
            strValue = cast(String) objValue;
        }
        else
        {
            strValue = objValue.toString();
        }

        method.invoke(this, strValue);
    }

    /***************************************************************************
     * @return Map
     * @author Rocex Wang
     * @version 2019-5-29 21:02:38
     ***************************************************************************/
    public Map toMap()
    {
        Map mapGetter = VOHelper.getGetter(getClass());

        Map mapKeyValue = new TreeMap();

        Set entrySet = mapGetter.entrySet();

        foreach (Entry entry; entrySet)
        {
            Object objValue = null;

            try
            {
                objValue = entry.getValue().invoke(this, cast(Object[]) null);

                if (objValue is null)
                {
                    continue;
                }

                mapKeyValue.put(entry.getKey(), objValue);
            }
            catch (IllegalAccessException ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
            catch (IllegalArgumentException ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
            catch (InvocationTargetException ex)
            {
                Logger.getLogger().error(ex.msg, ex);
            }
        }

        return mapKeyValue;
    }

    /****************************************************************************
     * {@inheritDoc}<br>
     * @see java.lang.Object#toString()
     * @author Rocex Wang
     * @version 2019-5-24 21:23:54
     ****************************************************************************/
    override public String toString()
    {
        return toMap().toString();
    }
}
