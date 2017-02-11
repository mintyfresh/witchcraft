
module witchcraft.unittests.structs;

version(unittest)
{
    import witchcraft;

    struct User
    {
        mixin Witchcraft;

        string username;
        string password;
    }
    
    void testSuite(C)(C metaObject){
        assert(metaObject.isAggregate == true);
        assert(metaObject.isClass     == false);
        assert(metaObject.isStruct    == true);

        assert(metaObject.getName     == "User");
        assert(metaObject.getFullName == "witchcraft.unittests.structs.User");
    }
}

unittest
{
    auto metaObjectByProperty = User.metaof;
    auto metaObjectByFunction = getMeta!User();

    assert(metaObjectByProperty !is null);
    assert(metaObjectByFunction !is null);
    
    testSuite(metaObjectByProperty);
    testSuite(metaObjectByFunction);
}
