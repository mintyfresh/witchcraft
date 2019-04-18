
module witchcraft.mixins.interfaces;

mixin template WitchcraftInterface(T)
{
    import witchcraft;

    import std.meta;
    import std.traits;

    static class InterfaceTypeMixin(T) : InterfaceType
    if(is(T == interface))
    {
        this()
        {
            foreach(name; __traits(derivedMembers, T))
            {
                static if(is(typeof(__traits(getMember, T, name)) == function))
                {
                    static if(name != "__ctor" && name != "__dtor")
                    {
                        foreach(index, overload; __traits(getOverloads, T, name))
                        {
                            _methods[name] ~= new MethodMixin!(T, name, index);
                        }
                    }
                }
            }
        }

        const(Attribute)[] getAttributes() const
        {
            alias attributes = AliasSeq!(__traits(getAttributes, T));
            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        const(Type) getDeclaringType() const
        {
            alias Parent = Alias!(__traits(parent, T));

            return inspect!Parent;
        }

        const(TypeInfo) getDeclaringTypeInfo() const
        {
            alias Parent = Alias!(__traits(parent, T));

            static if(__traits(compiles, typeid(Parent)))
            {
                return typeid(Parent);
            }
            else
            {
                return null;
            }
        }

        override const(Field) getField(string name) const
        {
            auto ptr = name in _fields;
            return ptr ? *ptr : null;
        }

        override const(Field)[] getFields() const
        {
            return _fields.values;
        }

        string getFullName() const
        {
            return fullyQualifiedName!T;
        }

        override const(Method)[] getMethods(string name) const
        {
            auto ptr = name in _methods;
            return ptr ? *ptr : null;
        }

        override const(Method)[] getMethods() const
        {
            const(Method)[] methods;

            foreach(overloads; _methods.values)
            {
                methods ~= overloads;
            }

            return methods;
        }

        string getName() const
        {
            return T.stringof;
        }

        string getProtection() const
        {
            return __traits(getProtection, T);
        }

        override const(TypeInfo) getTypeInfo() const
        {
            return typeid(T);
        }

        @property
        final bool isAccessible() const
        {
            return true;
        }
    }
}
