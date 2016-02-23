
module witchcraft.impl.classes;

import witchcraft;

template ClassImpl(T)
if(is(T == class))
{
    // TODO : Determine this more reliably.
    static if(__traits(getProtection, T) == "public")
    {
        // In this context, use field-impl.
        template FieldMixin(T, string name)
        {
            alias FieldMixin = FieldImpl!(T, name);
        }

        // In this context, use method-impl.
        template MethodMixin(T, string name, size_t overload)
        {
            alias MethodMixin = MethodImpl!(T, name, overload);
        }

        // In this context, use constructor-impl.
        template ConstructorMixin(T, size_t overload)
        {
            alias ConstructorMixin = ConstructorImpl!(T, overload);
        }

        mixin WitchcraftClass;

        alias ClassImpl = ClassMixin!T;
    }
    else
    {
        class ClassImpl : Class
        {
            @property
            override Object create() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            const(Attribute)[] getAttributes() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            override const(Constructor)[] getConstructors() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            const(Type) getDeclaringType() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            const(TypeInfo) getDeclaringTypeInfo() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            override const(InterfaceType)[] getInterfaces() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            string getFullName() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
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
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            override const(TypeInfo) getSuperTypeInfo() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            const(TypeInfo) getTypeInfo() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            @property
            override bool isAbstract() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            @property
            override bool isFinal() const
            {
                assert(0, "Class " ~ T.stringof ~ " is inaccessible.");
            }

            @property
            final bool isAccessible() const
            {
                return false;
            }
        }
    }
}
