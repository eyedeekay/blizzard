
REPO_NAME=blizzard
VERSION=0.0.035

plugins: clean index snowflake-plugin-win snowflake-plugin

clean:
	rm -frv proxy proxy.exe snowflake snowflake.exe blizzard blizzard.exe plugin snowflake-zip snowflake-zip-win *.su3 *.zip
	find . -name '*.go' -exec gofmt -w -s {} \;

snowflake-win:
	GOOS=windows go build -o snowflake.exe

snowflake-plugin-win: snowflake-win res
	i2p.plugin.native -name=snowflake \
		-signer=hankhill19580@gmail.com \
		-version "$(VERSION)" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=snowflake.exe \
		-consolename="Snowflake Donor" \
		-consoleurl="http://127.0.0.1:7672" \
		-icondata="icon/icon.png" \
		-delaystart="1" \
		-desc="`cat snowdesc)`" \
		-exename=snowflake.exe \
		-command="snowflake.exe -directory \$$PLUGIN/www -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT \
		-targetos="windows" \
		-res=tmp/
	cp -v snowflake.su3 ../snowflake-windows.su3
	cp -v ../snowflake-windows.su3 .
	unzip -o snowflake.zip -d snowflake-zip-win

snowflake-lin:
	GOOS=linux go build -o snowflake

snowflake-plugin: snowflake-lin res
	i2p.plugin.native -name=snowflake \
		-signer=hankhill19580@gmail.com \
		-version "$(VERSION)" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=snowflake \
		-consolename="Snowflake Donor" \
		-consoleurl="http://127.0.0.1:7672" \
		-icondata="icon/icon.png" \
		-delaystart="1" \
		-desc="`cat snowdesc)`" \
		-exename=snowflake \
		-command="snowflake -directory \$$PLUGIN/www -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT \
		-res=tmp/
	cp -v snowflake.su3 ../snowflake-linux.su3
	cp -v ../snowflake-linux.su3 .
	unzip -o snowflake.zip -d snowflake-zip

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
	@echo '<div>Icons made by <a href="" title="itim2101">itim2101</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>' >> README.md
	@echo "</body>" >> index.html
	@echo "</html>" >> index.html

export sumsflinux=`sha256sum "../snowflake-linux.su3"`
export sumsfwindows=`sha256sum "../snowflake-windows.su3"`

upload-plugins:
	gothub upload -R -u eyedeekay -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsflinux)" -n "snowflake-linux.su3" -f "../snowflake-linux.su3"
	gothub upload -R -u eyedeekay -r "$(REPO_NAME)" -t v$(VERSION) -l "$(sumsfwindows)" -n "snowflake-windows.su3" -f "../snowflake-windows.su3"