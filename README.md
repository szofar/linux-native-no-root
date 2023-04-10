## Run the build_toolchain.sh script to generate a native toolchain

### With a proxy and 16 parallel jobs for make
```
NTC=$PWD/ntc HTTP_PROXY=http://<site>:<port> HTTPS_PROXY=http://<site>:<port> FTP_PROXY=http://<site>:<port> NTC_MAKE_FLAGS="-j16" build_toolchain.sh
```

### Without a proxy
```
NTC=$PWD/ntc NTC_MAKE_FLAGS="-j16" build_toolchain.sh
```

### Without increasing the parallel job count
Sometimes parallel jobs (-jN) can cause issues on some machines.
```
NTC=$PWD/ntc build_toolchain.sh
```
