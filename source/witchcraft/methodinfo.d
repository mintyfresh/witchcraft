
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
    abstract Variant invoke(Object instance, Variant[] arguments...) const;

    T invoke(T = Variant, TList...)(Object instance, TList arguments) const
    {
        auto values = new Variant[TList.length];

        foreach(index, argument; arguments)
        {
            values[index] = Variant(argument);
        }

        auto result = this.invoke(instance, values);

        static if(is(T == Variant))
        {
            return result;
        }
        else
        {
            return result.get!T;
        }
    }

    abstract bool isFinal() const;

    abstract bool isStatic() const;

    bool isVirtual() const
    {
        return !isFinal && !isStatic;
    }

    @property
    string getName() const
    {
        return _name;
    }

    @property
    const(TypeInfo)[] getParameterTypes() const
    {
        return _parameterTypes;
    }

    @property
    const(TypeInfo) getReturnType() const
    {
        return _returnType;
    }

    override string toString() const
    {
        return "%s %s(%(%s, %))".format(getReturnType, getName, getParameterTypes);
    }
}
