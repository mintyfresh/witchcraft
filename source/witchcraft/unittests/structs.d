
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
}

unittest
{
    auto uClass = User.classof;

    assert(uClass !is null);

    assert(uClass.isAggregate == true);
    assert(uClass.isClass     == false);
    assert(uClass.isStruct    == true);

    assert(uClass.getName     == "User");
    assert(uClass.getFullName == "witchcraft.unittests.structs.User");
}
