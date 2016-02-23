
module witchcraft.mixins.structs;

mixin template WitchcraftStruct()
{
    static class StructImpl(T) : Struct
    {
    private:
        Field[string] _fields;
        Method[][string] _methods;

    public:
        this()
        {
            foreach(name; FieldNameTuple!T)
            {
                _fields[name] = new FieldImpl!(T, name);
            }

            foreach(name; __traits(derivedMembers, T))
            {
                static if(is(typeof(__traits(getMember, T, name)) == function))
                {
                    static if(name != "__ctor" && name != "__dtor")
                    {
                        foreach(index, overload; __traits(getOverloads, T, name))
                        {
                            _methods[name] ~= new MethodImpl!(T, name, index);
                        }
                    }
                }
            }
        }

        const(Attribute)[] getAttributes() const
        {
            const(Attribute)[] attributes;

            foreach(attribute; __traits(getAttributes, T))
            {
                attributes ~= new AttributeImpl!attribute;
            }

            return attributes;
        }

        override const(Constructor)[] getConstructors() const
        {
            static if(__traits(hasMember, T, "__ctor"))
            {
                alias constructors = AliasSeq!(__traits(getOverloads, T, "__ctor"));
                auto values = new Constructor[constructors.length];

                foreach(index, constructor; constructors)
                {
                    values[index] = new ConstructorImpl!(T, index);
                }

                return values;
            }
            else
            {
                return [ ];
            }
        }

        const(Type) getDeclaringType() const
        {
            alias Parent = Alias!(__traits(parent, T));

            static if(__traits(hasMember, Parent, "classof"))
            {
                return Parent.classof;
            }
            else
            {
                return null;
            }
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

        const(Field) getField(string name) const
        {
            auto ptr = name in _fields;
            return ptr ? *ptr : null;
        }

        const(Field)[] getFields() const
        {
            return _fields.values;
        }

        string getFullName() const
        {
            return fullyQualifiedName!T;
        }

        const(Method)[] getMethods(string name) const
        {
            auto ptr = name in _methods;
            return ptr ? *ptr : null;
        }

        const(Method)[] getMethods() const
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

        const(TypeInfo) getTypeInfo() const
        {
            return typeid(T);
        }
    }
}
