optimist      = require 'optimist'
fs            = require 'fs'
path          = require 'path'
coffee        = require 'coffee-script'

PROGRAM = path.basename __filename

OFile = null
IFiles  = []
Modules = {}

Header  = null
Trailer = null

#-------------------------------------------------------------------------------
exports.run = ->
    parseArgs()
    readTemplates()

    for iFile in IFiles
        console.log "processing file '#{iFile}'"
        processFile iFile

    Modules = JSON.stringify Modules, null, 4
    if not OFile
        console.log Modules
        return

    try
        fs.writeFileSync OFile, Modules
    catch e
        error "error writing file #{OFile}: #{e}"

#-------------------------------------------------------------------------------
exports.compile = (iFile) ->

    contents = readFile iFile

    try
        coffee.compile contents
    catch e
        error "coffee-script error in jsadl file #{iFile}: #{e}"

    contents = "#{Header}\n#{contents}\n#{Trailer}\n"

    js = null
    try
        js = coffee.compile contents
    catch e
        error "coffee-script error in templated jsadl file #{iFile}: #{e}"

    try
        result = eval(js)
    catch e
        if typeof(e) isnt "string"
            for own key, val of e
                console.log("exception.#{key}: #{val}")

        error "error eval'ing templated jsadl file #{iFile}: #{e}"

    result

#-------------------------------------------------------------------------------
processFile = (iFile) ->

    modules = exports.compile(iFile)

    for own name, definition of modules
        if name in Modules
            throw "module #{name} defined multiple modules"

        Modules[name] = definition

#-------------------------------------------------------------------------------
readTemplates = ->
    dirName = path.dirname __filename

    Header  = readFile path.join(dirName, "templates", "jsadl-header.coffee")
    Trailer = readFile path.join(dirName, "templates", "jsadl-trailer.coffee")

#-------------------------------------------------------------------------------
readFile = (fileName) ->
    try
        fs.readFileSync fileName, 'utf8'
    catch e
        error "error reading file #{fileName}: #{e}"

#-------------------------------------------------------------------------------
parseArgs = ->
    optimist.usage 'Usage: $0 -o [file] file file file ...'

    optimist.alias    'o', 'output'
    optimist.describe 'o', 'output JSON file'
    optimist.string   'o'

    argv = optimist.argv
    OFile  = argv['o']
    IFiles = argv['_']

    PROGRAM = path.basename argv['$0']

    if not IFiles.length
        help()
        process.exit 1

#-------------------------------------------------------------------------------
log = (message) ->
    console.log "#{PROGRAM}: #{message}"

#-------------------------------------------------------------------------------
error = (message) ->
    console.error "#{PROGRAM}: #{message}"
    process.exit 1

#-------------------------------------------------------------------------------
help = ->
    optimist.showHelp()
    console.error '''
Generates a JSON version of the IDL specified in the specified jsasdl files.
'''

