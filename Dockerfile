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
  echo "**** update system ****" && \ 
  pacman --sysupgrade --sync --refresh --noconfirm && \ 
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
  echo "**** become super  ****" && \ 
  printf "${login} ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \
  echo "**** install yay ****" && \ 
  useradd builduser -m && \
  passwd -d builduser && \
  printf 'builduser ALL=(ALL) ALL' | tee -a /etc/sudoers && \
  sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm' && \
  userdel -r builduser && \
  sed -i '$ d' /etc/sudoers

RUN \ 
  if [ "${pkglist}" -ne "" ]; then \
    echo "**** Install custom packages ****" && \ 
    pacman --sync --needed $(comm -12 <(pacman -Slq | sort) <(curl "${pkglist}")); \
  fi

VOLUME /workstation

# ENTRYPOINT chmod go-w /workstation

# chmod go-w ~/
# chmod go-w /workstation/ && chown simonwjackson:simonwjackson /workstation/
