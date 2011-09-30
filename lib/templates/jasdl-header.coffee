Classes   = []
Callbacks = []

#-------------------------------------------------------------------------------
class Class
    constructor: (@name, properties) ->
        @properties       = []
        @methods          = []
        @staticProperties = []
        @staticMethods    = []

        for name, property of properties
            property.name = name

            if property.isMethod
                if property.isStatic
                    @staticMethods.push property
                else
                    @methods.push property
            else
                if property.isStatic
                    @staticProperties.push property
                else
                    @properties.push property

#-------------------------------------------------------------------------------
class FunctionDesc
    constructor: (@name, properties) ->
        @returns = "void"
        @parameters = []

        for name, type of properties
            if name is "returns"
                @result = type
            else
                @parameters.push [name, type]

    definitionString: ->
        parms = for parameter in @parameters
            "#{parameter[0]}: #{parameter[1]}"
        parms = parms.join(", ")
        return "#{@name}(#{parms}): #{@returns}"

#-------------------------------------------------------------------------------
class Method extends FunctionDesc
    constructor: (@name, properties) ->
        super
        @isStatic = false
    isMethod: true
    isProperty: false

#-------------------------------------------------------------------------------
class Property
    constructor: (@name, @type) ->
        @isStatic = false
    isMethod: false
    isProperty: true

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
aCallback = (name, properties) ->
    callback = new FunctionDesc(name, properties)
    Callbacks.push callback

#-------------------------------------------------------------------------------
aClass = (name, properties) ->
    cls = new Class(name, properties)
    Classes.push cls

#-------------------------------------------------------------------------------
aMethod = (properties) ->
    new Method(null, properties)

#-------------------------------------------------------------------------------
aStaticMethod = (properties) ->
    result = new Method(null, properties)
    result.isStatic = true
    result

#-------------------------------------------------------------------------------
aProperty = (type) ->
    new Property(null, type)

#-------------------------------------------------------------------------------
aStaticProperty = (type) ->
    result = new Property(null, type)
    result.isStatic = true
    result
