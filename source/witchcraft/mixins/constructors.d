
module witchcraft.mixins.constructors;

mixin template WitchcraftConstructor()
{
    import witchcraft;

    import std.algorithm;
    import std.conv;
    import std.meta;
    import std.range;
    import std.string;
    import std.variant;

    static class ConstructorImpl(T, size_t overload) : Constructor
    {
    private:
        alias method = Alias!(__traits(getOverloads, T, "__ctor")[overload]);
        alias Return = ReturnType!method;

    public:
        override const(Attribute)[] getAttributes() const
        {
            alias attributes = AliasSeq!(__traits(getAttributes, method));

            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        override const(Type) getDeclaringType() const
        {
            alias Parent = Alias!(__traits(parent, method));

            static if(__traits(hasMember, Parent, "classof"))
            {
                return Parent.classof;
            }
            else
            {
                return null;
            }
        }

        override const(TypeInfo) getDeclaringTypeInfo() const
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

        override string getFullName() const
        {
            return fullyQualifiedName!method;
        }

        override const(Type)[] getParameterTypes() const
        {
            auto parameterTypes = new Class[Parameters!method.length];

            foreach(index, Parameter; Parameters!method)
            {
                static if(__traits(hasMember, Parameter, "classof"))
                {
                    parameterTypes[index] = Parameter.classof;
                }
            }

            return parameterTypes;
        }

        override const(TypeInfo)[] getParameterTypeInfos() const
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

        override string getProtection() const
        {
            return __traits(getProtection, method);
        }

        override const(Type) getReturnType() const
        {
            static if(__traits(hasMember, Return, "classof"))
            {
                return Return.classof;
            }
            else
            {
                return null;
            }
        }

        @property
        override const(TypeInfo) getReturnTypeInfo() const
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

        override Variant invoke(Variant instance, Variant[] arguments...) const
        {
            alias Params = Parameters!method;

            enum invokeString = iota(0, Params.length)
                .map!(i => "arguments[%s].get!(Params[%s])".format(i, i))
                .joiner
                .text;

            static if(is(T == class))
            {
                mixin("return Variant(new T(" ~ invokeString ~ "));");
            }
            else static if(is(T == struct))
            {
                mixin("return Variant(T(" ~ invokeString ~ "));");
            }
            else
            {
                static assert(0);
            }
        }

        @property
        override bool isVarArgs() const
        {
            return variadicFunctionStyle!method != Variadic.no;
        }
    }
}
