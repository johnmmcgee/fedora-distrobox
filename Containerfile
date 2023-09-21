FROM registry.fedoraproject.org/fedora-toolbox:latest AS fedora-distrobox

# Set up dependencies for distrobox-host-exec
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /tmp/distrobox/host-spawn && \
    cp /tmp/distrobox/host-spawn /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox

# Set up cleaner Distrobox integration
RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/distrobox-utils/repo/fedora-39/kylegospo-distrobox-utils-fedora-39.repo -O /etc/yum.repos.d/_copr_kylegospo-distrobox-utils.repo && \
    dnf install -y \
        xdg-utils-distrobox \
        adw-gtk3-theme && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak

# Install packages required by Distrobox
RUN dnf install -y \
        bash-completion \
        bc \
        bzip2 \
        curl \
        diffutils \
        dnf-plugins-core \
        findutils \
        glibc-all-langpacks \
        glibc-locale-source \
        gnupg2 \
        gnupg2-smime \
        hostname \
        iproute \
        iputils \
        keyutils \
        krb5-libs \
        less \
        lsof \
        man-db \
        man-pages \
        mtr \
        ncurses \
        nss-mdns \
        openssh-clients \
        pam \ 
        passwd \
        pigz \ 
        pinentry \
        procps-ng \
        rsync \
        shadow-utils \
        sudo \ 
        tcpdump \
        time \ 
        traceroute \
        tree \ 
        tzdata \
        unzip \ 
        util-linux \
        vte-profile \
        wget \
        which \ 
        whois \
        words \
        xorg-x11-xauth \
        xz \
        zip \
        mesa-dri-drivers \
        mesa-vulkan-drivers \
        vulkan && \
    rm -rf \
        /tmp/*