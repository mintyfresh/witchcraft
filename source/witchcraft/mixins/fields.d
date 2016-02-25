
module witchcraft.mixins.fields;

mixin template WitchcraftField()
{
    import witchcraft;

    import std.meta;
    import std.traits;
    import std.variant;

    static class FieldMixin(alias T, string name) : Field
    {
    private:
        alias member = Alias!(__traits(getMember, T, name));

        enum bool writable = __traits(compiles, {
            T instance = void;
            typeof(member) value = void;

            __traits(getMember, instance, name) = value;
        });

    public:
        override Variant get(Variant instance) const
        {
            static if(is(T))
            {
                auto i = instance.get!T;
            }
            else
            {
                alias i = T;
            }

            return Variant(__traits(getMember, i, name));
        }

        const(Attribute)[] getAttributes() const
        {
            alias attributes = AliasSeq!(__traits(getAttributes, member));
            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        const(Type) getDeclaringType() const
        {
            alias Parent = Alias!(__traits(parent, member));

            return inspect!Parent;
        }

        const(TypeInfo) getDeclaringTypeInfo() const
        {
            alias Parent = Alias!(__traits(parent, member));

            static if(__traits(compiles, typeid(Parent)))
            {
                return typeid(Parent);
            }
            else
            {
                return null;
            }
        }

        @property
        string getName() const
        {
            return name;
        }

        string getFullName() const
        {
            return fullyQualifiedName!member;
        }

        string getProtection() const
        {
            return __traits(getProtection, __traits(getMember, T, name));
        }

        override const(Type) getValueType() const
        {
            return inspect!(typeof(member));
        }

        override const(TypeInfo) getValueTypeInfo() const
        {
            return typeid(typeof(member));
        }

        @property
        final bool isAccessible() const
        {
            return true;
        }

        @property
        override bool isStatic() const
        {
            return __traits(compiles, {
                auto value = __traits(getMember, T, name);
            });
        }

        @property
        override bool isWritable() const
        {
            return writable;
        }

        override void set(Variant instance, Variant value) const
        {
            static if(is(T))
            {
                auto i = instance.get!T;
            }
            else
            {
                alias i = T;
            }

            static if(writable)
            {
                __traits(getMember, i, name) = value.get!(typeof(member));
            }
            else
            {
                assert("Field " ~ name ~ " is not writable.");
            }
        }
    }
}
