
module witchcraft.mixins.base;

mixin template Witchcraft()
{
    import witchcraft;

    static if(is(typeof(this) == class))
    {
        private static Class __typeinfoext;
    }
    else static if(is(typeof(this) == struct))
    {
        private static Struct __typeinfoext;
    }
    else static if(is(typeof(this) == interface))
    {
        private static InterfaceType __typeinfoext;
    }
    else
    {
        static assert(0);
    }

    @property
    static typeof(__typeinfoext) classof()
    {
        mixin WitchcraftAttribute;
        mixin WitchcraftClass;
        mixin WitchcraftConstructor;
        mixin WitchcraftField;
        mixin WitchcraftMethod;
        mixin WitchcraftStruct;

        if(__typeinfoext is null)
        {
            static if(is(typeof(this) == class))
            {
                __typeinfoext = new ClassImpl!(typeof(this));
            }
            else static if(is(typeof(this) == struct))
            {
                __typeinfoext = new StructImpl!(typeof(this));
            }
            else static if(is(typeof(this) == interface))
            {
                __typeinfoext = new InterfaceTypeImpl!(typeof(this));
            }
            else
            {
                static assert(0);
            }
        }

        return __typeinfoext;
    }

    static if(__traits(compiles, typeof(super).classof))
    {
        override typeof(__typeinfoext) getClass()
        {
            return typeof(this).classof;
        }
    }
    else
    {
        typeof(__typeinfoext) getClass()
        {
            return typeof(this).classof;
        }
    }
}
