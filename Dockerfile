FROM archlinux/base

ARG login=workstation

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
    sed \
    git \
    sudo \
  && \
  echo "**** become super  ****" && \ 
  printf "${login} ALL = (ALL:ALL) ALL\n" | tee -a /etc/sudoers && \
  echo "**** install yay ****" && \ 
  useradd builduser -m && \
  passwd -d builduser && \
  printf 'builduser ALL=(ALL) ALL' | tee -a /etc/sudoers && \
  sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm'

RUN \
  echo "**** install networking utils ****" && \ 
  sudo -u builduser bash -c ' \
    yay -S --needed --noconfirm \
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
  printf "${login} ALL = NOPASSWD : ALL\n" | tee -a /etc/sudoers 

VOLUME /workstation

EXPOSE 22

#  passwd -d --expire ${main_user} && \
# EXPOSE 60000-61000 
# ENTRYPOINT chmod go-w /workstation/ && \
  # chown simonwjackson:simonwjackson /workstation/ && \
  # /usr/sbin/sshd -eD

# chmod go-w ~/
# chmod 700 ~/.ssh
# chmod 600 ~/.ssh/authorized_keys
# chmod 644 ~/.ssh/known_hosts
# chmod 644 ~/.ssh/config
# chmod 600 ~/.ssh/id_rsa
# chmod 644 ~/.ssh/id_rsa.pub
# chmod go-w /workstation/ && chown simonwjackson:simonwjackson /workstation/


# useradd \
#   -d /workstation \
#   -m ${login} && \

# mosh-git \