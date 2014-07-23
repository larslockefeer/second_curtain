WORKSPACE = Demo/Demo.xcworkspace
SCHEME = Demo

all: ci

build:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -sdk iphonesimulator build | xcpretty -c

clean:
	xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) clean

test:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug test -sdk iphonesimulator | ./bin/upload-ios-snapshot-test-case | xcpretty -c --test

ci:	build