import std.stdio;
import witchcraft;
import std.variant;

void main() {
    Class c = User.metaof;
    // ... or new User().getMetaType;
    ClassAccessor accessor = new User();
    Class c2 = accessor.getMetaType;
    assert(c is c2);

    const(Attribute)[] attrs = c.getAttributes;
    writeln("\n=====iterate User's attributes ======");
    foreach (const(Attribute) attr; c.getAttributes) {
        writeln("===========");
        writeln("isType: ", attr.isType);
        writeln("isExpression: ", attr.isExpression);
        writeln(attr.toString());
        // writeln(attr.get!string());
    }

    assert(c.hasAttribute!(Table));

    // Create a new user object,
    User user = cast(User) c.create;

    testField(user, c);

    testMethod(user, c);

    testAbstract(user, c);

    testInterface(user, c);
}

void testField(User user, const Class c) {

    writeln("\n=====iterate over User's fields ======");
    // Iterate over fields . . .
    foreach (const Field field; c.getFields) {

        const Type valueType = field.getValueType();
        if (valueType !is null) {
            // FIXME: Needing refactor or cleanup -@zhangxueping at 4/17/2019, 2:57:00 PM
            // 
            writeln(valueType.toString());
        }

        // Get value on instance 'user'
        const(TypeInfo) valueInfo = field.getValueTypeInfo();
        writef("type: %s, ", valueInfo.toString());
        if (valueInfo == typeid(string))
            writefln("name: %s, value: %s", field.getName(), field.get!string(user));
        else if (valueInfo == typeid(int))
            writefln("name: %s, value: %d", field.getName(), field.get!int(user));
    }

    const Field ageField = c.getField("age");
    assert(ageField.get!int(user) == 20);
    ageField.set(user, 23);
    assert(ageField.get!int(user) == 23);
}

void testMethod(User user, const Class c) {

    writeln("\n=====iterate over User's methods ======");

    foreach (const Method method; c.getMethods()) {
        writeln(method.toString());
    }

    const Method privateMethod = c.getMethod("testPrivateMethod");
    assert(privateMethod !is null);

    const Method staticMethod = c.getLocalMethod("testStaticMethod");
    assert(staticMethod !is null);

    // const Method staticMethod2 = c.getMethod("testStaticMethod");
    // assert(staticMethod2 !is null);

    const Method getAgeMethod = c.getMethod("getAge");
    assert(getAgeMethod !is null);

    const Method setAgeMethod = c.getMethod!(int)("setAge");
    assert(setAgeMethod !is null);
    setAgeMethod.invoke(user, 21);
    assert(getAgeMethod.invoke!(int)(user) == 21);
}

void testAbstract(AbstractUser user, const Class c) {

    const Method getNameMethod = c.getMethod("getName");
    assert(getNameMethod !is null);
    writeln(getNameMethod.invoke!(string)(user));

    // const Method getAgeMethod = c.getMethod("getAge");
    // assert(getAgeMethod !is null);
}

void testInterface(IUser user, const Class c) {

    Variant va = Variant(user);
    writeln(va.type);
    // Object obj = va.get!(Object)(); // bug

    const Method getNameMethod = c.getMethod("getName");
    assert(getNameMethod !is null);
    writeln(getNameMethod.invoke!(string)(user)); // cast(Object)

    // const Method getAgeMethod = c.getMethod("getAge");
    // assert(getAgeMethod !is null);
}

interface IUser : ClassAccessor {
    string getName();
}

abstract class AbstractUser : IUser {
    mixin Witchcraft;
    abstract string getName();
}

@Annotation @Table("nothing")
@("string")
class User : AbstractUser {
    mixin Witchcraft;

    string username;
    string password;
    int age;

    private string male;

    this() {
        username = "noname";
        password = "123456";
        age = 20;
    }

    this(string username, string password) {
        this.username = username;
        this.password = password;
    }

    void setUserName(string name) {
        this.username = name;
    }

    override string getName() {
        return username;
    }

    int getAge() {
        return age;
    }

    void setAge(int age) {
        this.age = age;
    }

    private void testPrivateMethod() {

    }

    static void testStaticMethod() {

    }
}

interface Annotation {
}

struct Table {
    string name;
}

// import std.experimental.logger;
// tracef("interface size: %d", this_.base.interfaces.length);

// if(other !is null) {
//     tracef("xxxx=>T: %s, instance: %s", this_, other.toString());
// }
// else {
//     warningf("instance: %s, instance T: %s,", typeid(instance.type), this_.toString());
// }
