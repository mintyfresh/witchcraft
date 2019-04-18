
import witchcraft;
import user;

import std.stdio;
import std.variant;

import std.experimental.logger;

void main() {
    Class c = User.metaof;
    // ... or new User().getMetaType;
    ClassAccessor accessor = new User();
    Class c2 = accessor.getMetaType;
    assert(c is c2);

    trace(c.toString());
    trace(c.getName());
    trace(c.getFullName());

    const(Attribute)[] attrs = c.getAttributes;
    writeln("\n=====iterate User's attributes ======");
    foreach (const(Attribute) attr; c.getAttributes) {
        writeln("===========");
        trace("isType: ", attr.isType);
        trace("isExpression: ", attr.isExpression);
        trace(attr.toString());
        // trace(attr.get!string());
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
            trace(valueType.toString());
        }

        // Get value on instance 'user'
        const(TypeInfo) valueInfo = field.getValueTypeInfo();
        writef("type: %s, ", valueInfo.toString());
        if (valueInfo == typeid(string))
            tracef("name: %s, value: %s", field.getName(), field.get!string(user));
        else if (valueInfo == typeid(int))
            tracef("name: %s, value: %d", field.getName(), field.get!int(user));
    }

    const Field ageField = c.getField("age");
    assert(ageField.get!int(user) == 20);
    ageField.set(user, 23);
    assert(ageField.get!int(user) == 23);
}

void testMethod(User user, const Class c) {

    writeln("\n=====iterate over User's methods ======");

    foreach (const Method method; c.getMethods()) {
        trace(method.toString());
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


    const Method setUserMethod = c.getMethod("setUser");
    assert(setUserMethod is null);
    // setUserMethod.invoke(user, "new name", 12);

    writeln("\n===== method overload ====");
    const(Method)[] setUserMethods = c.getMethods("setUser");
    assert(setUserMethods !is null);
    foreach(const Method m; setUserMethods) {
        writefln("\n===== %s ====", m.toString());

        const(Type)[] types = m.getParameterTypes();
        assert(types !is null);
        trace(types.length);
        foreach(const Type t; types) {
            // FIXME: Needing refactor or cleanup -@zhangxueping at 4/18/2019, 5:30:57 PM
            // 
            if(t !is null) // bug ?
                trace(t.toString());
        }

        const(TypeInfo)[] typeInfoes = m.getParameterTypeInfos();
        foreach(const TypeInfo t; typeInfoes) {
            if(t !is null)
                trace(t.toString());
        }

        if(typeInfoes[0] == typeid(string) && typeInfoes[1] == typeid(int)) {
            m.invoke(user, "new name", 22);
            assert(getAgeMethod.invoke!(int)(user) == 22);
        }
    }
}

void testAbstract(AbstractUser!(int) user, const Class c) {

    writeln("\n===== testAbstract ======");

    const Method getNameMethod = c.getMethod("getName");
    assert(getNameMethod !is null);
    trace(getNameMethod.invoke!(string)(user));

    // const Method getAgeMethod = c.getMethod("getAge");
    // assert(getAgeMethod !is null);
}

void testInterface(IUser user, const Class c) {

    writeln("\n===== testInterface ======");

    Variant va = Variant(user);
    trace(va.type);
    // Object obj = va.get!(Object)(); // bug

    const Method getNameMethod = c.getMethod("getName");
    assert(getNameMethod !is null);
    trace(getNameMethod.invoke!(string)(user)); // cast(Object)

    // const Method getAgeMethod = c.getMethod("getAge");
    // assert(getAgeMethod !is null);
}


// import std.experimental.logger;
// tracef("interface size: %d", this_.base.interfaces.length);

// if(other !is null) {
//     tracef("xxxx=>T: %s, instance: %s", this_, other.toString());
// }
// else {
//     warningf("instance: %s, instance T: %s,", typeid(instance.type), this_.toString());
// }
