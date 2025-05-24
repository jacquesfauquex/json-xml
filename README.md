# json-xml

- The functions json-to-xml() and xml-to-json() of xslt3 work perfectly.
- Json is the starting point.
- the xml result is a subset of xml defined by the schema https://www.w3.org/TR/xslt-30/#schema-for-json using the elements map, array, number, string, true, false, null and an attribute key when the element is part of a map.
- an xslt3 package version of the function xml-to-json is provided, for hacking
- no xslt of the function json-to-xml version is provided
- nonetheless, the saxon 11 processor cli syntax introduced a new option -json to transform by means of xslt an XDM parsing of the json document https://www.saxonica.com/html/documentation11/changes/v11/command-line.html
- XDM map, array, double, string and bolean types are disponible for xslt3 o xslt4 magic.
- JSON null is a special case, because it has no explicit representation in an array. for-each ignores it and it does not appear as a value in a map.
- We were able to detect it using the function not(exists())

## oas alternative
Alternative xml representation using elements object, array, string and the attributes key, and when necesary on string the attribute type
