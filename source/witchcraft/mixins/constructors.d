
module witchcraft.mixins.constructors;

mixin template WitchcraftConstructor()
{
    import witchcraft;

    import std.algorithm;
    import std.conv;
    import std.meta;
    import std.range;
    import std.string;
    import std.traits;
    import std.variant;

    static class ConstructorMixin(T, size_t overload) : Constructor
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

            static if(__traits(hasMember, Parent, "classof"))
            {
                return Parent.classof;
            }
            else
            {
                static if(is(Parent == class))
                {
                    return new ClassImpl!Parent;
                }
                else static if(is(Parent == struct))
                {
                    return new StructImpl!Parent;
                }
                else static if(is(Parent == interface))
                {
                    return new InterfaceTypeImpl!Parent;
                }
                else
                {
                    return null;
                }
            }
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
                static if(__traits(hasMember, Parameter, "classof"))
                {
                    parameterTypes[index] = Parameter.classof;
                }
                else
                {
                    static if(is(Parameter == class))
                    {
                        parameterTypes[index] = new ClassImpl!Parameter;
                    }
                    else static if(is(Parameter == struct))
                    {
                        parameterTypes[index] = new StructImpl!Parameter;
                    }
                    else static if(is(Parameter == interface))
                    {
                        parameterTypes[index] = new InterfaceTypeImpl!Parameter;
                    }
                    else
                    {
                        parameterTypes[index] = null;
                    }
                }
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
            static if(__traits(hasMember, Return, "classof"))
            {
                return Return.classof;
            }
            else
            {
                static if(is(Return == class))
                {
                    return new ClassImpl!Return;
                }
                else static if(is(Return == struct))
                {
                    return new StructImpl!Return;
                }
                else static if(is(Return == interface))
                {
                    return new InterfaceTypeImpl!Return;
                }
                else
                {
                    return null;
                }
            }
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
