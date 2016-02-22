
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

    public:
        override Variant create(Variant[] arguments...) const
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

        override const(Class)[] getParameterClasses() const
        {
            auto parameterClasses = new Class[Parameters!method.length];

            foreach(index, Parameter; Parameters!method)
            {
                static if(__traits(hasMember, Parameter, "classof"))
                {
                    parameterClasses[index] = Parameter.classof;
                }
            }

            return parameterClasses;
        }

        @property
        override const(TypeInfo)[] getParameterTypes() const
        {
            auto parameterTypes = new TypeInfo[Parameters!method.length];

            foreach(index, Parameter; Parameters!method)
            {
                parameterTypes[index] = typeid(Parameter);
            }

            return parameterTypes;
        }

        @property
        override string getProtection() const
        {
            return __traits(getProtection, method);
        }

        @property
        override bool isVarArgs() const
        {
            return variadicFunctionStyle!method != Variadic.no;
        }
    }
}
