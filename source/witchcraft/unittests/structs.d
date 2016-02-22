
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
    Type uClass = User.classof;

    assert(uClass !is null);

    assert(uClass.getName     == "User");
    assert(uClass.getFullName == "witchcraft.unittests.structs.User");
}
