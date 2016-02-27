
module witchcraft.mixins.methods;

mixin template WitchcraftMethod()
{
    import witchcraft;

    import std.meta;
    import std.traits;
    import std.variant;

    static class MethodMixin(alias T, string name, size_t overload) : Method
    {
    private:
        alias method = Alias!(__traits(getOverloads, T, name)[overload]);
        alias Return = ReturnType!method;

    public:
        const(Attribute)[] getAttributes() const
        {
            alias attributes = AliasSeq!(__traits(getAttributes, method));
            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        const(Type) getDeclaringType() const
        {
            alias Parent = Alias!(__traits(parent, method));

            return inspect!Parent;
        }

        const(TypeInfo) getDeclaringTypeInfo() const
        {
            alias Parent = Alias!(__traits(parent, method));

            static if(__traits(compiles, typeid(Parent)))
            {
                return typeid(Parent);
            }
            else
            {
                return null;
            }
        }

        string getName() const
        {
            return name;
        }

        string getFullName() const
        {
            return fullyQualifiedName!method;
        }

        const(Type)[] getParameterTypes() const
        {
            auto parameterTypes = new Type[Parameters!method.length];

            foreach(index, Parameter; Parameters!method)
            {
                parameterTypes[index] = inspect!Parameter;
            }

            return parameterTypes;
        }

        const(TypeInfo)[] getParameterTypeInfos() const
        {
            auto parameterTypeInfos = new TypeInfo[Parameters!method.length];

            foreach(index, Parameter; Parameters!method)
            {
                static if(__traits(compiles, typeid(Parameter)))
                {
                    parameterTypeInfos[index] = typeid(Parameter);
                }
            }

            return parameterTypeInfos;
        }

        string getProtection() const
        {
            return __traits(getProtection, method);
        }

        const(Type) getReturnType() const
        {
            return inspect!Return;
        }

        @property
        const(TypeInfo) getReturnTypeInfo() const
        {
            static if(__traits(compiles, typeid(Return)))
            {
                return typeid(Return);
            }
            else
            {
                return null;
            }
        }

        Variant invoke(Variant instance, Variant[] arguments...) const
        {
            import std.algorithm, std.conv, std.range, std.string;

            alias Params = Parameters!method;

            template NormalizeType(T)
            {
                static if(is(T == InoutOf!T))
                {
                    // HACK: There's no good way to remove inout-ness.
                    alias NormalizeType = void *;
                }
                else
                {
                    alias NormalizeType = T;
                }
            }

            enum variables = iota(0, Params.length)
                .map!(i => "auto v%1$s = arguments[%1$s].get!(NormalizeType!(Params[%1$s]));".format(i))
                .joiner
                .text;

            enum invokeString = iota(0, Params.length)
                .map!(i => "v%1$s".format(i))
                .joiner(", ")
                .text;

            mixin(variables);

            static if(is(T == class))
            {
                auto this_ = cast(ClassInfo) typeid(T);
                auto other = cast(ClassInfo) instance.type;

                // Ensure both types exist and can be converted.
                if(!this_ || !other || !(_d_isbaseof(this_, other) || _d_isbaseof(other, this_)))
                {
                    assert(0, "Instance isn't type of `" ~ T.stringof ~ "`.");
                }

                Unqual!T obj = instance.coerce!(Unqual!T);
            }
            else static if(is(T))
            {
                Unqual!T obj = instance.get!(Unqual!T);
            }
            else
            {
                alias obj = T;
            }

            static if(!is(ReturnType!method == void))
            {
                mixin("auto result = __traits(getOverloads, obj, name)[overload](" ~ invokeString ~ ");");

                return Variant(result);
            }
            else
            {
                mixin("__traits(getOverloads, obj, name)[overload](" ~ invokeString ~ ");");

                return Variant(null);
            }
        }

        @property
        final bool isAccessible() const
        {
            return true;
        }

        @property
        override bool isFinal() const
        {
            return __traits(isFinalFunction, method);
        }

        @property
        override bool isOverride() const
        {
            return __traits(isOverrideFunction, method);
        }

        @property
        override bool isStatic() const
        {
            return __traits(isStaticFunction, method);
        }

        @property
        bool isVarArgs() const
        {
            return variadicFunctionStyle!method != Variadic.no;
        }
    }
}
