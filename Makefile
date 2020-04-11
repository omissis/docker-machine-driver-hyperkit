_PRJ_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

define run-docker
	@docker run -it --rm --network local_default --link pp_sql \
		-e GOOS=linux \
		-e GOARCH=amd64 \
		-e CGO_ENABLED=0 \
		-e GO111MODULE=on \
		-w /srv \
		-v ${_PRJ_DIR}:/srv \
		golang:1.14.2-alpine $1
endef

# Install Targets
.PHONY: install

install:
	@cp $(PWD)/build/docker-machine-driver-hyperkit /usr/local/bin/docker-machine-driver-hyperkit && \
	sudo chown root:wheel /usr/local/bin/docker-machine-driver-hyperkit && \
	sudo chmod u+s /usr/local/bin/docker-machine-driver-hyperkit

# Build Targets
.PHONY: clean vendor vendor-docker build build-docker

clean:
	@rm -rf build/*; \
	go clean -testcache

vendor:
	@go mod vendor

vendor-docker: --set-prj-dir-for-docker
	$(call run-docker,make vendor)

build: clean vendor
	@go build -o build/docker-machine-driver-hyperkit

build-docker: --set-prj-dir-for-docker
	$(call run-docker,make build)

# Code Quality Targets
.PHONY: fmt fmt-docker imports imports-docker cs cs-docker lint lint-docker

fmt:
	@find . -name '*.go' -type f -not -path '*/vendor/*' \
	| sed 's/^\.\///g' \
	| xargs -I {} bash -c 'echo "formatting {}.." && gofmt -w -s {}'

fmt-docker: --set-prj-dir-for-docker
	$(call run-docker,make fmt)

imports:
	@find . -name '*.go' -type f -not -path '*/vendor/*' \
	| sed 's/^\.\///g' \
	| xargs -I {} bash -c 'echo "fixing imports for {}.." && goimports -w {}'

imports-docker: --set-prj-dir-for-docker
	$(call run-docker,make imports)

cs: fmt imports

cs-docker: --set-prj-dir-for-docker
	$(call run-docker,make cs)

lint:
	@go get -u github.com/golangci/golangci-lint/cmd/golangci-lint && \
	go get -u golang.org/x/tools/cmd/goimports && \
	golangci-lint run --deadline=5m0s --out-format=line-number -exclude-use-default=false ./...

lint-docker: --set-prj-dir-for-docker
	$(call run-docker,make lint)

.PHONY: test test-docker

test:
	@go test -count 1 `go list ./... | grep -v /vendor/`

test-docker: --set-prj-dir-for-docker
	$(call run-docker,make test)

# Helpers
# Fix needed by macOS 10.15 Catalina
--set-prj-dir-for-docker:
ifeq ($(shell uname -s),Darwin)
ifeq ($(findstring 10.15,$(shell sw_vers -productVersion)),10.15)
	$(eval _PRJ_DIR=/System/Volumes/Data${_PRJ_DIR})
endif
endif
