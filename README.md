```
$ make create_switch
$ make install
$ make serve # in one terminal (requires `bun` to be installed globally)

# open another terminal to run the different tests
$ make test_piaf
$ make test_cohttp
$ make test_blink

# optionally can change BATCH, TIMES and DELAY
$ BATCH="30" TIMES="100" SERVER="" make test_cohttp
```
