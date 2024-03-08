# Apacker - Application packer
## 目标
本工具的目标是实现linux/unix系系统上的应用程序一键打包及升级。

## 原理
应用程序在Linux同体系跨不同的发行版（如redhat/ubuntu/debian等）时常常因为依赖项（如动态库）版本与编译时使用的不同导致无法正常运行。解决这一问题的常规做法是为不同的操作系统发行版编译对应的应用程序软件版本，发布至包管理软件中（如YUM/APT等），这也是共享库使用的正确做法。  
不过对于一款要适配多个发行版的商业软件来说，维护众多发行版的软件版本是一项比较繁重的任务，我们采用docker/容器的思想，来解决这一问题。将应用程序所有的依赖项打包进安装包，并修改应用程序中的动态库依赖路径, 使应用程序在目标运行环境上有独立的运行环境，而不是依赖操作系统已安装的库运行。  
本工具是打包工具，应用程序在使用本工具时，需要整理好编译出来的应用程序目标文件及其所有依赖项到若干个文件夹，配置好环境信息，然后一键打包。

## 示例
1. 整理应用程序的打包文件,并修改好可执行文件动态库的指向  
如下是一个需要打包的l7程序的结构：
```
l7/
├── lib
│   ├── a.so
│   ├── b.so
│   └── c.so
└── parsor
注：parsor的动态库（a.so|b.so|c.so）指向路径已修改为其安装位置
```
`l7`文件夹内包含了`parsor`可执行文件，其所有依赖项放进了次级文件夹`lib`下。  
2. 配置打包参数  
- VERSION
  ```
  1.0.0
  ```
- env 
 ```
 #Directories to pack
DIRS=l7

#.run to write to
RUNDIR=release

#Directory to install
TARGET=/opt/dynarose/l7
```
3. 运行打包命令  
```
root@dynarose:/home/dynarose/apacker# ./pack.sh 
Header is 718 lines long

About to compress 8 KB of data...
Adding files to archive named "release/l7-1.0.0.run"...
./lib/a.so
./lib/b.so
./lib/c.so
./parsor
CRC: 1037095383
MD5: 7102d1ef3ecb899ccd3a4b83b51ec45e

Self-extractable archive "release/l7-1.0.0.run" successfully created.
```
4. 查看打包输出  
```
root@dynarose:/home/dynarose/apacker# tree release/
release/
└── l7-1.0.0.run

0 directories, 1 file
```
5. 验证安装包  
```
root@dynarose:/home/dynarose/apacker# release/l7-1.0.0.run 
Creating directory /opt/dynarose/l7
Verifying archive integrity...  100%   MD5 checksums are OK. All good.
Uncompressing l7 v1.0.0  100%  
l7 has installed.
root@dynarose:/home/dynarose/apacker# tree /opt/dynarose/l7/
/opt/dynarose/l7/
├── lib
│   ├── a.so
│   ├── b.so
│   └── c.so
└── parsor

1 directory, 4 files

```