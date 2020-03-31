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
      mosh-git \
      openssh \
      iproute2 \
      iputils \
  ' && \
  ssh-keygen -A -vvv && \
  echo "**** Harden SSH ****" && \ 
  sed -i 's/#\?\(PerminRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config && \
  sed -i 's/#\?\(PubkeyAuthentication\s*\).*$/\1 yes/' /etc/ssh/sshd_config && \
  sed -i 's/#\?\(PermitEmptyPasswords\s*\).*$/\1 no/' /etc/ssh/sshd_config && \
  sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config && \
  userdel -r builduser && \
  sed -i '$ d' /etc/sudoers && \
  useradd \
    -d /workstation \
    -m ${main_user} && \
  passwd -d --expire ${main_user} && \
  printf "${main_user} ALL = NOPASSWD : ALL\n" | tee -a /etc/sudoers 

VOLUME /workstation

EXPOSE 22
EXPOSE 60000-61000 
ENTRYPOINT chmod go-w /workstation/ && \
  chown simonwjackson:simonwjackson /workstation/ && \
  /usr/sbin/sshd -eD

# chmod go-w ~/
# chmod 700 ~/.ssh
# chmod 600 ~/.ssh/authorized_keys
# chmod 644 ~/.ssh/known_hosts
# chmod 644 ~/.ssh/config
# chmod 600 ~/.ssh/id_rsa
# chmod 644 ~/.ssh/id_rsa.pub
# chmod go-w /workstation/ && chown simonwjackson:simonwjackson /workstation/
