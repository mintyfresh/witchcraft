
module witchcraft.methodinfo;

import std.string;
import std.variant;

abstract class MethodInfo
{
protected:
    string _name;
    TypeInfo[] _parameterTypes;
    TypeInfo _returnType;

    this(string name, TypeInfo[] parameterTypes, TypeInfo returnType)
    {
        _name = name;
        _parameterTypes = parameterTypes;
        _returnType = returnType;
    }

public:
    abstract bool isFinal() const;

    abstract bool isStatic() const;

    bool isVirtual() const
    {
        return !isFinal && !isStatic;
    }

    @property
    string name() const
    {
        return _name;
    }

    @property
    TypeInfo[] getParameterTypes()
    {
        return _parameterTypes;
    }

    @property
    TypeInfo getReturnType()
    {
        return _returnType;
    }

    override string toString()
    {
        return "%s %s(%(%s, %))".format(getReturnType, name, getParameterTypes);
    }
}
