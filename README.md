Blizzard: The I2P Snowflake donor Plugin
========================================

[![Create a Blizzard](blizzard.png)](https://eyedeekay.github.io/blizzard)

We believe that finding ways to strengthen resistence to censorship and maintain access to digital privacy and freedom starts with working on the strengths of the technical abilities of Tor Project and the Invisible Internet (I2P). 

What is Blizzard and how does it help Tor?
------------------------------------------

We learned about instances of attacking Snowflake users by identifying Snowflakes and cutting the users off. This is similar to blocking attempts to I2P where I2P nodes are enumerated and then users are disconnected from those nodes. However, due to I2P's high churn rate, this blocking technique does not appear to have any practical effect on an I2P user's ability to join the network or access information. Blizzard uses I2P's peer diversity and churn to allow access to Tor in blocked areas.

Blizzard is a standalone version of the Tor Project’s Snowflake proxy. It can be used to produce an I2P Plugin that will donate a Snowflake to Tor Browser users. The Snowflake uses I2P to manage its lifecycle. That means when you start and stop your I2P router you start and stop the Snowflake.

**If you can safely use I2P in non-hidden mode, you're probably able to safely donate a Snowflake long-term.**

How Can I Donate a Snowflake?
-----------------------------

If you can safely use I2P in non- hidden mode, you will have the ability to donate a Snowflake long-term. Instructions are available for Windows and Linux at this time.

How do I know if I am in Hidden Mode? What does that mean?
----------------------------------------------------------

Hidden Mode changes your router’s interaction with the I2P network so that it offers protections for people in areas where participating fully in the network may be a violation of local restrictions. These defences make these routers more difficult to enumerate reliably, and prevent them from potentially being in violation of restrictions on routing traffic for others. You can read more about Hidden Mode on the [The I2P Project Website](https://geti2p.net/en/about/restrictive-countries).

Create A Blizzard:
------------------

### Inside I2P

 - [Windows (In-I2P)](http://idk.i2p/blizzard/snowflake-windows.su3)
 - [Linux (In-I2P)](http://idk.i2p/blizzard/snowflake-linux.su3)

### Outside I2P

 - [Windows](https://github.com/eyedeekay/blizzard/releases)
 - [Linux](https://github.com/eyedeekay/blizzard/releases)

#### Interested in helping more?

 - [Get the Snowflake Firefox extension](https://addons.mozilla.org/en-US/firefox/addon/torproject-snowflake/)
 - [Get the Snowflake Chrome extension](https://chrome.google.com/webstore/detail/snowflake/mafpmfcccpbjnhfhjnllmmalhifmlcie)
 - [Use the Snowflake Go library to add a proxy to your application](https://pkg.go.dev/git.torproject.org/pluggable-transports/snowflake.git/v2@v2.0.1/proxy/lib)
 - Embed the snowflake badge on your own site by copy-and-pasting the following iframe:

`<iframe src="https://snowflake.torproject.org/embed.html" width="320" height="240" frameborder="0" scrolling="no"></iframe>`

<iframe src="https://snowflake.torproject.org/embed.html" width="320" height="240" frameborder="0" scrolling="no"></iframe>

