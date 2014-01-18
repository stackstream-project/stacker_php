directory node[:project][:directory] do
  owner "root"
  group "root"
  mode 00755
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

execute "create virtual group project" do
  command "vgcreate project /dev/xvdb"
  user "root"
  group "root"
  action :run
  not_if "vgdisplay project"
  only_if "fdisk -l | grep /dev/xvdb"
end

mounts.each_index do |i,m|
  execute "extend virtual group project with /dev/#{m}" do
    command "vgextend project /dev/#{m}"
    user "root"
    group "root"
    action :run
    only_if "vgextend -t project /dev/#{m}"
    only_if "fdisk -l | grep /dev/#{m}"
  end
end

execute "create logical group project" do
  command "lvcreate -l 100%FREE -n ephemeral project"
  user "root"
  group "root"
  action :run
  not_if "lvdisplay /dev/mapper/project-ephemeral"
  only_if "fdisk -l | grep /dev/xvdb"
end

execute "create ext4 filesystem" do
  command "mkfs.ext4 /dev/mapper/project-ephemeral"
  user "root"
  group "root"
  action :run
  not_if "blkid /dev/mapper/project-ephemeral | grep ext4"
  only_if "fdisk -l | grep /dev/xvdb"
end

mount node[:project][:directory] do
  device "/dev/mapper/project-ephemeral"
  fstype "ext4"
  options "auto"
  action [:mount, :enable]
  only_if "fdisk -l | grep /dev/xvdb"
end

directory "#{node[:project][:directory]}/#{node[:project][:name]}" do
  owner "apache"
  group "apache"
  mode 00755
  recursive true
  action :create
end

directory "#{node[:project][:directory]}/#{node[:project][:name]}/versions" do
  owner "apache"
  group "apache"
  mode 00755
  recursive true
  action :create
end

