FROM centos:7 as builder
MAINTAINER V7hinc

ENV PYTHON_VERSION=3.9.6
ENV PYTHON_PATH=/usr/local/python3

WORKDIR /tmp

# 安装必要插件
# 源码安装python3.7
RUN set -x;\
yum install wget -y;\
yum -y groupinstall "Development tools";\
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel;\
yum install -y libffi-devel zlib1g-dev;\
yum install zlib* -y;\
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz;\
tar -xvJf  Python-${PYTHON_VERSION}.tar.xz;\
mkdir /usr/local/python3;\
cd Python-${PYTHON_VERSION};\
./configure --prefix=${PYTHON_PATH} --enable-optimizations --with-ssl;\
#第一个指定安装的路径,不指定的话,安装过程中可能软件所需要的文件复制到其他不同目录,删除软件很不方便,复制软件也不方便.
#第二个可以提高python10%-20%代码运行速度.
#第三个是为了安装pip需要用到ssl,后面报错会有提到.
make && make install;\
ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3;\
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3;\
python3 -V;\
pip3 -V;\
cd ..;\
rm -rf Python-${PYTHON_VERSION}*;

# 直接拷贝编译后的python3.7
FROM centos:7

ENV PYTHON_VERSION=3.9.6
ENV PYTHON_PATH=/usr/local/python3

COPY --from=builder ${PYTHON_PATH} ${PYTHON_PATH}

WORKDIR /

RUN set -x;\
ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3;\
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3;\
python3 -V;\
pip3 -V;

CMD python3
