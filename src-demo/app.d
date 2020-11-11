import std.conv;
import std.stdio;

import java.lang.all;

/*  */
void main()
{
    Abc abc = new Abc();

    abc.setFieldA("10");

    abc.getFieldA();

    writeln("test...");

    auto a = abc.fieldA.dup ~ "20";

    writeln(a);

    writeln("test...");
}

/** */
class Abc
{
    void setFieldA(string newproperty)
    {
        fieldA = newproperty;
    }

    string getFieldA()
    {
        return fieldA;
    }

private:
    string fieldA;
}
