# OpenCVForiOSDemo
iOS平台下opencv实践

开发步骤：
1. 下载opencv2.framework，下载地址：http://opencv.org/
2. 新建iOS项目，导入opencv2.framework
3. 修改需要引入opencv库的.m文件为.mm文件，避免编译opencv的c++代码时出错
4. 自定义UIImage的分类，其中实现opencv图像类与obective c图像类之间的转换
5. 运行