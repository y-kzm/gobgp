#!/usr/bin/env bash
# stolen from prometheus
#
# Generate all protobuf bindings.
# Run from repository root.

set -x
set -e
set -u

if ! [[ "$0" =~ "tools/grpc/genproto.sh" ]]; then
	echo "must be run from repository root"
	exit 255
fi

if ! [[ $(protoc --version) =~ "25.6" ]]; then
	echo "could not find protoc 25.6, is it installed + in PATH?"
	exit 255
fi

echo "installing plugins"
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.5
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0

echo "generating code"
protoc -I api -I /usr/local/include \
       --go_out=api --go_opt=paths=source_relative --go-grpc_out=api --go-grpc_opt=paths=source_relative api/*.proto
