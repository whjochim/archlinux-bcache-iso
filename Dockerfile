FROM archlinux
WORKDIR /archlinux-bcache-iso
RUN pacman -Syyu git base-devel archiso --noconfirm
RUN git clone https://aur.archlinux.org/bcache-tools
RUN useradd dummy\
    && chown -R dummy bcache-tools\
    && cd bcache-tools\
    && su dummy -c "makepkg -s"
RUN mkdir customrepo\
    && mv bcache-tools/*.pkg.tar.xz customrepo\
    && repo-add customrepo/custom.db.tar.gz customrepo/*.pkg.tar.xz
RUN cp -r /usr/share/archiso/configs/releng archlive\
    && echo "[custom]" >> archlive/pacman.conf\
    && echo "SigLevel = Optional TrustAll" >> archlive/pacman.conf\
    && echo "Server = file:///archlinux-bcache-iso/customrepo"\
       >> archlive/pacman.conf\
    && echo "bcache-tools" >> archlive/packages.x86_64
CMD /archlinux-bcache-iso/archlive/build.sh -v;\
    mv /archlinux-bcache-iso/out/* /tmp