# H4H Bot

This Telegram Bot is used for access control at House4Hack.

# Build

Can be compiled with GHC. Currently tested with GHC v7.10.3 and v7.6.3.

```
$ apt-get install ghc cabal-install
$ git clone git@github.com:house4hack/h4h-bot.git
$ cd h4h-bot
$ cabal sandbox init
$ cabal install --dependencies-only
$ cabal configure
$ cabal build
```

# Install

Copy the binary, config and systemd files. Systemd can of cause be
left out and the binary executed directly.

```
$ cp dist/h4h-bot/h4h-bot /usr/local/bin
$ cp default.cfg /etc/h4h-bot.cfg
$ cp h4h-bot.service /etc/systemd/system/
$ systemctl start h4h-bot
$ systemctl enable h4h-bot
```

# Config

```
$ cat /etc/h4h-bot.cfg
bot {
  token  = "23456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
}

access {
  group = -12345678 # Id of the telegram group to give access.
  door  = "http://192.168.1.1/door"
  gate  = "http://192.168.1.1/gate"
}
```

# Compilation on Raspberry Pi 1

Had to increase the swapfile size by editing `/etc/dphys-swapfile`.

```
root@DietPi:/etc# cat dphys-swapfile
CONF_SWAPSIZE=2048
```
