
module witchcraft.mixins.base;

mixin template Witchcraft()
{
    import witchcraft;

    private static Class __classinfoext;

    @property
    static Class classof()
    {
        mixin WitchcraftClass;
        mixin WitchcraftAttribute;
        mixin WitchcraftField;
        mixin WitchcraftMethod;
        mixin WitchcraftConstructor;

        if(__classinfoext is null)
        {
            __classinfoext = new ClassImpl!(typeof(this));
        }

        return __classinfoext;
    }

    static if(__traits(hasMember, typeof(super), "getClass"))
    {
        override Class getClass()
        {
            return typeof(this).classof;
        }
    }
    else
    {
        Class getClass()
        {
            return typeof(this).classof;
        }
    }
}
