
module witchcraft.fieldinfo;

import std.variant;

abstract class FieldInfo
{
protected:
    TypeInfo _type;
    string _name;

    this(TypeInfo type, string name)
    {
        _type = type;
        _name = name;
    }

public:
    @property
    abstract bool isStatic() const;

    @property
    string name() const
    {
        return _name;
    }

    @property
    TypeInfo type()
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
        return type.toString ~ " " ~ name;
    }
}
