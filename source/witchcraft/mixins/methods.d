
module witchcraft.mixins.methods;

mixin template WitchcraftMethod()
{
    import witchcraft;

    import std.meta;
    import std.traits;
    import std.variant;

    static class MethodImpl(T, string name, size_t overload) : Method
    {
    private:
        alias method = Alias!(__traits(getOverloads, T, name)[overload]);
        alias Return = ReturnType!method;

    public:
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

        override string getName() const
        {
            return name;
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
        override string getProtection() const
        {
            return __traits(getProtection, method);
        }

        @property
        override const(Class) getReturnClass() const
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
        override const(TypeInfo) getReturnType() const
        {
            return typeid(Return);
        }

        override Variant invoke(Variant instance, Variant[] arguments...) const
        {
            import std.algorithm, std.conv, std.range, std.string;

            alias Params = Parameters!method;

            auto i = instance.get!T;
            enum invokeString = iota(0, Params.length)
                .map!(i => "arguments[%s].get!(Params[%s])".format(i, i))
                .joiner
                .text;

            static if(!is(ReturnType!method == void))
            {
                mixin("auto result = __traits(getOverloads, i, name)[overload](" ~ invokeString ~ ");");

                return Variant(result);
            }
            else
            {
                mixin("__traits(getOverloads, i, name)[overload](" ~ invokeString ~ ");");

                return Variant(null);
            }
        }

        @property
        override bool isFinal() const
        {
            return __traits(isFinalFunction, method);
        }

        @property
        override bool isStatic() const
        {
            return __traits(isStaticFunction, method);
        }

        @property
        override bool isVarArgs() const
        {
            return variadicFunctionStyle!method != Variadic.no;
        }
    }
}
