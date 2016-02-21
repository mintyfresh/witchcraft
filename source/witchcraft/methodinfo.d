
module witchcraft.methodinfo;

import witchcraft;

import std.string;
import std.variant;

abstract class MethodInfo
{
    abstract string getName() const;

    abstract const(TypeInfo)[] getParameterTypes() const;

    abstract const(ClassInfoExt) getParentClass() const;

    abstract const(TypeInfo) getParentType() const;

    abstract const(ClassInfoExt) getReturnClass() const;

    abstract const(TypeInfo) getReturnType() const;

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

    override string toString() const
    {
        return "%s %s(%(%s, %))".format(getReturnType, getName, getParameterTypes);
    }
}
