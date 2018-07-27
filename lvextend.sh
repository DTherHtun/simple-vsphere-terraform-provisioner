sudo hostnamectl set-hostname mm1p-ansible01.ascendmoney.internal

(
echo n # Add a new partition  
echo p # Primary partition  
echo 1 # Partition number  
echo   # First sector (Accept default: 1)  
echo   # Last sector (Accept default: varies)  
echo w # Write changes  
) | sudo fdisk /dev/sdb

sudo partprobe -s
sudo pvcreate /dev/sdb1
sudo vgextend vg_rhel /dev/sdb1
sudo lvextend -l +100%FREE /dev/vg_rhel/lv_var
sudo xfs_growfs /dev/vg_rhel/lv_var
