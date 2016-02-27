
module witchcraft.fields;

import witchcraft;

import std.algorithm;
import std.array;
import std.variant;

/++
 + Represents and grants access to a single field defined on a type.
 ++/
abstract class Field : Member
{
    abstract Variant get(Variant instance) const;

    T get(T = Variant, O)(O instance) const
    {
        auto result = this.get(Variant(instance));

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
    abstract const(Type) getValueType() const;

    @property
    abstract const(TypeInfo) getValueTypeInfo() const;

    /++
     + Checks if the field is declared as static. This returns true if the
     + is directly accessible on the type that is declared on (rather that on
     + an instance of that type).
     +
     + Returns:
     +   `true` if this field is static.
     ++/
    @property
    abstract bool isStatic() const;

    /++
     + Checks if the field can be written to.
     +
     + Returns:
     +   `true` if the value of the field can be set.
     ++/
    @property
    abstract bool isWritable() const;

    abstract void set(Variant instance, Variant value) const;

    void set(T, O)(O instance, T value) const
    {
        this.set(Variant(instance), Variant(value));
    }

    override string toString() const
    {
        return getValueTypeInfo.toString ~ " " ~ getName;
    }
}
