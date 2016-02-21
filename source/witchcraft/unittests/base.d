
module witchcraft.unittests.base;

import witchcraft;

import std.algorithm;
import std.array;

struct Entity
{
}

struct Column
{
    string name;
}

@Entity
class User
{
    mixin Witchcraft;

    @Column
    string username;

    @Column("pass_word")
    string password;

    string email;

    ulong createdAt;
    ulong updatedAt;
}

unittest
{
    assert(User.getClass !is null);
    auto class_ = User.getClass;

    assert(class_.getName     == "User");
    assert(class_.getFullName == "witchcraft.unittests.base.User");
    assert(class_.isAbstract  == false);
    assert(class_.isFinal     == false);

    assert(class_.getAttributes.empty        == false);
    assert(class_.getAttributes!Entity.empty == false);
    assert(class_.getAttributes!Column.empty == true);

    assert(class_.getAttributes!Entity[0].isType       == true);
    assert(class_.getAttributes!Entity[0].isExpression == false);

    assert(class_.getFieldNames.isPermutation([
        "username", "password", "email", "createdAt", "updatedAt"
    ]));

    assert(class_.getField("username") !is null);
    auto username = class_.getField("username");

    assert(username.getAttributes.empty        == false);
    assert(username.getAttributes!Entity.empty == true);
    assert(username.getAttributes!Column.empty == false);

    assert(username.getAttributes!Column[0].isType       == true);
    assert(username.getAttributes!Column[0].isExpression == false);

    assert(class_.getField("password") !is null);
    auto password = class_.getField("password");

    assert(password.getAttributes.empty        == false);
    assert(password.getAttributes!Entity.empty == true);
    assert(password.getAttributes!Column.empty == false);

    assert(password.getAttributes!Column[0].isType       == false);
    assert(password.getAttributes!Column[0].isExpression == true);

    assert(password.getAttributes!Column[0].get!Column.name == "pass_word");
}
