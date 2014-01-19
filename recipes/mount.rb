directory "/ephemeral" do
  owner "root"
  group "root"
  mode 00775
  action :create
end

mounts = ["xvdb", "xvdc", "xvdd", "xvde"]

mounts.each_with_index do |m,i|
  mount "/media/ephemeral#{i}" do
    device "/dev/#{m}"
    action [:umount, :disable]
    only_if "df -h | grep '/dev/#{m}'"
  end

  execute "create physical volume #{m}" do
    command "pvcreate /dev/#{m}"
    user "root"
    group "root"
    action :run
    not_if "pvdisplay /dev/#{m}"
    only_if "fdisk -l | grep /dev/#{m}"
  end
end

execute "create virtual group media" do
  command "vgcreate media /dev/xvdb"
  user "root"
  group "root"
  action :run
  not_if "vgdisplay media"
  only_if "fdisk -l | grep /dev/xvdb"
end

mounts.each_index do |i,m|
  execute "extend virtual group media with /dev/#{m}" do
    command "vgextend media /dev/#{m}"
    user "root"
    group "root"
    action :run
    only_if "vgextend -t media /dev/#{m}"
    only_if "fdisk -l | grep /dev/#{m}"
  end
end

execute "create logical group ephemeral" do
  command "lvcreate -l 100%FREE -n ephemeral media"
  user "root"
  group "root"
  action :run
  not_if "lvdisplay /dev/mapper/media-ephemeral"
  only_if "fdisk -l | grep /dev/xvdb"
end

execute "create ext4 filesystem" do
  command "mkfs.ext4 /dev/mapper/media-ephemeral"
  user "root"
  group "root"
  action :run
  not_if "blkid /dev/mapper/media-ephemeral | grep ext4"
  only_if "fdisk -l | grep /dev/xvdb"
end

mount "/ephemeral" do
  device "/dev/mapper/media-ephemeral"
  fstype "ext4"
  options "auto"
  action [:mount, :enable]
  only_if "fdisk -l | grep /dev/xvdb"
end
