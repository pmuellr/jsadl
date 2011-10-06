optimist      = require 'optimist'
fs            = require 'fs'
path          = require 'path'

PROGRAM = path.basename __filename

OFile = null
IFiles  = []
Result  =
    classes:   []
    callbacks: []

Header  = null
Trailer = null

#-------------------------------------------------------------------------------
exports.run = ->
    parseArgs()
    readTemplates()

    for iFile in IFiles
        processFile iFile

    Result = JSON.stringify Result, null, 4
    if not OFile
        console.log Result
        return

    try
        fs.writeFileSync OFile, Result
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
        error "error eval'ing templated jsadl file #{iFile}: #{e}"

    result

#-------------------------------------------------------------------------------
processFile = (iFile) ->

    result = exports.compile(iFile)

    Result.classes   = Result.classes.concat   result.classes
    Result.callbacks = Result.callbacks.concat result.callbacks

#-------------------------------------------------------------------------------
readTemplates = ->
    dirName = path.dirname __filename

    Header  = readFile path.join(dirName, "templates", "jasdl-header.coffee")
    Trailer = readFile path.join(dirName, "templates", "jasdl-trailer.coffee")

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

