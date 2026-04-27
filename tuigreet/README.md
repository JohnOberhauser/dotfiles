#### These steps are done in ../setup/scripts/setupTuigreet.sh

### Setting virtual terminal colors in the early boot process

#### Step 1
https://github.com/coderonline/base16-vtrgb

Use this repo.  Grab /initcpio/ and place those files in
/usr/lib/initcpio/hooks
/usr/lib/initcpio/install

(or install from the AUR)

#### Step 2
copy `vtrgb` to `/etc/vtrgb`

#### Step 3
edit /etc/mkinitcpio.conf
add `setvtrgb` to the `HOOKS` list.  Place it first in the list.

#### Step 3.5 (optional)
create a backup of your images in /boot/ just in case something goes terribly wrong

#### Step 4
run `mkinitcpio -P` to regenerate all the initramfs images

#### Step 5
Reboot your computer with your new colors


### Setting virtual terminal resolution

#### Step 1
edit /etc/mkinitcpio.conf
add `amdgpu` to the `MODULES` list.
add `kms` to the `HOOKS` list.  Place it first in the list.


### Showing asterisks when asking for LUKS password

#### Step 1
Make sure `plymouth` is installed

#### Step 2
edit /etc/mkinitcpio.conf
add `plymouth` to the `HOOKS` list.  Place it right before `encrypt`.
