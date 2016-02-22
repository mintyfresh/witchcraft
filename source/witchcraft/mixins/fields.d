
module witchcraft.mixins.fields;

mixin template WitchcraftField()
{
    import witchcraft;

    import std.meta;
    import std.variant;

    static class FieldImpl(T, string name) : Field
    {
        override Variant get(Object instance) const
        {
            return Variant(__traits(getMember, cast(T) instance, name));
        }

        @property
        override const(Attribute)[] getAttributes() const
        {
            alias member = Alias!(__traits(getMember, T, name));
            alias attributes = AliasSeq!(__traits(getAttributes, member));

            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        @property
        override const(Class) getDeclaringClass() const
        {
            return T.classof;
        }

        @property
        override const(TypeInfo) getDeclaringType() const
        {
            return typeid(T);
        }

        @property
        override string getName() const
        {
            return name;
        }

        @property
        override string getProtection() const
        {
            return __traits(getProtection, __traits(getMember, T, name));
        }

        @property
        override const(Class) getValueClass() const
        {
            alias Type = typeof(__traits(getMember, T, name));

            static if(__traits(hasMember, Type, "classof"))
            {
                return Type.classof;
            }
            else
            {
                return null;
            }
        }

        @property
        override const(TypeInfo) getValueType() const
        {
            alias Type = typeof(__traits(getMember, T, name));

            return typeid(Type);
        }

        @property
        override bool isStatic() const
        {
            return __traits(compiles, {
                auto value = __traits(getMember, T, name);
            });
        }

        override void set(Object instance, Variant value) const
        {
            alias Type = typeof(__traits(getMember, T, name));

            __traits(getMember, cast(T) instance, name) = value.get!Type;
        }
    }
}
