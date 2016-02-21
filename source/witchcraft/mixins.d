
module witchcraft.mixins;

mixin template Witchcraft()
{
    static if(__traits(hasMember, typeof(super), "getClass"))
    {
        override mixin WitchcraftImpl;
    }
    else
    {
        mixin WitchcraftImpl;
    }
}

mixin template WitchcraftImpl()
{
    import witchcraft;

    import std.meta;
    import std.traits;
    import std.variant;

    private static Class __classinfoext;

    static Class getClass()
    {
        static class ClassImpl(T) : Class
        {
            mixin WitchcraftAttribute;
            mixin WitchcraftField;
            mixin WitchcraftMethod;

            this()
            {
                foreach(name; FieldNameTuple!T)
                {
                    this._fields[name] = new FieldImpl!name;
                }

                foreach(name; __traits(derivedMembers, T))
                {
                    static if(is(typeof(__traits(getMember, T, name)) == function))
                    {
                        foreach(index, overload; __traits(getOverloads, T, name))
                        {
                            this._methods[name] ~= new MethodImpl!(name, index);
                        }
                    }
                }
            }

            @property
            const(Attribute)[] getAttributes() const
            {
                const(Attribute)[] attributes;

                foreach(attribute; __traits(getAttributes, T))
                {
                    attributes ~= new AttributeImpl!attribute;
                }

                return attributes;
            }

            @property
            override string getFullName() const
            {
                return T.classinfo.name;
            }

            @property
            string getName() const
            {
                return T.stringof;
            }

            @property
            const(Class) getParentClass() const
            {
                static if(__traits(hasMember, BaseClassesTuple!T[0], "getClass"))
                {
                    return BaseClassesTuple!T[0].getClass;
                }
                else
                {
                    return null;
                }
            }

            @property
            const(TypeInfo) getParentType() const
            {
                return typeid(BaseClassesTuple!T[0]);
            }

            @property
            string getProtection() const
            {
                return __traits(getProtection, T);
            }

            @property
            override bool isAbstract() const
            {
                return __traits(isAbstractClass, T);
            }

            @property
            override bool isFinal() const
            {
                return __traits(isFinalClass, T);
            }
        }

        if(__classinfoext is null)
        {
            __classinfoext = new ClassImpl!(typeof(this));
        }

        return __classinfoext;
    }
}

mixin template WitchcraftAttribute()
{
    static class AttributeImpl(alias attribute) : Attribute
    {
        override Variant get() const
        {
            static if(is(typeof(attribute)))
            {
                return Variant(attribute);
            }
            else
            {
                assert(0, "Attribute has no value.");
            }
        }

        override const(Class) getClass() const
        {
            static if(is(typeof(attribute)))
            {
                static if(__traits(hasMember, typeof(attribute), "getClass"))
                {
                    return typeof(attribute).getClass;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                static if(__traits(hasMember, attribute, "getClass"))
                {
                    return attribute.getClass;
                }
                else
                {
                    return null;
                }
            }
        }

        override const(TypeInfo) getType() const
        {
            static if(is(typeof(attribute)))
            {
                return typeid(typeof(attribute));
            }
            else
            {
                return typeid(attribute);
            }
        }

        override bool isExpression() const
        {
            return is(typeof(attribute));
        }

        override bool isType() const
        {
            return !isExpression;
        }
    }
}

mixin template WitchcraftField()
{
    static class FieldImpl(string name) : Field
    {
        override Variant get(Object instance) const
        {
            return Variant(__traits(getMember, cast(T) instance, name));
        }

        @property
        const(Attribute)[] getAttributes() const
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
        string getName() const
        {
            return name;
        }

        @property
        const(Class) getParentClass() const
        {
            return T.getClass;
        }

        @property
        const(TypeInfo) getParentType() const
        {
            return typeid(T);
        }

        @property
        string getProtection() const
        {
            return __traits(getProtection, __traits(getMember, T, name));
        }

        @property
        override const(TypeInfo) getType() const
        {
            return typeid(typeof(__traits(getMember, T, name)));
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

mixin template WitchcraftMethod()
{
    static class MethodImpl(string name, size_t overload) : Method
    {
        @property
        const(Attribute)[] getAttributes() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);
            alias attributes = AliasSeq!(__traits(getAttributes, method));

            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        @property
        string getName() const
        {
            return name;
        }

        @property
        override const(TypeInfo)[] getParameterTypes() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);
            auto parameterTypes = new TypeInfo[Parameters!method.length];

            foreach(index, Parameter; Parameters!method)
            {
                parameterTypes[index] = typeid(Parameter);
            }

            return parameterTypes;
        }

        @property
        const(Class) getParentClass() const
        {
            return T.getClass;
        }

        @property
        const(TypeInfo) getParentType() const
        {
            return typeid(T);
        }

        @property
        string getProtection() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);

            return __traits(getProtection, method);
        }

        @property
        override const(Class) getReturnClass() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);
            alias Return = ReturnType!method;

            static if(__traits(hasMember, Return, "getClass"))
            {
                return Return.getClass;
            }
            else
            {
                return null;
            }
        }

        @property
        override const(TypeInfo) getReturnType() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);
            alias Return = ReturnType!method;

            return typeid(Return);
        }

        override Variant invoke(Object instance, Variant[] arguments...) const
        {
            import std.algorithm, std.conv, std.range, std.string;

            alias method = Alias!(__traits(getOverloads, T, name)[overload]);
            alias Params = Parameters!method;

            enum invokeString = iota(0, Params.length)
                .map!(i => "arguments[%s].get!(Params[%s])".format(i, i))
                .joiner
                .text;

            static if(!is(ReturnType!method == void))
            {
                mixin("auto result = __traits(getOverloads, cast(T) instance, name)[overload](" ~ invokeString ~ ");");

                return Variant(result);
            }
            else
            {
                mixin("__traits(getOverloads, cast(T) instance, name)[overload](" ~ invokeString ~ ");");

                return Variant(null);
            }
        }

        @property
        override bool isFinal() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);

            return __traits(isFinalFunction, method);
        }

        @property
        override bool isStatic() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);

            return __traits(isStaticFunction, method);
        }
    }
}
