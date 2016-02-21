
module witchcraft.fieldinfo;

import std.variant;

abstract class FieldInfo
{
protected:
    string _name;
    TypeInfo _type;

    this(string name, TypeInfo type)
    {
        _name = name;
        _type = type;
    }

public:
    @property
    abstract bool isStatic() const;

    @property
    string getName() const
    {
        return _name;
    }

    @property
    const(TypeInfo) getType() const
    {
        return _type;
    }

    abstract Variant get(Object instance) const;

    T get(T)(Object instance) const
    {
        return this.get(instance).get!T;
    }

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
