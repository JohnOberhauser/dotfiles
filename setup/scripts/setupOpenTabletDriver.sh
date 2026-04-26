# https://opentabletdriver.net/Wiki/Install/Linux

# Regenerate initramfs
sudo mkinitcpio -P
# Unload kernel modules
sudo rmmod hid_uclogic