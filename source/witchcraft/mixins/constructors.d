
module witchcraft.mixins.constructors;

mixin template WitchcraftConstructor(T)
{
    import witchcraft;

    import std.algorithm;
    import std.conv;
    import std.meta;
    import std.range;
    import std.string;
    import std.traits;
    import std.variant;

    static class ConstructorMixin(alias T, size_t overload) : Constructor
    {
    private:
        alias method = Alias!(__traits(getOverloads, T, "__ctor")[overload]);
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

        static if(isAbstractClass!T)
        {
            Variant invoke(Variant instance, Variant[] arguments...) const
            {
                assert(0, T.stringof ~ " is abstract.");
            }
        }
        else
        {
            Variant invoke(Variant instance, Variant[] arguments...) const
            {
                import std.algorithm, std.conv, std.range, std.string;

                alias Params = Parameters!method;

                enum variables = iota(0, Params.length)
                    .map!(i => "auto v%1$s = arguments[%1$s].get!(Params[%1$s]);".format(i))
                    .joiner.text;

                enum invokeString = iota(0, Params.length)
                    .map!(i => "v%s".format(i))
                    .joiner(", ").text;

                mixin(variables);
                mixin("Params args = AliasSeq!(" ~ invokeString ~ ");");

                static if(is(T == class))
                {
                    return Variant(new T(args));
                }
                else
                {
                    return Variant(T(args));
                }
            }
        }

        @property
        final bool isAccessible() const
        {
            return true;
        }

        @property
        bool isVarArgs() const
        {
            return variadicFunctionStyle!method != Variadic.no;
        }
    }
}
