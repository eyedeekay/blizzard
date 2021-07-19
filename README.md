Snowflake Donor I2P Plugin, `"The Blizzard"`
============================================

This is a library version of the freestanding Snowflake proxy, which I use to
produce an I2P Plugin which donates a Snowflake to Tor Browser Users. The
Snowflake uses I2P to manage it's life-cycle, when you start and stop I2P, so
goes the Snowflake.

Why?
----

Well, partly the observation that if you are able to run a participating,
non-hidden I2P router safely, you are also probably able to run a Snowflake
proxy. More generally, because I strongly believe that Tor and I2P are on the
"Same Team" when it comes to improving online privacy and enhancing digital
autonomy for all. Our networks have different strengths, different use cases,
and different workflows and where these things differ, sometimes an opportunity
arises to help another project.

More to the point, I2P is designed to have long runtimes, to be run pretty
regularly, and most of I2P's routers route at least some "Participating" traffic
which means traffic they route on behalf of other I2P users, as needed. This is
a similar pattern to Snowflake. The only situation where I2P routers don't
attempt to participate in the network is if they are placed in **Hidden Mode**
because routing I2P packets would be unsafe for them. This is also the sort of
situation where operating a Snowflake would be unsafe. **So *If* you're able**
**to safely run an I2P router in non-hidden mode, you're probably able to**
**safely donate a Snowflake long-term.**

So **TL:DR** just to be prosocial.

Get it:
-------

### Outside I2P

 - [Windows](https://github.com/eyedeekay/blizzard/releases)
 - [Linux](https://github.com/eyedeekay/blizzard/releases)

### Inside I2P
 
 - [Windows (In-I2P)](https://idk.i2p/blizzard/snowflake-win.su3)
 - [Linux (In-I2P)](https://idk.i2p/blizzard/snowflake.su3)