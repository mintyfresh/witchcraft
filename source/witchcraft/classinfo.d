
module witchcraft.classinfo;

import witchcraft.fieldinfo;

import std.algorithm;
import std.array;
import std.traits;

alias ClassInfoExt = TypeInfo_ClassExt;

abstract class TypeInfo_ClassExt : TypeInfo_Class
{
protected:
    FieldInfo[string] _fields;

public:
    this(TypeInfo_Class info)
    {
        foreach(name; FieldNameTuple!TypeInfo_Class)
        {
            __traits(getMember, this, name) = __traits(getMember, info, name);
        }
    }

    abstract Object[] getConstructors();

    const(FieldInfo) getField(string name) const
    {
        auto field = getLocalField(name);

        if(field !is null)
        {
            return field;
        }
        else if(getParent !is null)
        {
            return getParent.getField(name);
        }
        else
        {
            return null;
        }
    }

    const(FieldInfo)[] getFields() const
    {
        if(getParent !is null)
        {
            return getParent.getFields ~ getLocalFields;
        }
        else
        {
            return getLocalFields;
        }
    }

    const(FieldInfo) getLocalField(string name) const
    {
        auto ptr = name in _fields;
        return ptr ? *ptr : null;
    }

    const(FieldInfo)[] getLocalFields() const
    {
        return _fields.values;
    }

    string[] getFieldNames() const
    {
        if(getParent !is null)
        {
            return getParent.getFieldNames ~ getLocalFieldNames;
        }
        else
        {
            return getLocalFieldNames;
        }
    }

    string[] getLocalFieldNames() const
    {
        return _fields.values.map!"a.getName".array;
    }

    abstract Object[] getMethods();

    abstract Object[] getLocalMethods();

    string[] getMethodNames()
    {
        if(getParent !is null)
        {
            return getParent.getMethodNames ~ getLocalMethodNames;
        }
        else
        {
            return getLocalMethodNames;
        }
    }

    abstract string[] getLocalMethodNames();

    TypeInfo_ClassExt getParent() const
    {
        return cast(TypeInfo_ClassExt) this.base;
    }
}
