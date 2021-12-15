package main

import (
	"flag"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/getlantern/systray"

	"i2pgit.org/idk/blizzard/icon"

	"git.torproject.org/pluggable-transports/snowflake.git/common/safelog"
	sf "git.torproject.org/pluggable-transports/snowflake.git/proxy/lib"
)

var proxy sf.SnowflakeProxy

func main() {
	capacity := flag.Uint("capacity", 0, "maximum concurrent clients")
	stunURL := flag.String("stun", sf.DefaultSTUNURL, "broker URL")
	logFilename := flag.String("log", "", "log filename")
	rawBrokerURL := flag.String("broker", sf.DefaultBrokerURL, "broker URL")
	unsafeLogging := flag.Bool("unsafe-logging", false, "prevent logs from being scrubbed")
	keepLocalAddresses := flag.Bool("keep-local-addresses", false, "keep local LAN address ICE candidates")
	relayURL := flag.String("relay", sf.DefaultRelayURL, "websocket relay URL")
	directory := flag.String("directory", "", "directory with a page to serve locally for your snowflake. If empty, no local page is served.")
	port := flag.String("port", "7676", "port to serve info page(directory) on")

	flag.Parse()

	proxy = sf.SnowflakeProxy{
		Capacity:           uint(*capacity),
		STUNURL:            *stunURL,
		BrokerURL:          *rawBrokerURL,
		KeepLocalAddresses: *keepLocalAddresses,
		RelayURL:           *relayURL,
	}

	var logOutput io.Writer = os.Stderr
	log.SetFlags(log.LstdFlags | log.LUTC)

	log.SetFlags(log.LstdFlags | log.LUTC)
	if *logFilename != "" {
		f, err := os.OpenFile(*logFilename, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0600)
		if err != nil {
			log.Fatal(err)
		}
		defer f.Close()
		logOutput = io.MultiWriter(os.Stderr, f)
	}
	if *unsafeLogging {
		log.SetOutput(logOutput)
	} else {
		log.SetOutput(&safelog.LogScrubber{Output: logOutput})
	}
	go systray.Run(onReady, onExit)

	go func() {
		http.Handle("/", http.FileServer(http.Dir(*directory)))

		log.Printf("Serving %s on HTTP localhost:port: %s\n", *directory, *port)
		log.Fatal(http.ListenAndServe("localhost:"+*port, nil))
	}()

	err := proxy.Start()
	if err != nil {
		log.Fatal(err)
	}
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
			proxy.Stop()
			os.Exit(0)
		}
	}
}

func onExit() {
	log.Println("Stopping the Snowflake")
}
