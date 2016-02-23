
module witchcraft.unittests.inheritance;

import witchcraft;

version(unittest)
{
    abstract class Entity
    {
        mixin Witchcraft;

        ulong id;
    }

    class User : Entity
    {
        mixin Witchcraft;

        string username;
        string password;
    }

    final class Admin : User
    {
        mixin Witchcraft;

        bool canBan;
        bool canEdit;
        bool canMute;
    }
}

unittest
{
    import std.algorithm;

    Class eClass = Entity.classof;
    Class uClass = User.classof;
    Class aClass = Admin.classof;

    assert(eClass !is null && uClass !is null && aClass !is null);

    assert(eClass.getName == "Entity");
    assert(uClass.getName == "User");
    assert(aClass.getName == "Admin");

    assert(eClass.isAbstract == true);
    assert(uClass.isAbstract == false);
    assert(aClass.isAbstract == false);

    assert(eClass.isFinal == false);
    assert(uClass.isFinal == false);
    assert(aClass.isFinal == true);

    enum eFields = [ "id" ];
    enum uFields = [ "username", "password" ];
    enum aFields = [ "canBan", "canEdit", "canMute" ];

    assert(eClass.getLocalFieldNames.isPermutation(eFields));
    assert(uClass.getLocalFieldNames.isPermutation(uFields));
    assert(aClass.getLocalFieldNames.isPermutation(aFields));

    assert(eClass.getFieldNames.isPermutation(eFields));
    assert(uClass.getFieldNames.isPermutation(eFields ~ uFields));
    assert(aClass.getFieldNames.isPermutation(eFields ~ uFields ~ aFields));
}

unittest
{
    Entity u = new User;
    Entity a = new Admin;

    Class eClass = Entity.classof;
    Class uClass = u.getClass;
    Class aClass = a.getClass;

    assert(eClass !is null && uClass !is null && aClass !is null);

    assert(eClass.getName == "Entity");
    assert(uClass.getName == "User");
    assert(aClass.getName == "Admin");

    version(aggressive)
    {
        assert(eClass.getSuperClass !is null);
        assert(eClass.getSuperClass.getName == "Object");
    }
    else
    {
        assert(eClass.getSuperClass is null);
    }

    assert(uClass.getSuperClass is eClass);
    assert(aClass.getSuperClass is uClass);

    assert(eClass.getField("id") !is null);
    assert(uClass.getField("id") !is null);
    assert(aClass.getField("id") !is null);

    assert(eClass.getField("username")  is null);
    assert(uClass.getField("username") !is null);
    assert(aClass.getField("username") !is null);

    assert(eClass.getField("canEdit")  is null);
    assert(uClass.getField("canEdit")  is null);
    assert(aClass.getField("canEdit") !is null);
}
