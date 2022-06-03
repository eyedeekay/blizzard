GO111MODULE=on
REPO_NAME=blizzard
USER_GH=eyedeekay
VERSION=0.0.46
PWD=`pwd`

ARG=-v -tags netgo,osusergo -ldflags '-w -s'
#ARG=-v -tags netgo,osusergo -ldflags '-w -s -extldflags "-static"'

all: plugins winplugin linplugin

plugins: clean index

winplugin: plugins
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ make windows snowflake-plugin

linplugin: plugins
	GOOS=linux GOARCH=amd64 make snowflake snowflake-plugin

#	#GOOS=darwin GOARCH=amd64 make snowflake-plugin

clean:
	rm -frv proxy proxy.exe snowflake snowflake.exe snowflake-windows snowflake-windows.exe $(REPO_NAME) $(REPO_NAME).exe plugin snowflake-zip snowflake-zip-win *.su3 *.zip
	find . -name '*.go' -exec gofmt -w -s {} \;

snowflake:
	go build $(ARG) -o snowflake-$(GOOS)

rb:
	/usr/lib/go-1.15/bin/go build $(ARG) -o snowflake-$(GOOS)

windows:
	xgo --targets=windows/amd64 . && cp i2pgit.org/idk/blizzard-windows-4.0-amd64.exe snowflake-windows.exe
	cp snowflake-windows.exe snowflake-windows

docker:
	docker build -t $(USER_GH)/$(REPO_NAME):$(VERSION) .
	docker run -it -v $(PWD):/home/user/go/src/i2pgit.org/idk/$(REPO_NAME) $(USER_GH)/$(REPO_NAME):$(VERSION)

alpine:
	docker build -f Dockerfile.alpine -t $(USER_GH)/$(REPO_NAME):$(VERSION) .
	docker run -it -v $(PWD):/home/user/go/src/i2pgit.org/idk/$(REPO_NAME) $(USER_GH)/$(REPO_NAME):$(VERSION)

SIGNER_DIR=$(HOME)/i2p-go-keys/

snowflake-plugin: res
	i2p.plugin.native -name=snowflake-$(GOOS) \
		-signer=hankhill19580@gmail.com \
		-signer-dir=$(SIGNER_DIR) \
		-version="$(VERSION)" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=snowflake-$(GOOS) \
		-consolename="Snowflake Donor" \
		-consoleurl="http://127.0.0.1:7676" \
		-icondata="icon/icon.png" \
		-delaystart="1" \
		-desc="`cat snowdesc`" \
		-exename=snowflake-$(GOOS) \
		-website="http://idk.i2p/blizzard/" \
		-updateurl=http://idk.i2p/blizzard/snowflake-$(GOOS).su3 \
		-command="snowflake-$(GOOS) -directory \$$PLUGIN/www -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT \
		-res=tmp/
	unzip -o snowflake-$(GOOS).zip -d snowflake-$(GOOS)-zip

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

export sumsflinux=`sha256sum "./snowflake-linux.su3"`
export sumsfwindows=`sha256sum "./snowflake-windows.su3"`
export sumsflinuxbin=`sha256sum "./snowflake-linux"`
export sumsfwindowsbin=`sha256sum "./snowflake-windows.exe"`

release: all version upload-plugins

version:
	cat README.md | gothub release -s $(GITHUB_TOKEN) -u $(USER_GH) -r $(REPO_NAME) -t v$(VERSION) -d -; true

download-su3s:
	GOOS=windows GOARCH=amd64 make download-single-su3
	GOOS=linux GOARCH=amd64 make download-single-su3

download-single-su3:
	wget-ds "https://github.com/$(USER_GH)/$(REPO_NAME)/releases/download/v$(VERSION)/snowflake-$(GOOS).su3"

upload-su3s: upload-plugins

upload-plugins:
	gothub upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinux)" -n "snowflake-linux.su3" -f "./snowflake-linux.su3"
	gothub upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindows)" -n "snowflake-windows.su3" -f "./snowflake-windows.su3"
	gothub upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindowsbin)" -n "snowflake-windows.exe" -f "./snowflake-windows.exe"
	gothub upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinuxbin)" -n "snowflake-linux" -f "./snowflake-windows"
