
module witchcraft.impl.fields;

import witchcraft;

import std.variant;

template FieldImpl(T, string name)
{
    static if(__traits(getProtection, __traits(getMember, T, name)) == "public")
    {
        mixin WitchcraftField;

        alias FieldImpl = FieldMixin!(T, name);
    }
    else
    {
        class FieldImpl : Field
        {
            override Variant get(Variant instance) const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            const(Attribute)[] getAttributes() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            const(Type) getDeclaringType() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            const(TypeInfo) getDeclaringTypeInfo() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            string getFullName() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            @property
            string getName() const
            {
                return name;
            }

            string getProtection() const
            {
                return __traits(getProtection, __traits(getMember, T, name));
            }

            override const(Type) getValueType() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            override const(TypeInfo) getValueTypeInfo() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            @property
            override bool isStatic() const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }

            @property
            bool isAccessible() const
            {
                return __traits(hasMember, typeof(this), "member");
            }

            @property
            override bool isWritable() const
            {
                return __traits(compiles, {
                    T instance = void;
                    typeof(member) value = void;

                    __traits(getMember, instance, name) = value;
                });
            }

            override void set(Variant instance, Variant value) const
            {
                assert(0, "Field " ~ name ~ " is inaccessible.");
            }
        }
    }
}
