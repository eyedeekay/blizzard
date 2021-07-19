package main

import (
	"flag"
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
	snowflake.Main(flags)
}
