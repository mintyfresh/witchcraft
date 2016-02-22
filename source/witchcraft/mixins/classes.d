
module witchcraft.mixins.classes;

mixin template WitchcraftClass()
{
    import witchcraft;

    import std.traits;

    static class ClassImpl(T) : Class
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

        @property
        override Object create() const
        {
            return T.classinfo.create;
        }

        override const(Attribute)[] getAttributes() const
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

        override const(Type) getDeclaringType() const
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

        override const(TypeInfo) getDeclaringTypeInfo() const
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

        override string getFullName() const
        {
            return fullyQualifiedName!T;
        }

        override const(Field) getLocalField(string name) const
        {
            auto ptr = name in _fields;
            return ptr ? *ptr : null;
        }

        override const(Field)[] getLocalFields() const
        {
            return _fields.values;
        }

        override const(Method)[] getLocalMethods(string name) const
        {
            auto ptr = name in _methods;
            return ptr ? *ptr : null;
        }

        override const(Method)[] getLocalMethods() const
        {
            const(Method)[] methods;

            foreach(overloads; _methods.values)
            {
                methods ~= overloads;
            }

            return methods;
        }

        override string getName() const
        {
            return T.stringof;
        }

        override string getProtection() const
        {
            return __traits(getProtection, T);
        }

        override const(Class) getSuperClass() const
        {
            alias Bases = BaseClassesTuple!T;

            static if(Bases.length == 0)
            {
                return null;
            }
            else static if(__traits(hasMember, Bases[0], "classof"))
            {
                return Bases[0].classof;
            }
            else
            {
                return null;
            }
        }

        override const(TypeInfo) getSuperType() const
        {
            alias Bases = BaseClassesTuple!T;

            static if(Bases.length > 0)
            {
                return typeid(Bases[0]);
            }
            else
            {
                return null;
            }
        }

        override const(TypeInfo) getTypeInfo() const
        {
            return T.classinfo;
        }

        @property
        override bool isAbstract() const
        {
            return __traits(isAbstractClass, T);
        }

        @property
        override bool isFinal() const
        {
            return __traits(isFinalClass, T);
        }
    }
}
