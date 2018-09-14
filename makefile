
.PHONY: all build plugins dep run

#export GOPATH=/path/to/github

ROOT_DIR = $(CURDIR)
VOLANTMQ_WORK_DIR = $(ROOT_DIR)
BIN_DIR = $(ROOT_DIR)/bin
VOLANTMQ_BUILD_FLAGS="-i"

all: build plugins

dep:
	go get -v github.com/ahmetb/govvv
	go get -v github.com/hongjundu/vlapi/...
	go get -v github.com/VolantMQ/volantmq

build:
	cd $(ROOT_DIR) && \
    govvv build $(VOLANTMQ_BUILD_FLAGS) -o $(BIN_DIR)/volantmq

plugins:
	cd $(GOPATH)/src/github.com/VolantMQ/vlapi/plugin/health && \
	go build $(VOLANTMQ_BUILD_FLAGS) -buildmode=plugin -o $(BIN_DIR)/plugins/health.so
	cd $(GOPATH)/src/github.com/hongjundu/vlapi/plugin/persistence/bbolt && \
	go build $(VOLANTMQ_BUILD_FLAGS) -buildmode=plugin -o $(BIN_DIR)/plugins/persistence_bbolt.so

run:
	cp -rf $(ROOT_DIR)/examples/config.yaml $(BIN_DIR)/
	export VOLANTMQ_PLUGINS_DIR=$(BIN_DIR)/plugins && \
	export VOLANTMQ_CONFIG=$(BIN_DIR)/config.yaml &&\
	$(BIN_DIR)/volantmq 


