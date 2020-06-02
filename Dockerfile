FROM archlinux/base
ARG main_user

# Set current user on host. Remove SSH?
# https://medium.com/faun/set-current-host-user-for-docker-container-4e521cef9ffc

RUN \
  echo "**** add user ****" && \ 
  printf "root ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \
  echo "**** Update AUR ****" && \ 
  curl https://www.archlinux.org/mirrorlist/?ip_version=6 \
  | sed 's/^#Server/Server/' \
  | tee /etc/pacman.d/mirrorlist && \
  pacman --sysupgrade --sync --refresh --noconfirm&& \
  echo "**** install yay ****" && \ 
  pacman --sync --needed --noconfirm \
    base-devel \ 
    procps-ng \
    go \
    git \
    sudo && \
  useradd builduser -m && \
  passwd -d builduser && \
  printf 'builduser ALL=(ALL) ALL' | tee -a /etc/sudoers && \
  sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm' && \
  echo "**** install networking utils ****" && \ 
  sudo -u builduser bash -c ' \
    yay -S --needed --noconfirm \
      iproute2 \
      iputils \
  ' && \
  userdel -r builduser && \
  sed -i '$ d' /etc/sudoers

VOLUME /workstation

ENTRYPOINT chmod go-w /workstation

# chmod go-w ~/
# chmod go-w /workstation/ && chown simonwjackson:simonwjackson /workstation/
