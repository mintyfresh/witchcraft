
module witchcraft.classes;

import witchcraft;

import std.algorithm;
import std.array;
import std.traits;

abstract class Class : Member
{
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

    string[] getFieldNames() const
    {
        return getFields.map!"a.getName".array;
    }

    abstract string getFullName() const;

    abstract const(Field) getLocalField(string name) const;

    string[] getLocalFieldNames() const
    {
        return getLocalFields.map!"a.getName".array;
    }

    abstract const(Field)[] getLocalFields() const;

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

    abstract const(Method)[] getLocalMethods() const;

    abstract const(Method)[] getLocalMethods(string name) const;

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

    @property
    abstract bool isAbstract() const;

    @property
    abstract bool isFinal() const;
}
