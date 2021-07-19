
plugins: clean snowflake-plugin-win snowflake-plugin

clean:
	rm -frv proxy proxy.exe snowflake snowflake.exe blizzard blizzard.exe plugin snowflake-zip snowflake-zip-win
	find . -name '*.go' -exec gofmt -w -s {} \;

snowflake-win:
	GOOS=windows go build -o snowflake.exe

snowflake-plugin-win: snowflake-win
	i2p.plugin.native -name=snowflake \
		-signer=hankhill19580@gmail.com \
		-version 0.0.031 \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=snowflake.exe \
		-consolename="Snowflake Donor" \
		-delaystart="1" \
		-desc="`cat snowdesc)`" \
		-exename=snowflake.exe \
		-command="\$$PLUGIN/lib/snowflake.exe -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT \
		-targetos="windows"
	cp -v *.su3 ../snowflake-windows.su3
	unzip -o snowflake.zip -d snowflake-zip-win

snowflake-lin:
	GOOS=windows go build -o snowflake

snowflake-plugin: snowflake-lin
	i2p.plugin.native -name=snowflake \
		-signer=hankhill19580@gmail.com \
		-version 0.0.031 \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=snowflake \
		-consolename="Snowflake Donor" \
		-delaystart="1" \
		-desc="`cat snowdesc)`" \
		-exename=snowflake \
		-command="\$$PLUGIN/lib/snowflake -log \$$PLUGIN/lib/snowflake.log" \
		-license=MIT
	cp -v *.su3 ../snowflake-linux.su3
	unzip -o snowflake.zip -d snowflake-zip