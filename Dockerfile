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

RUN \
  echo "**** add root to sudoers ****" && \ 
  pacman --sysupgrade --sync --refresh --noconfirm && \
  echo "**** install yay ****" && \ 
  pacman --sync --needed --noconfirm \
    zsh \
    libffi \
    base-devel \ 
    procps-ng \
    go \
    git \
    sudo && \
  printf "simonwjackson ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \
  printf "${login} ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \
  useradd builduser -m && \
  passwd -d builduser && \
  printf 'builduser ALL=(ALL) ALL' | tee -a /etc/sudoers && \
  sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm' && \
  userdel -r builduser && \
  sed -i '$ d' /etc/sudoers

VOLUME /workstation

# ENTRYPOINT chmod go-w /workstation

# chmod go-w ~/
# chmod go-w /workstation/ && chown simonwjackson:simonwjackson /workstation/
