FROM archlinux/base

#   echo "**** Update AUR ****" && \ 
#   curl https://www.archlinux.org/mirrorlist/?ip_version=6 \
#   | sed 's/^#Server/Server/' \
#   | tee /etc/pacman.d/mirrorlist && \
# echo "**** install networking utils ****" && \ 
# sudo -u builduser bash -c ' \
#   yay -S --needed --noconfirm \
#     iproute2 \
#     iputils \
# ' && \
# printf "root ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \

ARG login=workstation
ARG pkglist

RUN \
  echo "**** install essentials ****" && \ 
  pacman --sync --needed --noconfirm \
    libffi \
    base-devel \ 
    procps-ng \
    go \
    curl \
    git \
    sudo \
  && \
  echo "**** install yay ****" && \ 
  printf "${login} ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \
  sudo -u "${login} bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm'"

RUN \ 
  if [ "${pkglist}" -ne "" ] then 
    echo "**** Install custom packages ****" && \ 
    pacman --sync --needed $(comm -12 <(pacman -Slq | sort) <(curl "${pkglist}"))
  fi

VOLUME /workstation

# ENTRYPOINT chmod go-w /workstation

# chmod go-w ~/
# chmod go-w /workstation/ && chown simonwjackson:simonwjackson /workstation/
