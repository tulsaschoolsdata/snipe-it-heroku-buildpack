SHELL = /bin/bash

default:

.tmp:
	mkdir -p .tmp/build .tmp/cache .tmp/env
.PHONY: .tmp

clean: clean-build clean-cache clean-env

clean-build:
	rm -Rf .tmp/build

clean-cache:
#	rm -Rf .tmp/cache

clean-env:
	rm -Rf .tmp/env

clean-test-compile-downloads:
	make clean-build
	make .tmp
	rm -Rf .tmp/cache/*.tar.gz

test: clean
	make .tmp
# NOTE: run test-compile-downloads so the rest of the tests already have the git repo
	make test-compile-downloads

test-compile-downloads:
	make test-compile-download-default
	make test-compile-download-branch
	make test-compile-download-tag
	make test-compile-download-sha
	make test-compile-download-version

test-compile-download-default:
	bin/compile .tmp/build .tmp/cache .tmp/env
	ls .tmp/cache/snipe-it-master.tar.gz
	ls .tmp/build | grep -q snipe-it
	rm -f .tmp/cache/snipe-it-master.tar.gz

test-compile-download-branch: clean-test-compile-downloads
	rm -f .tmp/cache/snipe-it-develop.tar.gz
	SNIPE_IT_URL=https://github.com/snipe/snipe-it#develop bin/compile .tmp/build .tmp/cache .tmp/env
	ls .tmp/cache/snipe-it-develop.tar.gz
	ls .tmp/build | grep -q snipe-it
	rm -f .tmp/cache/snipe-it-develop.tar.gz

test-compile-download-tag: clean-test-compile-downloads
	rm -f .tmp/cache/snipe-it-v5.1.5.tar.gz
	SNIPE_IT_URL=https://github.com/snipe/snipe-it#v5.1.5 bin/compile .tmp/build .tmp/cache .tmp/env
	ls .tmp/cache/snipe-it-v5.1.5.tar.gz
	ls .tmp/build | grep -q snipe-it
	rm -f .tmp/cache/snipe-it-v5.1.5.tar.gz

test-compile-download-sha: clean-test-compile-downloads
	rm -f .tmp/cache/snipe-it-01e3296ff.tar.gz
	SNIPE_IT_URL=https://github.com/snipe/snipe-it#01e3296ff bin/compile .tmp/build .tmp/cache .tmp/env
	ls .tmp/cache/snipe-it-01e3296ff.tar.gz
	ls .tmp/build | grep -q snipe-it
	rm -f .tmp/cache/snipe-it-01e3296ff.tar.gz

test-compile-download-version: clean-test-compile-downloads
	rm -f .tmp/cache/snipe-it-v5.1.5.tar.gz
	SNIPE_IT_VERSION=v5.1.5 bin/compile .tmp/build .tmp/cache .tmp/env
	ls .tmp/cache/snipe-it-v5.1.5.tar.gz
	ls .tmp/build | grep -q snipe-it
	rm -f .tmp/cache/snipe-it-v5.1.5.tar.gz

test-detect: .tmp
	bin/detect .tmp/build

test-compile: .tmp
	bin/compile .tmp/build .tmp/cache .tmp/env

test-release: .tmp
	bin/release .tmp/build
