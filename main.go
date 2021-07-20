package main

import (
	"flag"

	"log"
	"os"

	"github.com/getlantern/systray"
	"i2pgit.org/idk/blizzard/icon"
	"i2pgit.org/idk/blizzard/lib"
)

func main() {

	flags := make(map[string]*string)
	flags["capacity"] = flag.String("capacity", "10", "maximum concurrent clients")
	flags["stunURL"] = flag.String("stun", snowflake.DefaultSTUNURL, "broker URL")
	flags["logFilename"] = flag.String("log", "", "log filename")
	flags["rawBrokerURL"] = flag.String("broker", snowflake.DefaultBrokerURL, "broker URL")
	flags["unsafeLogging"] = flag.String("unsafe-logging", "false", "prevent logs from being scrubbed")
	flags["keepLocalAddresses"] = flag.String("keep-local-addresses", "false", "keep local LAN address ICE candidates")
	flags["relayURL"] = flag.String("relay", snowflake.DefaultRelayURL, "websocket relay URL")

	flag.Parse()
	go snowflake.Main(flags)
	systray.Run(onReady, onExit)
}

func onReady() {
	systray.SetIcon(icon.Data)
	systray.SetTitle("Snowflake Donor")
	systray.SetTooltip("You are available to donate a Snowflake proxy")
	mQuit := systray.AddMenuItem("Stop Snowflake", "Close the application and stop your snowflake.")

	// Sets the icon of a menu item. Only available on Mac and Windows.
	mQuit.SetIcon(icon.Data)
	for {
		select {
		case <-mQuit.ClickedCh:
			os.Exit(0)
		}
	}
}

func onExit() {
	log.Println("Stopping the Snowflake")
}
