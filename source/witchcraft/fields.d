
module witchcraft.fields;

import witchcraft;

import std.algorithm;
import std.array;
import std.variant;

abstract class Field : Member
{
    abstract Variant get(Variant instance) const;

    T get(T, O)(O instance) const
    {
        return this.get(Variant(instance)).get!T;
    }

    @property
    abstract const(Aggregate) getValueClass() const;

    @property
    abstract const(TypeInfo) getValueType() const;

    @property
    abstract bool isStatic() const;

    abstract void set(Variant instance, Variant value) const;

    void set(T, O)(O instance, T value) const
    {
        return this.set(Variant(instance), Variant(value));
    }

    override string toString() const
    {
        return getValueType.toString ~ " " ~ getName;
    }
}
