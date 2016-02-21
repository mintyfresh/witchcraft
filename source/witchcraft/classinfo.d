
module witchcraft.classinfo;

import witchcraft.fieldinfo;
import witchcraft.methodinfo;

import std.algorithm;
import std.array;
import std.traits;

alias ClassInfoExt = TypeInfo_ClassExt;

abstract class TypeInfo_ClassExt : TypeInfo_Class
{
protected:
    FieldInfo[string] _fields;
    MethodInfo[][string] _methods;
    TypeInfo_ClassExt _parent;

public:
    this(TypeInfo_Class info)
    {
        foreach(name; FieldNameTuple!TypeInfo_Class)
        {
            __traits(getMember, this, name) = __traits(getMember, info, name);
        }
    }

    //abstract Object[] getConstructors();

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
        return getLocalFields.map!"a.getName".array;
    }

    const(MethodInfo) getMethod(string name, TypeInfo[] parameterTypes...) const
    {
        auto method = getLocalMethod(name, parameterTypes);

        if(method !is null)
        {
            return method;
        }
        else if(getParent !is null)
        {
            return getParent.getMethod(name, parameterTypes);
        }
        else
        {
            return null;
        }
    }

    const(MethodInfo) getMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getMethod(name, types);
    }

    const(MethodInfo)[] getMethods(string name) const
    {
        if(getParent !is null)
        {
            return getParent.getMethods(name) ~ getLocalMethods(name);
        }
        else
        {
            return getLocalMethods(name);
        }
    }

    const(MethodInfo)[] getMethods() const
    {
        if(getParent !is null)
        {
            return getParent.getMethods ~ getLocalMethods;
        }
        else
        {
            return getLocalMethods;
        }
    }

    const(MethodInfo) getLocalMethod(string name, TypeInfo[] parameterTypes...) const
    {
        auto methods = getLocalMethods(name);

        if(methods !is null)
        {
            foreach(method; methods)
            {
                if(method.getParameterTypes == parameterTypes)
                {
                    return method;
                }
            }

            return null;
        }
        else
        {
            return null;
        }
    }

    const(MethodInfo) getLocalMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getLocalMethod(name, types);
    }

    const(MethodInfo)[] getLocalMethods(string name) const
    {
        auto ptr = name in _methods;
        return ptr ? *ptr : null;
    }

    const(MethodInfo)[] getLocalMethods() const
    {
        const(MethodInfo)[] methods;

        foreach(overloads; _methods)
        {
            methods ~= overloads;
        }

        return methods;
    }

    string[] getMethodNames() const
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

    string[] getLocalMethodNames() const
    {
        return getLocalMethods.map!"a.getName".array;
    }

    const(TypeInfo_ClassExt) getParent() const
    {
        return _parent;
    }

    @property
    abstract bool isAbstract() const;

    @property
    abstract bool isFinal() const;
}
