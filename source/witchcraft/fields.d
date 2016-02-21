
module witchcraft.fields;

import witchcraft;

import std.algorithm;
import std.array;
import std.variant;

abstract class Field : Member
{
    abstract Variant get(Object instance) const;

    T get(T)(Object instance) const
    {
        return this.get(instance).get!T;
    }

    @property
    abstract const(Class) getValueClass() const;

    @property
    abstract const(TypeInfo) getValueType() const;

    @property
    abstract bool isStatic() const;

    abstract void set(Object instance, Variant value) const;

    void set(T)(Object instance, T value) const
    {
        return this.set(instance, Variant(value));
    }

    override string toString() const
    {
        return getValueType.toString ~ " " ~ getName;
    }
}
