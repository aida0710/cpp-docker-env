FROM ubuntu:20.04

# システムの更新とビルドツールのインストール
RUN apt update -y && \
    apt dist-upgrade -y && \
    apt install -y build-essential && \
    apt autoremove -y

# 必要なC++ライブラリとその他の開発ツールのインストール
RUN apt install -y libpcap-dev libcpprest-dev git cmake valgrind gdb libboost-all-dev libssl-dev libjson-c-dev

# エディタとIDEのインストール
RUN apt install -y vim emacs && \
    apt install -y software-properties-common && \
    apt update && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ focal main" && \
    apt update && \
    apt install -y clion

# 開発用ユーザーの作成とsudoの設定
RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# GitHub Gistから .bashrc ファイルをダウンロード
ARG BASHRC_GIST_URL="https://gist.githubusercontent.com/aida0710/221e1b97b2e0a9fabd5f491403745b8e/raw/0b11ee2508131bc793074a52e09905a9235d8e3b/bashrc_docker_env.sh"
RUN wget -O /root/.bashrc ${BASHRC_GIST_URL}

# 開発用ユーザーの .bashrc ファイルを更新
RUN echo 'if [ -f /root/.bashrc ]; then source /root/.bashrc; fi' >> /home/developer/.bashrc

# 再起動が必要な場合は再起動する
RUN [ -e /var/run/reboot-required ] && reboot

# 作業ディレクトリの設定
WORKDIR /app

# コンテナ起動時に実行するコマンド
CMD ["sudo", "-u", "developer", "bash"]
