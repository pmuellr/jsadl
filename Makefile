#-------------------------------------------------------------------------------
# licensed under the MIT License:
#    http://www.opensource.org/licenses/mit-license.php
# Copyright (c) 2011, IBM Corporation
#-------------------------------------------------------------------------------

all: help

#-------------------------------------------------------------------------------
build:
	@echo TBD

#-------------------------------------------------------------------------------
test:
	@echo TBD

#-------------------------------------------------------------------------------
get-vendor:
	npm install coffee-script
	npm install optimist

#-------------------------------------------------------------------------------
clean:
	-rm -rf node_modules tmp build

#-------------------------------------------------------------------------------
help:
	@echo make targets available:
	@echo "  help  - print this help"
	@echo "  build - build the stuff"
	@echo "  test  - run the tests against the build"
	@echo "  clean - clear out old build stuff"
