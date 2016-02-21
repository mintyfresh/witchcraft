
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
            static class FieldInfoImpl(string name) : FieldInfo
            {
                this()
                {
                    super(name, typeid(typeof(__traits(getMember, T, name))));
                }

                override bool isStatic() const
                {
                    return __traits(compiles, {
                        auto value = __traits(getMember, T, name);
                    });
                }

                override Variant get(Object instance) const
                {
                    return Variant(__traits(getMember, cast(T) instance, name));
                }

                override void set(Object instance, Variant value) const
                {
                    alias Type = typeof(__traits(getMember, T, name));

                    __traits(getMember, cast(T) instance, name) = value.get!Type;
                }
            }

            static class MethodInfoImpl(string name, size_t overload) : MethodInfo
            {
                this()
                {
                    alias method = Alias!(__traits(getOverloads, T, name)[overload]);

                    auto returnType = typeid(ReturnType!method);
                    auto parameterTypes = new TypeInfo[Parameters!method.length];

                    foreach(index, Parameter; Parameters!method)
                    {
                        parameterTypes[index] = typeid(Parameter);
                    }

                    super(name, parameterTypes, returnType);
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

            this(ClassInfo info)
            {
                super(info);

                static if(__traits(hasMember, BaseClassesTuple!T[0], "getClass"))
                {
                    __classinfoext._parent = BaseClassesTuple!T[0].getClass;
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
