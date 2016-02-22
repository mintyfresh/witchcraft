
module witchcraft.mixins.fields;

mixin template WitchcraftField()
{
    import witchcraft;

    import std.meta;
    import std.traits;
    import std.variant;

    static class FieldImpl(T, string name) : Field
    {
    private:
        alias member = Alias!(__traits(getMember, T, name));
        alias Type   = typeof(member);

    public:
        override Variant get(Variant instance) const
        {
            auto i = instance.get!T;

            return Variant(__traits(getMember, i, name));
        }

        @property
        override const(Attribute)[] getAttributes() const
        {
            alias attributes = AliasSeq!(__traits(getAttributes, member));

            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        @property
        override const(Aggregate) getDeclaringClass() const
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
        override string getFullName() const
        {
            return fullyQualifiedName!member;
        }

        @property
        override string getProtection() const
        {
            return __traits(getProtection, __traits(getMember, T, name));
        }

        @property
        override const(Aggregate) getValueClass() const
        {
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
            return typeid(Type);
        }

        @property
        override bool isStatic() const
        {
            return __traits(compiles, {
                auto value = __traits(getMember, T, name);
            });
        }

        override void set(Variant instance, Variant value) const
        {
            auto i = instance.get!T;

            __traits(getMember, i, name) = value.get!Type;
        }
    }
}
