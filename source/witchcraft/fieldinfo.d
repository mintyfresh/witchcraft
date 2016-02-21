
module witchcraft.fieldinfo;

import witchcraft;

import std.algorithm;
import std.array;
import std.variant;

abstract class FieldInfo
{
    abstract Variant get(Object instance) const;

    T get(T)(Object instance) const
    {
        return this.get(instance).get!T;
    }

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
    abstract const(ClassInfoExt) getParentClass() const;

    @property
    abstract const(TypeInfo) getParentType() const;

    @property
    abstract string getProtection() const;

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
