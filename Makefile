GO111MODULE=on
REPO_NAME=blizzard
USER_GH=eyedeekay
VERSION=0.1.2
PWD=`pwd`
GO=`which go`
CGO_ENABLED=0
ARG=-v -tags netgo,osusergo -ldflags '-w -s -extldflags "-static"'

all: plugins winplugin linplugin

plugins: index
	rm congig.yaml plugin.yaml -f

winplugin: plugins
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ make windows blizzard-plugin

linplugin: plugins
	GOOS=linux GOARCH=amd64 make linux blizzard-plugin

clean:
	git clean -fdx
	find . -name '*.go' -exec gofumpt -w -s {} \;

blizzard:
	$(GO) build $(ARG) -o blizzard-$(GOOS)

windows:
	GOOS=windows make blizzard

linux:
	GOOS=linux make blizzard

docker:
	docker build -t $(USER_GH)/$(REPO_NAME):$(VERSION) .
	docker run -it -v $(PWD):/home/user/go/src/i2pgit.org/idk/$(REPO_NAME) $(USER_GH)/$(REPO_NAME):$(VERSION)

alpine:
	docker build -f Dockerfile.alpine -t $(USER_GH)/$(REPO_NAME):$(VERSION) .
	docker run -it -v $(PWD):/home/user/go/src/i2pgit.org/idk/$(REPO_NAME) $(USER_GH)/$(REPO_NAME):$(VERSION)

SIGNER_DIR=$(HOME)/i2p-go-keys/

blizzard-plugin: res
	i2p.plugin.native -name=blizzard \
		-signer=idki2p@mail.i2p \
		-signer-dir=$(SIGNER_DIR) \
		-version="$(VERSION)" \
		-author=idki2p@mail.i2p \
		-autostart=true \
		-clientname=blizzard \
		-consolename="Snowflake Donor" \
		-consoleurl="http://127.0.0.1:7676" \
		-icondata="icon/icon.png" \
		-delaystart="1" \
		-desc="`cat snowdesc`" \
		-exename=blizzard-$(GOOS) \
		-website="http://idk.i2p/blizzard/" \
		-updateurl=http://idk.i2p/blizzard/blizzard-$(GOOS).su3 \
		-command="blizzard-$(GOOS) -directory \$$PLUGIN/www -log \$$PLUGIN/lib/blizzard.log" \
		-license=MIT \
		-res=tmp/
	cp blizzard.su3 blizzard-$(GOOS).su3
	unzip -o blizzard.zip -d blizzard-$(GOOS)-zip

res:
	mkdir -pv tmp/www
	mkdir -pv tmp/lib
	cp LICENSE.md tmp/LICENSE
	cp -v index.html home.css tmp/www/
#	cp "$(HOME)/build/shellservice.jar" tmp/lib/shellservice.jar

index:
	@echo "<!DOCTYPE html>" > index.html
	@echo "<html>" >> index.html
	@echo "<head>" >> index.html
	@echo "  <title>$(REPO_NAME), I2P Plugin for Donating a Snowflake</title>" >> index.html
	@echo "  <link rel=\"stylesheet\" type=\"text/css\" href =\"home.css\" />" >> index.html
	@echo "</head>" >> index.html
	@echo "<body>" >> index.html
	markdown README.md | tee -a index.html
	@echo "</body>" >> index.html
	@echo "</html>" >> index.html

export sumsflinux=`sha256sum "./blizzard-linux.su3"`
export sumsfwindows=`sha256sum "./blizzard-windows.su3"`
export sumsflinuxbin=`sha256sum "./blizzard-linux"`
export sumsfwindowsbin=`sha256sum "./blizzard-windows"`

release: all version upload-plugins

version:
	cat README.md | github-release release -s $(GITHUB_TOKEN) -u $(USER_GH) -r $(REPO_NAME) -t v$(VERSION) -d -; true
	sleep 2s

download-su3s:

upload-su3s: upload-plugins

upload-plugins:
	github-release upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinux)" -n "blizzard-linux.su3" -f "./blizzard-linux.su3"
	github-release upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindows)" -n "blizzard-windows.su3" -f "./blizzard-windows.su3"
	github-release upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindowsbin)" -n "blizzard-windows.exe" -f "./blizzard-windows"
	github-release upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinuxbin)" -n "blizzard-linux" -f "./blizzard-linux"


sign:
	rm -rf blizzard.zip blizzard.su3
	cd plugin && zip -r ../blizzard.zip . && cd ..
	`which i2p` SU3File sign -c PLUGIN -t RSA_SHA512_4096 blizzard.zip blizzard.su3 ${HOME}/.i2p-plugin-keys/news-su3-keystore.ks ${VERSION} idki2p@mail.i2p