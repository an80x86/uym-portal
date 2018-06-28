.PHONY: build help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: package.json ## install dependencies
	@yarn

run: build ## run the main
	@cd modules/main && REACT_APP_DATA_PROVIDER=rest yarn start

build: ## compile the main to static js
	@cd modules/main && REACT_APP_DATA_PROVIDER=rest yarn build

build-ra-core:
	@echo "Transpiling ra-core files...";
	@rm -rf ./packages/ra-core/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-core/src -d ./packages/ra-core/lib --ignore spec.js,test.js

build-ra-ui-materialui:
	@echo "Transpiling ra-ui-materialui files...";
	@rm -rf ./packages/ra-ui-materialui/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-ui-materialui/src -d ./packages/ra-ui-materialui/lib --ignore spec.js,test.js

build-react-admin:
	@echo "Transpiling react-admin files...";
	@rm -rf ./packages/react-admin/lib
	@rm -rf ./packages/react-admin/docs
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/react-admin/src -d ./packages/react-admin/lib --ignore spec.js,test.js

build-ra-data-json-server:
	@echo "Transpiling ra-data-json-server files...";
	@rm -rf ./packages/ra-data-json-server/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-data-json-server/src -d ./packages/ra-data-json-server/lib --ignore spec.js,test.js

build-ra-data-simple-rest:
	@echo "Transpiling ra-data-simple-rest files...";
	@rm -rf ./packages/ra-data-simple-rest/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-data-simple-rest/src -d ./packages/ra-data-simple-rest/lib --ignore spec.js,test.js

build-ra-data-graphql:
	@echo "Transpiling ra-data-graphql files...";
	@rm -rf ./packages/ra-data-graphql/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-data-graphql/src -d ./packages/ra-data-graphql/lib --ignore spec.js,test.js

build-ra-data-graphcool:
	@echo "Transpiling ra-data-graphcool files...";
	@rm -rf ./packages/ra-data-graphcool/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-data-graphcool/src -d ./packages/ra-data-graphcool/lib --ignore spec.js,test.js

build-ra-data-graphql-simple:
	@echo "Transpiling ra-data-graphql-simple files...";
	@rm -rf ./packages/ra-data-graphql-simple/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-data-graphql-simple/src -d ./packages/ra-data-graphql-simple/lib --ignore spec.js,test.js

build-ra-input-rich-text:
	@echo "Transpiling ra-input-rich-text files...";
	@rm -rf ./packages/ra-input-rich-text/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-input-rich-text/src -d ./packages/ra-input-rich-text/lib --ignore spec.js,test.js
	@cd packages/ra-input-rich-text/src && rsync -R `find . -name *.css` ../lib

build-ra-realtime:
	@echo "Transpiling ra-realtime files...";
	@rm -rf ./packages/ra-realtime/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./packages/ra-realtime/src -d ./packages/ra-realtime/lib --ignore spec.js,test.js

build-data-generator:
	@echo "Transpiling data-generator files...";
	@rm -rf ./modules/data-generator/lib
	@NODE_ENV=production ./node_modules/.bin/babel --quiet ./modules/data-generator/src -d ./modules/data-generator/lib

build: build-ra-core build-ra-ui-materialui build-react-admin build-ra-data-json-server build-ra-data-simple-rest build-ra-data-graphql build-ra-data-graphcool build-ra-data-graphql-simple build-ra-input-rich-text build-ra-realtime build-data-generator ## compile ES6 files to JS

watch: ## continuously compile ES6 files to JS
	@NODE_ENV=production ./node_modules/.bin/babel ./src -d lib --ignore spec.js,test.js --watch

doc: ## compile doc as html and launch doc web server
	@cd docs && jekyll server . --watch

lint: ## lint the code and check coding conventions
	@echo "Running linter..."
	@"./node_modules/.bin/eslint" ./packages/**/src

prettier: ## prettify the source code using prettier
	@./node_modules/.bin/prettier-eslint --write --list-different "packages/*/src/**/*.js" "modules/*/src/**/*.js"

test: build test-unit lint test-e2e ## launch all tests

test-unit: ## launch unit tests
	@if [ "$(CI)" != "true" ]; then \
		echo "Running unit tests..."; \
		NODE_ENV=test NODE_ICU_DATA=node_modules/full-icu ./node_modules/.bin/jest; \
	fi
	@if [ "$(CI)" = "true" ]; then \
		echo "Running unit tests in CI..."; \
		NODE_ENV=test NODE_ICU_DATA=node_modules/full-icu ./node_modules/.bin/jest --runInBand; \
	fi

test-unit-watch: ## launch unit tests and watch for changes
	@NODE_ENV=test NODE_ICU_DATA=node_modules/full-icu ./node_modules/.bin/jest --watch

test-e2e: ## launch end-to-end tests
	@if [ "$(build)" != "false" ]; then \
		echo 'Building example code (call "make build=false test-e2e" to skip the build)...'; \
		cd modules/simple && yarn build; \
	fi

	@NODE_ENV=test cd cypress && yarn test


test-e2e-local: ## launch end-to-end tests for development
	echo 'Starting e2e tests environment. Ensure you started the simple example first (make run-simple)'
	cd cypress && yarn start