
module witchcraft.methodinfo;

import witchcraft;

import std.algorithm;
import std.array;
import std.string;
import std.variant;

abstract class MethodInfo
{
    @property
    abstract const(AttributeInfo)[] getAttributes() const;

    @property
    const(AttributeInfo)[] getAttributes(TypeInfo type) const
    {
        return getAttributes.filter!(a => a.getType == type).array;
    }

    @property
    const(AttributeInfo)[] getAttributes(T)() const
    {
        return getAttributes(typeid(T));
    }

    @property
    abstract string getName() const;

    @property
    abstract const(TypeInfo)[] getParameterTypes() const;

    @property
    abstract const(ClassInfoExt) getParentClass() const;

    @property
    abstract const(TypeInfo) getParentType() const;

    @property
    abstract const(ClassInfoExt) getReturnClass() const;

    @property
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

    @property
    abstract bool isFinal() const;

    @property
    abstract bool isStatic() const;

    @property
    bool isVirtual() const
    {
        return !isFinal && !isStatic;
    }

    override string toString() const
    {
        return "%s %s(%(%s, %))".format(getReturnType, getName, getParameterTypes);
    }
}
