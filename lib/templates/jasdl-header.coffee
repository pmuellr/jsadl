Modules         = {}
CurrentModule   = null
CurrentParam    = null
CurrentFunction = null
VoidType        = null

#-------------------------------------------------------------------------------
# functions used in jsadl files
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
aModule = (definition) ->
    [name, definition] = getSingleDefinition(definition)

    if name in Modules
        throw "module #{name} has already been defined"

    CurrentModule = new Module(name, definition)

    Modules[name] = CurrentModule

#-------------------------------------------------------------------------------
aFunction = (definition) ->
    [name, definition] = getSingleDefinition(definition)

    CurrentModule.addFunction(name, definition)

#-------------------------------------------------------------------------------
aShape = (definition) ->
    [name, definition] = getSingleDefinition(definition)

    CurrentModule.addShape(name, definition)

#-------------------------------------------------------------------------------
anInterface = (definition) ->
    [name, definition] = getSingleDefinition(definition)

    CurrentModule.addInterface(name, definition)

#-------------------------------------------------------------------------------
aClass = (definition) ->
    [name, definition] = getSingleDefinition(definition)

    CurrentModule.addClass(name, definition)

#-------------------------------------------------------------------------------
param = (name) ->
    if not CurrentFunction
        throw "param function called out of context for #{name}"

    CurrentFunction.params[CurrentParm].type = getType(name)
    CurrentParam++

#-------------------------------------------------------------------------------
# internal goop
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
getSingleDefinition = (definitions) ->
    result = null
    for name, defintion of definitions
        if result
            throw "too many definitions when processing #{name}"

    if not result
        throw "nothing defined"

    return result

#-------------------------------------------------------------------------------
getType = (name) ->
    new Type(name)

#-------------------------------------------------------------------------------
trimWhite = (string) ->
    string.
        replace(/^\s+/, '').
        replace(/\s+$/, '')

#-------------------------------------------------------------------------------
class Type

    #---------------------------------------------------------------------------
    constructor: (name) ->
        @baseName   = null
        @moduleName = null
        @fullName   = null
        @arity      = 0

        _parse(name)

    #---------------------------------------------------------------------------
    _parse: (name) ->
        @baseName = name
        @moduleName = CurrentModule.name

        if @moduleName is ""
            @fullName   = @baseName
        else
            @fullName   = "#{moduleName}.#{baseName}"

        @arity      = 0

    #---------------------------------------------------------------------------
    toString: ->
        name = ""
        if @moduleName is CurrentModule.name
            name = @baseName
        else if @moduleName is ""
            name = @baseName
        else
            name = @fullName

        for i in [0..arity]
            name += "[]"

#-------------------------------------------------------------------------------
class Module

    #---------------------------------------------------------------------------
    constructor: (@name) ->
        @functions  = {}
        @shapes     = {}
        @interfaces = {}
        @classes    = {}
        @exports    = {}
        @globals    = {}

    #---------------------------------------------------------------------------
    addFunction: (name, definition) ->
        null

    #---------------------------------------------------------------------------
    addShape: (name, definition) ->
        null

    #---------------------------------------------------------------------------
    addInterface: (name, definition) ->
        null

    #---------------------------------------------------------------------------
    addClass: (name, definition) ->
        null

#-------------------------------------------------------------------------------
class Shape

    #---------------------------------------------------------------------------
    constructor: (@name, properties) ->
        @properties = []

        for name, type of properties
            property = new Property(name, type)

            @properties.push property

#-------------------------------------------------------------------------------
class Class

    #---------------------------------------------------------------------------
    constructor: (@name, definition) ->
        @methods          = []
        @staticProperties = []
        @staticMethods    = []
        @properties       = []

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
class Function_

    #---------------------------------------------------------------------------
    constructor: (@name, func) ->
        @params  = @getParamsFromFunc(func)
        @getParamTypesFromFunc(func)

        CurrentFunction = @
        CurrentParam    = 0
        returnType = func.call()

        if returnType
            @returns = getType(returnType)
        else
            @returns = VoidType

    #---------------------------------------------------------------------------
    getParamsFromFunc: (func) ->
        funcString = func.toString()

        pattern = /\s*function\s*\((.*?)\)\s*{.*}\s*/
        match = pattern.match(funcString)
        if not match
            throw "invalid function definition: #{func}"

        params = match[1].split(',')
        params = new Param(trimWhite(param)) for param in params

        params

    #---------------------------------------------------------------------------
    toString: ->
        params = for param in @params
            "#{param.name}: #{param.type}"
        params = params.join(", ")
        return "#{@name}(#{params}): #{@returns}"

#-------------------------------------------------------------------------------
class Param

    #---------------------------------------------------------------------------
    constructor: (@name) ->
        @type = null

    #---------------------------------------------------------------------------
    toString: ->
        "#{@name}: #{type}"

#-------------------------------------------------------------------------------
class Method extends Function_

    #---------------------------------------------------------------------------
    isStatic: -> return false

#-------------------------------------------------------------------------------
class StaticMethod extends Method

    #---------------------------------------------------------------------------
    isStatic: -> return true

#-------------------------------------------------------------------------------
class Property

    #---------------------------------------------------------------------------
    constructor: (@name, @type) ->

    #---------------------------------------------------------------------------
    isStatic: -> return false

#-------------------------------------------------------------------------------
class StaticProperty extends Property

    #---------------------------------------------------------------------------
    isStatic: -> return true

#-------------------------------------------------------------------------------
# initialization
#-------------------------------------------------------------------------------

CurrentModule = new Module("")
VoidType      = new Type("void")
