
module witchcraft.classes;

import witchcraft;

import std.algorithm;
import std.array;
import std.traits;

abstract class Class : Member
{
protected:
    Field[string] _fields;
    Method[][string] _methods;

public:
    //abstract Object[] getConstructors();

    const(Field) getField(string name) const
    {
        auto field = getLocalField(name);

        if(field !is null)
        {
            return field;
        }
        else if(getParentClass !is null)
        {
            return getParentClass.getField(name);
        }
        else
        {
            return null;
        }
    }

    string[] getFieldNames() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getFieldNames ~ getLocalFieldNames;
        }
        else
        {
            return getLocalFieldNames;
        }
    }

    const(Field)[] getFields() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getFields ~ getLocalFields;
        }
        else
        {
            return getLocalFields;
        }
    }

    @property
    abstract string getFullName() const;

    const(Field) getLocalField(string name) const
    {
        auto ptr = name in _fields;
        return ptr ? *ptr : null;
    }

    string[] getLocalFieldNames() const
    {
        return getLocalFields.map!"a.getName".array;
    }

    const(Field)[] getLocalFields() const
    {
        return _fields.values;
    }

    const(Method) getLocalMethod(string name, TypeInfo[] parameterTypes...) const
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

    const(Method) getLocalMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getLocalMethod(name, types);
    }

    string[] getLocalMethodNames() const
    {
        return getLocalMethods.map!"a.getName".array;
    }

    const(Method)[] getLocalMethods(string name) const
    {
        auto ptr = name in _methods;
        return ptr ? *ptr : null;
    }

    const(Method)[] getLocalMethods() const
    {
        const(Method)[] methods;

        foreach(overloads; _methods)
        {
            methods ~= overloads;
        }

        return methods;
    }

    const(Method) getMethod(string name, TypeInfo[] parameterTypes...) const
    {
        auto method = getLocalMethod(name, parameterTypes);

        if(method !is null)
        {
            return method;
        }
        else if(getParentClass !is null)
        {
            return getParentClass.getMethod(name, parameterTypes);
        }
        else
        {
            return null;
        }
    }

    const(Method) getMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getMethod(name, types);
    }

    string[] getMethodNames() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getMethodNames ~ getLocalMethodNames;
        }
        else
        {
            return getLocalMethodNames;
        }
    }

    const(Method)[] getMethods(string name) const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getMethods(name) ~ getLocalMethods(name);
        }
        else
        {
            return getLocalMethods(name);
        }
    }

    const(Method)[] getMethods() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getMethods ~ getLocalMethods;
        }
        else
        {
            return getLocalMethods;
        }
    }

    @property
    abstract bool isAbstract() const;

    @property
    abstract bool isFinal() const;
}
