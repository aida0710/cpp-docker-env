FROM ubuntu:20.04

# システムの更新とビルドツールのインストール
RUN apt update -y && \
    apt dist-upgrade -y && \
    apt install -y build-essential && \
    apt autoremove -y

# 必要なC++ライブラリとその他の開発ツールのインストール
RUN apt install -y libpcap-dev libcpprest-dev git cmake valgrind gdb libboost-all-dev libssl-dev libjson-c-dev

# 開発用ユーザーの作成とsudoの設定
RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ドットファイルの設定
COPY dotfiles/.bashrc /home/developer/.bashrc
COPY dotfiles/.vimrc /home/developer/.vimrc

# 再起動が必要な場合は再起動する
RUN [ -e /var/run/reboot-required ] && reboot

# 作業ディレクトリの設定
WORKDIR /app

# コンテナ起動時に実行するコマンド
CMD ["sudo", "-u", "developer", "bash"]
