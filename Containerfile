FROM registry.fedoraproject.org/fedora-toolbox:39 AS fedora-distrobox

# Install packages required by Distrobox, this speeds up the first-run time
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
        samba-common-tools \
        rclone \
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
        vulkan

# Set up dependencies
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox && \
    dnf install -y 'dnf-command(copr)'

# Install RPMFusion for hardware accelerated encoding/decoding
RUN dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y \
        intel-media-driver \
        nvidia-vaapi-driver && \
    dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld && \
    dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

# Set up cleaner Distrobox integration 
RUN dnf install -y 'dnf-command(copr)' && \
    dnf copr enable -y kylegospo/distrobox-utils && \
    dnf install -y \
        xdg-utils-distrobox \
        adw-gtk3-theme 

# My packages
RUN dnf install -y \
        adw-gtk3-theme \
        ansible \
        bind-utils \
        butane \
        coreos-installer \
        highlight \
        jq \
        kitty \
        lsd \
        nmap \
        oci-cli \
        podman-tui \
        stow \
        telnet \
        tmux \
        vim \
        wl-clipboard \
        zsh

# install microsoft VS Code
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
    dnf install -y code

# link some things back
RUN ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/buildah && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/cosign && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/htop && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/just && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/skopeo 

# Cleanup
RUN rm -rf /tmp/* && \
    dnf clean all
