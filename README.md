Ubuntu Live CD customisation
-----------------------------

1) Ensure you are running the same (or earlier) ubuntu than you want to customise

2) Install `squashfs-tools` and  `genisoimage`
    sudo aptitude install squashfs-tools genisoimage

3) Run
    ./setupImage.bash <iso file>
  to extract the iso image to `iso-extract` and the underlying image to `iso-modified`

4) Run
    ./doChroot
to inject into the chroot environment, copying `custom`, `setupInsideChroot.bash`, `insideChrootActions.bash` and `cleanupInsideChroot.bash` to `/`

5) When inside the chroot environment do
    ./insideChrootActions.bash
to do main actions

6) Type `exit` to exit out of the chroot environment

7) Run
    ./createIso.bash <output iso file name>
to make the output iso
