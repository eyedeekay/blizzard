
REPO_NAME=blizzard
USER_GH=eyedeekay
VERSION=0.0.035

plugins: clean index
	GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ GOOS=windows GOARCH=amd64 make snowflake-plugin
	GOOS=linux GOARCH=amd64 make snowflake-plugin
	#GOOS=darwin GOARCH=amd64 make snowflake-plugin

clean:
	rm -frv proxy proxy.exe snowflake snowflake.exe $(REPO_NAME) $(REPO_NAME).exe plugin snowflake-zip snowflake-zip-win *.su3 *.zip
	find . -name '*.go' -exec gofmt -w -s {} \;

snowflake:
	go build -ldflags "-s -w" -o snowflake-$(GOOS)

snowflake-plugin: snowflake res
	i2p.plugin.native -name=snowflake-$(GOOS) \
		-signer=hankhill19580@gmail.com \
		-version "$(VERSION)" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=snowflake-$(GOOS) \
		-consolename="Snowflake Donor" \
		-consoleurl="http://127.0.0.1:7672" \
		-icondata="icon/icon.png" \
		-delaystart="1" \
		-desc="`cat snowdesc)`" \
		-exename=snowflake-$(GOOS) \
		-command="snowflake-$(GOOS) -directory \$$PLUGIN/www -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT \
		-res=tmp/
	cp -v ../snowflake-$(GOOS).su3 .
	unzip -o snowflake-$(GOOS).zip -d snowflake-$(GOOS)-zip

res:
	mkdir -pv tmp/www
	mkdir -pv tmp/lib
	cp -v index.html home.css tmp/www/
	cp "$(HOME)/Workspace/GIT_WORK/i2p.i2p/build/shellservice.jar" tmp/lib/shellservice.jar

index:
	@echo "<!DOCTYPE html>" > index.html
	@echo "<html>" >> index.html
	@echo "<head>" >> index.html
	@echo "  <title>$(REPO_NAME), I2P Plugin for Donating a Snowflake</title>" >> index.html
	@echo "  <link rel=\"stylesheet\" type=\"text/css\" href =\"home.css\" />" >> index.html
	@echo "</head>" >> index.html
	@echo "<body>" >> index.html
	markdown README.md | tee -a index.html
	@echo '<div>Icons made by <a href="" title="itim2101">itim2101</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>' >> index.html
	@echo "</body>" >> index.html
	@echo "</html>" >> index.html

export sumsflinux=`sha256sum "../snowflake-linux.su3"`
export sumsfwindows=`sha256sum "../snowflake-windows.su3"`

release: version upload-plugins

version:
	cat README.md | gothub release -s $(GITHUB_TOKEN) -u $(USER_GH) -r $(REPO_NAME) -t v$(VERSION) -d -

download-su3s:
	GOOS=windows GOARCH=amd64 make download-single-su3
	GOOS=linux GOARCH=amd64 make download-single-su3

download-single-su3:
	wget -N -c "https://github.com/$(USER_GH)/$(REPO_NAME)/releases/download/v$(VERSION)/snowflake-$(GOOS).su3"

upload-su3s: upload-plugins

upload-plugins:
	gothub upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinux)" -n "snowflake-linux.su3" -f "../snowflake-linux.su3"
	gothub upload -R -u $(USER_GH) -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindows)" -n "snowflake-windows.su3" -f "../snowflake-windows.su3"