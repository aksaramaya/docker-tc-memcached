FROM aksaramaya/tc

# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG=C.UTF-8 LC_ALL=C

RUN tce-load -wic gnupg curl \
    && rm -rf /tmp/tce/optional/*

ENV MEMCACHED_VERSION 1.4.31

RUN tce-load -wic \
        bzip2-dev \
        flex \
        file \
        gcc \
        make \
        linux-4.2.1_api_headers \
        glibc_add_lib \
        glibc_base-dev \
        openssl-dev \
        gdbm-dev \
        ncurses-dev \
        readline-dev \
        sqlite3-dev \
        liblzma-dev \
        zlib_base-dev \
        tk-dev \
        libX11-dev \
	libevent-dev \
	libevent \
        libXss \
        xorg-proto; \
        cd /tmp; \
        curl -SL https://memcached.org/files/memcached-1.4.31.tar.gz -o memcached.tar.gz; \
        tar -vxf memcached.tar.gz -C /tmp; \
        pwd; \
        rm memcached.tar.gz; \
        cd "/tmp/memcached-$MEMCACHED_VERSION"; \
        ./configure; \
	make; \
        sudo make install; \
        cd /; \
        rm -rf "/tmp/memcached-$MEMCACHED_VERSION"; \
        cd /tmp/tce/optional; \
        for PKG in `ls *-dev.tcz`; do \
            echo "Removing $PKG files"; \
            for F in `unsquashfs -l $PKG | grep squashfs-root | sed -e 's/squashfs-root//'`; do \
                [ -f $F -o -L $F ] && sudo rm -f $F; \
            done; \
            INSTALLED=$(echo -n $PKG | sed -e s/.tcz//); \
            sudo rm -f /usr/local/tce.installed/$INSTALLED; \
        done; \
        for PKG in binutils.tcz \
                cloog.tcz \
                flex.tcz \
                file.tcz \
                gcc.tcz \
                gcc_libs.tcz \
                linux-4.2.1_api_headers.tcz \
                make.tcz \
                sqlite3-bin.tcz \
                xz.tcz \
		perl.tcz \
                xorg-proto.tcz \
		libevent.tcz ; do \
            echo "Removing $PKG files"; \
            for F in `unsquashfs -l $PKG | grep squashfs-root | sed -e 's/squashfs-root//'`; do \
                [ -f $F -o -L $F ] && sudo rm -f $F; \
            done; \
            INSTALLED=$(echo -n $PKG | sed -e s/.tcz//); \
            sudo rm -f /usr/local/tce.installed/$INSTALLED; \
        done; \
        sudo rm -f /usr/bin/file \
        sudo /sbin/ldconfig \
        rm -rf /tmp/tce/optional/* \

USER root

CMD ["bash"]
