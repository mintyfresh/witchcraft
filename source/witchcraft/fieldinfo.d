
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
    TypeInfo getType()
    {
        return _type;
    }

    abstract Variant get(Object instance);

    T get(T)(Object instance)
    {
        return this.get(instance).get!T;
    }

    abstract void set(Object instance, Variant value);

    void set(T)(Object instance, T value)
    {
        return this.set(instance, Variant(value));
    }

    override string toString()
    {
        return getType.toString ~ " " ~ getName;
    }
}
