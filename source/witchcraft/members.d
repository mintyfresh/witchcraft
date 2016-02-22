
module witchcraft.members;

import witchcraft;

import std.algorithm;
import std.array;

/++
 + Represents a set of behaviours common to reflective elements.
 ++/
interface Member
{
    /++
     + Returns an array of attributes that are attached to this element.
     +
     + Returns:
     +   An array of attributes.
     ++/
    @property
    const(Attribute)[] getAttributes() const;

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
    @property
    final const(Attribute)[] getAttributes(TypeInfo type) const
    {
        return getAttributes.filter!(a => a.getType == type).array;
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
    @property
    final const(Attribute)[] getAttributes(T)() const
    {
        return getAttributes(typeid(T));
    }

    /++
     + The name of the element.
     +
     + Returns:
     +   The name of the element.
     ++/
    @property
    string getName() const;

    /++
     + Returns the class that encapsulates this one. Null is returned if this
     + is the topmost element, or if the outer class lacks reflective meta
     + information.
     +
     + Returns:
     +   The parent element's class.
     ++/
    @property
    const(Class) getParentClass() const;

    /++
     + Returns a `TypeInfo` object for the parent element.
     +
     + Returns:
     +   The type of the parent element.
     +
     + See_Also:
     +   getParentClass
     ++/
    @property
    const(TypeInfo) getParentType() const;

    /++
     + Returns a string that represents this element's declared protection.
     +
     + Returns:
     +   This element's protection.
     ++/
    @property
    string getProtection() const;
}
