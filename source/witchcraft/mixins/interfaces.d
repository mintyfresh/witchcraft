
module witchcraft.mixins.interfaces;

mixin template WitchcraftInterface()
{
    static class InterfaceTypeImpl(T) : InterfaceType
    if(is(T == interface))
    {
        this()
        {
            foreach(name; FieldNameTuple!T)
            {
                _fields[name] = new FieldMixin!(T, name);
            }

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

        @property
        final bool isAccessible() const
        {
            return true;
        }
    }
}
