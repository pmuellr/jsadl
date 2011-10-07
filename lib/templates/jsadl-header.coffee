#-------------------------------------------------------------------------------
# functions used in jsadl files
#-------------------------------------------------------------------------------

aModule     = null
aFunction   = null
aShape      = null
anInterface = null
aClass      = null
param       = null
getModules  = null

#-------------------------------------------------------------------------------
# hide the innards
#-------------------------------------------------------------------------------

do ->

    #---------------------------------------------------------------------------
    # module variables
    #---------------------------------------------------------------------------

    Modules         = {}
    CurrentModule   = null
    TypeVoid        = null

    #---------------------------------------------------------------------------
    # definitions of the functions
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    aModule = (definition) ->
        [name, definition] = getSingleDefinition(definition)

        if name in Modules
            throw "module #{name} has already been defined"

        CurrentModule = new Module(name, definition)

        Modules[name] = CurrentModule

    #---------------------------------------------------------------------------
    aFunction = (definition) ->
        [name, definition] = getSingleDefinition(definition)
        throw "function defined outside of module: #{name}" if not CurrentModule

        CurrentModule.addFunction(name, definition)

    #---------------------------------------------------------------------------
    aShape = (definition) ->
        [name, definition] = getSingleDefinition(definition)
        throw "shape defined outside of module: #{name}" if not CurrentModule

        CurrentModule.addShape(name, definition)

    #---------------------------------------------------------------------------
    anInterface = (definition) ->
        [name, definition] = getSingleDefinition(definition)
        throw "interface defined outside of module: #{name}" if not CurrentModule

        CurrentModule.addInterface(name, definition)

    #---------------------------------------------------------------------------
    aClass = (definition) ->
        [name, definition] = getSingleDefinition(definition)
        throw "class defined outside of module: #{name}" if not CurrentModule

        CurrentModule.addClass(name, definition)

    #---------------------------------------------------------------------------
    getModules = ->
        Modules

    #---------------------------------------------------------------------------
    # internal goop
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    getSingleDefinition = (definitions) ->
        result = null
        for name, definition of definitions
            if result
                throw "too many definitions when processing #{name}"
            result = [name, definition]

        if not result
            throw "nothing defined"

        return result

    #---------------------------------------------------------------------------
    getType = (name) ->
        new Type(name)

    #---------------------------------------------------------------------------
    trimWhite = (string) ->
        return string.
            replace(/^\s+/, '').
            replace(/\s+$/, '')

    #---------------------------------------------------------------------------
    class Type

        #-----------------------------------------------------------------------
        constructor: (name) ->
            @baseName   = null
            @moduleName = null
            @fullName   = null
            @arity      = 0

            @_parse(name)

        #-----------------------------------------------------------------------
        _parse: (name) ->
            wholeName = @_removeAndCountBrackets name

            @baseName = wholeName if wholeName in ["string", "number", "boolean", "function", "void"]

            if @baseName
                @moduleName = ""
            else
                [@moduleName, @baseName] = @_splitModuleBaseNames wholeName

            if @moduleName is ""
                @fullName   = @baseName
            else
                @fullName   = "#{@moduleName}.#{@baseName}"

        #-----------------------------------------------------------------------
        _removeAndCountBrackets: (name) ->
            pattern = /\s*(.*)([\[\]\s]*)\s*/
            match   = name.match(pattern)
            if not match
                throw "something should have matched for '#{name}'"

            wholeName = match[1]
            brackets  = match[2].split("")
            expecting = "["
            @arity    = 0
            for bracket in brackets
                continue if /\s/.test bracket

                if bracket == expecting
                    expecting = (bracket == "[" ? "]" : "[")
                else
                    throw "unbalanced brackets in #{name}"

                if bracket == "]"
                    @arity++

            if expecting == "]"
                throw "unbalanced brackets in #{name}"

            wholeName

        #-----------------------------------------------------------------------
        _splitModuleBaseNames: (name) ->
            pattern = /\s*(.*)\.([^\.]*)\s*/
            match   = name.match(pattern)
            if not match
                return [CurrentModule.name, name]

            [match[0], match[1]]

        #-----------------------------------------------------------------------
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

    #---------------------------------------------------------------------------
    class Module

        #-----------------------------------------------------------------------
        constructor: (@name, definition) ->
            @functions  = {}
            @shapes     = {}
            @interfaces = {}
            @classes    = {}
            @exports    = {}
            @global    = {}

            {@exports, @global} = definition

        #-----------------------------------------------------------------------
        addFunction: (name, definition) ->
            throw "function #{name} defined multiple times" if name in @functions

            @functions[name] = new Function_(name, definition)

        #-----------------------------------------------------------------------
        addShape: (name, definition) ->
            throw "shape #{name} defined multiple times" if name in @shapes

            @shapes[name] = new Shape(name, definition)

        #-----------------------------------------------------------------------
        addInterface: (name, definition) ->
            throw "interface #{name} defined multiple times" if name in @interfaces

            @interfaces[name] = new Interface(name, definition)

        #-----------------------------------------------------------------------
        addClass: (name, definition) ->
            throw "class #{name} defined multiple times" if name in @classes

            @classes[name] = new Class(name, definition)

    #---------------------------------------------------------------------------
    class Class

        #-----------------------------------------------------------------------
        constructor: (@name, definition) ->
            @implements       = []
            @staticProperties = {}
            @staticMethods    = {}
            @properties       = {}
            @methods          = {}
            @events           = {}

            for name, property of definition
                if name == "implements"
                    @implements.push(property)

                else if name == "staticProperties"
                else if name == "staticMethods"
                else if name == "properties"
                else if name == "methods"
                else if name == "events"
                else
                    throw "unknown key in class definition: '#{name}'"

    #---------------------------------------------------------------------------
    class Shape extends Class

        #-----------------------------------------------------------------------
        constructor: (@name, definition) ->
            super

    #---------------------------------------------------------------------------
    class Interface extends Class

        #-----------------------------------------------------------------------
        constructor: (@name, definition) ->
            super

    #---------------------------------------------------------------------------
    class Function_

        currentParam: 0

        #-----------------------------------------------------------------------
        constructor: (@name, func) ->
            @params = @getParamsFromFunc(func)

            returnType = func.call(this)
            delete @currentParam

            if returnType
                @returns = getType(returnType)
            else
                @returns = TypeVoid

        #---------------------------------------------------------------------------
        param: (name) ->
            @params[@currentParam].type = getType(name)
            @currentParam++

        #-----------------------------------------------------------------------
        getParamsFromFunc: (func) ->
            funcString = func.toString()

            pattern = /\((.*?)\)/
            match = funcString.match(pattern)
            if not match
                throw "invalid function definition: '#{func}'"

            params = trimWhite match[1]
            return [] if "" is params

            params = params.split(',')
            params = for param in params
                new Param(trimWhite(param))
            params

        #-----------------------------------------------------------------------
        toString: ->
            params = for param in @params
                "#{param.name}: #{param.type}"
            params = params.join(", ")
            return "#{@name}(#{params}): #{@returns}"

    #---------------------------------------------------------------------------
    class Param

        #-----------------------------------------------------------------------
        constructor: (@name) ->
            @type = null

        #-----------------------------------------------------------------------
        toString: ->
            "#{@name}: #{type}"

    #---------------------------------------------------------------------------
    class Method extends Function_

        #-----------------------------------------------------------------------
        isStatic: -> return false

    #---------------------------------------------------------------------------
    class StaticMethod extends Method

        #-----------------------------------------------------------------------
        isStatic: -> return true

    #---------------------------------------------------------------------------
    class Property

        #-----------------------------------------------------------------------
        constructor: (@name, @type) ->

        #-----------------------------------------------------------------------
        isStatic: -> return false

    #---------------------------------------------------------------------------
    class StaticProperty extends Property

        #-----------------------------------------------------------------------
        isStatic: -> return true

    #---------------------------------------------------------------------------
    # initialization
    #---------------------------------------------------------------------------

    TypeVoid = new Type("void")
