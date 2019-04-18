
module witchcraft.mixins.classes;

template HasDefaultConstructor(C) {
	bool helper() {
        bool r = false;
		foreach(overload; __traits(getOverloads, C, "__ctor")) {
			static if(__traits(compiles, { C function() ctor = &overload; })) {
                r = true;
                break;
            }
		}
		return r;
	}

	enum HasDefaultConstructor = helper();
}

mixin template WitchcraftClass(T)
{
    import witchcraft;

    import std.meta;
    import std.traits;

    static class ClassMixin(T) : Class 
    if(is(T == class)) //  && HasDefaultConstructor!T
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

        @property
        override Object create() const
        {
            TypeInfo_Class classInfo = T.classinfo;
            if(classInfo.defaultConstructor is null) {
                throw new Exception("No default constructor found in " ~ classInfo.name ~ ".");
            } else {
                Object o = classInfo.create;
                assert(o !is null);
                return o;
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

        override const(Constructor)[] getConstructors() const
        {
            static if(__traits(hasMember, T, "__ctor"))
            {
                alias constructors = AliasSeq!(__traits(getOverloads, T, "__ctor"));
                auto values = new Constructor[constructors.length];

                foreach(index, constructor; constructors)
                {
                    values[index] = new ConstructorMixin!(T, index);
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

        override const(InterfaceType)[] getInterfaces() const
        {
            alias Interfaces = InterfacesTuple!T;
            auto values = new InterfaceType[Interfaces.length];

            foreach(index, IFace; Interfaces)
            {
                values[index] = cast(InterfaceType) inspect!IFace;
            }

            return values;
        }

        string getFullName() const
        {
            return fullyQualifiedName!T;
        }

        string getName() const
        {
            return T.stringof;
        }

        string getProtection() const
        {
            return __traits(getProtection, T);
        }

        override const(Class) getSuperClass() const
        {
            static if(is(Unqual!T == Object))
            {
                return null;
            }
            else
            {
                alias Bases = BaseClassesTuple!T;

                static if(Bases.length > 0)
                {
                    return cast(const(Class)) inspect!(Bases[0]);
                }
                else
                {
                    return null;
                }
            }
        }

        override const(TypeInfo) getSuperTypeInfo() const
        {
            static if(is(Unqual!T == Object))
            {
                return null;
            }
            else
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
        final bool isAccessible() const
        {
            return true;
        }

        @property
        override bool isFinal() const
        {
            return __traits(isFinalClass, T);
        }

        override bool isSubClassOf(const Class other) const
        {
            return _d_isbaseof(T.classinfo, cast(ClassInfo) other.getTypeInfo);
        }

        override bool isSuperClassOf(const Class other) const
        {
            return _d_isbaseof(cast(ClassInfo) other.getTypeInfo, T.classinfo);
        }
    }
}
