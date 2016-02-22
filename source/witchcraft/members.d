
module witchcraft.members;

import witchcraft;

import std.algorithm;
import std.array;

/++
 + Represents a set of behaviours common to reflective elements.
 ++/
abstract class Member
{
    /++
     + Returns an array of attributes that are attached to this element.
     +
     + Returns:
     +   An array of attributes.
     ++/
    abstract const(Attribute)[] getAttributes() const;

    /++
     + Returns an array of attributes of the given class that are attched to
     + this element. If no such attributes exist, an empty array is returned.
     +
     + Params:
     +   class_ = The class of attribute to filter by.
     +
     + Returns:
     +   An array of attributes.
     ++/
    final const(Attribute)[] getAttributes(Class class_) const
    {
        return getAttributes
            .filter!(a => a.getAttributeClass == class_)
            .array;
    }

    /++
     + Returns an array of attributes of the given type that are attched to
     + this element. If no such attributes exist, an empty array is returned.
     +
     + Params:
     +   type = The type of attribute to filter by.
     +
     + Returns:
     +   An array of attributes.
     ++/
    final const(Attribute)[] getAttributes(TypeInfo type) const
    {
        return getAttributes
            .filter!(a => a.getAttributeType == type)
            .array;
    }

    /++
     + Ditto, but the type is given by template parameter.
     +
     + Params:
     +   T = The type of attribute to filter by.
     +
     + Returns:
     +   An array of attributes.
     ++/
    final const(Attribute)[] getAttributes(T)() const
    {
        return getAttributes(typeid(T));
    }

    /++
     + Returns the class that encapsulates this one. Null is returned if this
     + is the topmost element, or if the outer class lacks reflective meta
     + information.
     +
     + Returns:
     +   The declaring element's class.
     ++/
    @property
    abstract const(Class) getDeclaringClass() const;

    /++
     + Returns a `TypeInfo` object for the declaring element.
     +
     + Returns:
     +   The type of the declaring element.
     +
     + See_Also:
     +   getDeclaringClass
     ++/
    @property
    abstract const(TypeInfo) getDeclaringType() const;

    /++
     + The name of the element.
     +
     + Returns:
     +   The name of the element.
     ++/
    @property
    abstract string getName() const;

    /++
     + Returns a string that represents this element's declared protection.
     +
     + Returns:
     +   This element's protection.
     ++/
    @property
    abstract string getProtection() const;
}
