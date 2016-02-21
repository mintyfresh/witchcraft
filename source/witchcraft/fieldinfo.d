
module witchcraft.fieldinfo;

import witchcraft;

import std.algorithm;
import std.array;
import std.variant;

abstract class FieldInfo : MemberInfo
{
    abstract Variant get(Object instance) const;

    T get(T)(Object instance) const
    {
        return this.get(instance).get!T;
    }

    @property
    abstract const(TypeInfo) getType() const;

    @property
    abstract bool isStatic() const;

    abstract void set(Object instance, Variant value) const;

    void set(T)(Object instance, T value) const
    {
        return this.set(instance, Variant(value));
    }

    override string toString() const
    {
        return getType.toString ~ " " ~ getName;
    }
}
