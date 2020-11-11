module propTest;

import std.algorithm;
import std.conv;
import std.stdio;
import std.string;
import std.traits;

/** 可动态加载属性，可用于VOHelper的实现 */

struct Encrypted
{ //一个构就可以了
}

enum Color
{
    black,
    blue,
    red
} //枚举

struct Colored
{ //默认颜色为黑
    Color color;
}

struct Person
{
    @Encrypted @Colored(Color.blue) string name;
    //加密,颜色为蓝
    string lastName; //无
    @Colored(Color.red) string address; //红颜色
}

//有颜色返回指定颜色,无,为黑色
Color colorAttributeOf(T, string memberName)()
{
    auto result = Color.black;

    foreach (attr; __traits(getAttributes, __traits(getMember, T, memberName)))
    {
        static if (is(typeof(attr) == Colored))
        {
            result = attr.color;
        }
    }

    return result;
}

auto encrypted(string value)
{ //简单加密
    return value.map!(a => dchar(a + 1));
}

unittest
{
    assert("abcdefghij".encrypted.equal("bcdefghijk"));
}

void printAsXML(T)(T object)
{ //见上
    writefln("<%s>", T.stringof);
    scope (exit)
        writefln("</%s>", T.stringof);
    foreach (member; __traits(allMembers, T))
    {
        string value = __traits(getMember, object, member).to!string;
        static if (hasUDA!(__traits(getMember, T, member), Encrypted))
        {
            value = value.encrypted.to!string;
        }

        writefln(`  <%1$s color="%2$s">%3$s</%1$s>`, member, colorAttributeOf!(T, member), value);
    }
}

void main2()
{
    auto people = [
        Person("Alice", "Davignon", "Avignon"),
        Person("Ben", "de Bordeaux", "Bordeaux")
    ];
    foreach (person; people)
    {
        printAsXML(person);
    }
}
