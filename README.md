[![nuspell:5.1.4](https://img.shields.io/badge/nuspell-5.1.4-green.svg)](https://github.com/nuspell/nuspell)
[![semenovp/tiny-nuspell:latest](https://img.shields.io/docker/image-size/semenovp/tiny-nuspell/latest)](https://hub.docker.com/r/semenovp/tiny-nuspell)
[![docker pulls](https://img.shields.io/docker/pulls/semenovp/tiny-nuspell.svg)](https://hub.docker.com/r/semenovp/tiny-nuspell)

# Usage
Just add the following alias to your `.bashrc` (or `.bash_profile` for OSX):

```bash
alias nuspell='docker run --rm -v <path/to/hunspell/dictionaries>:/usr/share/hunspell -v `pwd`:/workdir -w /workdir semenovp/tiny-nuspell:latest'
```

Now your shell is ready to go.
For example, do like this:

```bash
nuspell -d <path/to/en_US.aff> /path/to/file 
```

# How to build on your own?

First, your machine should be provisioned with tools from list below:

* [Make](https://www.gnu.org/software/make/manual/make.html)
* [Docker](https://docs.docker.com/get-docker/)
* [DGoss](https://github.com/goss-org/goss/blob/master/extras/dgoss/README.md#installation)

Then, just `cd` to repo root directory and type `make`.
That's it!
