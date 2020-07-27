FROM lihaixin/novnc
MAINTAINER Haixin Lee <docker@lihaixin.name>
ENV XYZ="1024x768x16"
ENV PROXY_URL="socks5://User-001:qq159@50.117.22.53:13092"

#加载flash仓库源
RUN echo "deb http://archive.canonical.com/ubuntu/ xenial partner" >> /etc/apt/sources.list

#升级系统，安装chromium和flash多媒体插件和gzip解压软件和下载gost
RUN apt-get update -y && \
    apt-get install  -y --no-install-recommends adobe-flashplugin chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg gzip && \
    wget "https://github.com/ginuerzh/gost/releases/download/v2.11.0/gost-linux-amd64-2.11.0.gz" && \
    gzip -d gost-linux-amd64-2.11.0.gz && \
    mv gost-linux-amd64-2.11.0 /usr/bin/gost && \
    chmod +x /usr/bin/gost
    


# 升级到最新版本
RUN apt-get upgrade --yes

# 删除不必要的软件和Apt缓存包列表
RUN apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# 容器里超级进程管理
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 开放VNC端口和noVNC端口
#EXPOSE 5900 
EXPOSE 8787
VOLUME /root/Downloads



# 运行各种Service

CMD ["/usr/bin/supervisord"]
