### ===========================================================================
### Container for running HOL Light.
###
### Debian image with OCaml, elpi, dmtcp and other tools installed.
### ===========================================================================

### ---------------------------------------------------------------------------
### Based on a Debian image with Opam preinstalled, maintained by the
### OCaml team.  Use the variant with ocaml 4.07.1, the latest supported
### version by HOL Light (actually camlp5) as of September 2019.
### ---------------------------------------------------------------------------

FROM ocaml/opam2:4.07

### ---------------------------------------------------------------------------
### Prepare a working directory for the user.
### ---------------------------------------------------------------------------

USER opam

RUN mkdir -p /home/opam/work

### ---------------------------------------------------------------------------
### Install the needed Debian packages.
### ---------------------------------------------------------------------------

USER root

RUN apt-get update \
 && apt-get -y install build-essential git curl make m4 rlwrap screen tmux

### ---------------------------------------------------------------------------
### Install the needed opam packages.
### ---------------------------------------------------------------------------

RUN opam update \
 && opam install num camlp5 merlin elpi

### ---------------------------------------------------------------------------
### Install Dmtcp, Version 2019-09-21.
### Version 2019-04-22 is also know to work:
### ARG DMTCP_VERSION=cfe168e2539b60e29bbac27da9a8b78b77add2a6
### ---------------------------------------------------------------------------

ARG DMTCP_VERSION=8c20abe3d8b90c22a5145c4364fac4094d10d9cf

RUN mkdir -p /home/opam/src/dmtcp \
 && cd /home/opam/src/dmtcp \
 && curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && ./configure --prefix=/usr/local && make -j 2 \
 && sudo make install \
 && cd /home/opam && rm -rf src

### ---------------------------------------------------------------------------
### Startup configuration.
### ---------------------------------------------------------------------------

WORKDIR /home/opam/work
