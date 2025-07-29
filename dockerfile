FROM opensips/opensips:3.5

# Install core dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libncurses5-dev m4 curl default-mysql-client gettext git build-essential

# Install OpenSIPS modules
RUN echo 'Acquire::https::apt.opensips.org::Verify-Peer "false";' | tee /etc/apt/apt.conf.d/99no-verify-opensips
RUN curl -k "https://apt.opensips.org/opensips-org.gpg" -o /usr/share/keyrings/opensips-org.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bullseye 3.5-releases" >/etc/apt/sources.list.d/opensips.list

RUN apt-get update && apt-get -y install opensips-mysql-module opensips-http-modules opensips-auth-modules

# Install rtpproxy
RUN cd /usr/src && git clone -b master https://github.com/sippy/rtpproxy.git && git -C rtpproxy submodule update --init --recursive
RUN cd /usr/src/rtpproxy && ./configure && make clean all && make install
RUN useradd --system --no-create-home --group nogroup rtpproxy