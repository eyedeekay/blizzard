
REPO_NAME=blizzard
VERSION=0.0.035

plugins: clean index
	GOOS=windows GOARCH=amd64 make snowflake-plugin
	GOOS=linux GOARCH=amd64 make snowflake-plugin
	#GOOS=darwin GOARCH=amd64 make snowflake-plugin

clean:
	rm -frv proxy proxy.exe snowflake snowflake.exe blizzard blizzard.exe plugin snowflake-zip snowflake-zip-win *.su3 *.zip
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
		-command="snowflake -directory \$$PLUGIN/www -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT \
		-res=tmp/
	cp -v ../snowflake-$(GOOS).su3 .
	unzip -o snowflake-$(GOOS).zip -d snowflake-zip

res:
	mkdir -pv tmp/www
	mkdir -pv tmp/lib
	cp -v index.html home.css tmp/www/
	cp "$(HOME)/Workspace/GIT_WORK/i2p.i2p/build/shellservice.jar" tmp/lib/shellservice.jar

index:
	@echo "<!DOCTYPE html>" > index.html
	@echo "<html>" >> index.html
	@echo "<head>" >> index.html
	@echo "  <title>Blizzard, I2P Plugin for Donating a Snowflake</title>" >> index.html
	@echo "  <link rel=\"stylesheet\" type=\"text/css\" href =\"home.css\" />" >> index.html
	@echo "</head>" >> index.html
	@echo "<body>" >> index.html
	markdown README.md | tee -a index.html
	@echo '<div>Icons made by <a href="" title="itim2101">itim2101</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>' >> index.html
	@echo "</body>" >> index.html
	@echo "</html>" >> index.html

export sumsflinux=`sha256sum "../snowflake-linux.su3"`
export sumsfwindows=`sha256sum "../snowflake-windows.su3"`

upload-plugins:
	gothub upload -R -u eyedeekay -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinux)" -n "snowflake-linux.su3" -f "../snowflake-linux.su3"
	gothub upload -R -u eyedeekay -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindows)" -n "snowflake-windows.su3" -f "../snowflake-windows.su3"