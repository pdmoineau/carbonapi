UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	PKGCONF = PKG_CONFIG_PATH="/opt/X11/lib/pkgconfig"
else
	PKGCONF =
endif

GO ?= go
VERSION ?= $(shell git rev-parse --short HEAD)

PKG_CARBONAPI=github.com/bookingcom/carbonapi/cmd/carbonapi
PKG_CARBONZIPPER=github.com/bookingcom/carbonapi/cmd/carbonzipper

GCFLAGS :=
debug: GCFLAGS += -gcflags=all='-l -N'

LDFLAGS = -ldflags '-X main.BuildVersion=$(VERSION)'

GOOS = linux
GOARCH = arm64

TAGS := -tags cairo
nocairo: TAGS =

### Targets ###

all: build

nocairo: build

.PHONY: debug
debug: build

build:
	GOOS=$(GOOS) GOARCH=$(GOARCH) $(PKGCONF) $(GO) build -mod vendor $(TAGS) $(LDFLAGS) $(GCFLAGS) $(PKG_CARBONAPI)
	GOOS=$(GOOS) GOARCH=$(GOARCH) $(PKGCONF) $(GO) build -mod vendor $(TAGS) $(LDFLAGS) $(GCFLAGS) $(PKG_CARBONZIPPER)

lint:
	golangci-lint run

test:
	$(PKGCONF) $(GO) test ./... -race -coverprofile=coverage.txt -covermode=atomic

clean:
	rm -f carbonapi carbonzipper

authors:
	git log --format="%an" | sort | uniq > AUTHORS.txt
