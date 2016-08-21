# autotee usage example

This repository shows how to use [autotee](http://github.com/fxkr/autotee) with nginx-rtmp.

Dependencies:

* An nginx compiled with [rtmp support](https://github.com/arut/nginx-rtmp-module).
* Build dependencies of [autotee](https://github.com/fxkr/autotee), incl.:
  * [Go compiler](https://golang.org/).
  * GNU screen
* mplayer

Usage:

```
export NGINX=.../nginx
./demo.sh
```

