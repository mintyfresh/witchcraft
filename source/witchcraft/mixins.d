
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

    private static ClassInfoExt __classinfoext;

    static ClassInfoExt getClass()
    {
        static class ClassInfoExtImpl(T) : ClassInfoExt
        {
            mixin WitchcraftFieldInfo;
            mixin WitchcraftMethodInfo;

            static class AttributeInfoImpl(alias attribute) : AttributeInfo
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

            this(ClassInfo info)
            {
                super(info);

                static if(__traits(hasMember, BaseClassesTuple!T[0], "getClass"))
                {
                    __classinfoext._super = BaseClassesTuple!T[0].getClass;
                }

                foreach(name; FieldNameTuple!T)
                {
                    this._fields[name] = new FieldInfoImpl!name;
                }

                foreach(name; __traits(derivedMembers, T))
                {
                    static if(is(typeof(__traits(getMember, T, name)) == function))
                    {
                        foreach(index, overload; __traits(getOverloads, T, name))
                        {
                            this._methods[name] ~= new MethodInfoImpl!(name, index);
                        }
                    }
                }
            }

            override const(AttributeInfo)[] getAttributes() const
            {
                const(AttributeInfo)[] attributes;

                foreach(attribute; __traits(getAttributes, T))
                {
                    attributes ~= new AttributeInfoImpl!attribute;
                }

                return attributes;
            }

            override bool isAbstract() const
            {
                return __traits(isAbstractClass, T);
            }

            override bool isFinal() const
            {
                return __traits(isFinalClass, T);
            }
        }

        if(__classinfoext is null)
        {
            __classinfoext = new ClassInfoExtImpl!(typeof(this))(typeof(this).classinfo);
        }

        return __classinfoext;
    }
}

mixin template WitchcraftFieldInfo()
{
    static class FieldInfoImpl(string name) : FieldInfo
    {
        override Variant get(Object instance) const
        {
            return Variant(__traits(getMember, cast(T) instance, name));
        }

        override string getName() const
        {
            return name;
        }

        override const(ClassInfoExt) getParentClass() const
        {
            return T.getClass;
        }

        override const(TypeInfo) getParentType() const
        {
            return typeid(T);
        }

        override string getProtection() const
        {
            return __traits(getProtection, __traits(getMember, T, name));
        }

        override const(TypeInfo) getType() const
        {
            return typeid(typeof(__traits(getMember, T, name)));
        }

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

mixin template WitchcraftMethodInfo()
{
    static class MethodInfoImpl(string name, size_t overload) : MethodInfo
    {
        override string getName() const
        {
            return name;
        }

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

        override const(ClassInfoExt) getParentClass() const
        {
            return T.getClass;
        }

        override const(TypeInfo) getParentType() const
        {
            return typeid(T);
        }

        override const(ClassInfoExt) getReturnClass() const
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

            mixin("return Variant(__traits(getOverloads, cast(T) instance, name)[overload](" ~ invokeString ~ "));");
        }

        override bool isFinal() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);

            return __traits(isFinalFunction, method);
        }

        override bool isStatic() const
        {
            alias method = Alias!(__traits(getOverloads, T, name)[overload]);

            return __traits(isStaticFunction, method);
        }
    }
}
