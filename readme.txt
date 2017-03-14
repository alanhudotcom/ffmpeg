1.先下载x264的工程代码，【git clone git://git.videolan.org/x264.git】。

2.进入x264目录，然后./configure --help看看它的帮助信息，我们这里需要的是x264以.so or .a的形式来支援ffmpeg，所以一般就关注shared和static关键词就可以了。执行./configure --enable-shared --enable-static就行了。

3.完了make && sudo make install就可以了。

编译x264_iOS时，先去除x264中生成的配置文件；
提前创建好x264-thin-iOS目录



下载ffmpeg
git clone http://source.ffmpeg.org/git/ffmpeg.git ffmpeg