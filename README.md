# YMM4

EASY change FPS and Resolution.

方便改变 FPS 和 分辨率 的 RUBYGEM。

便利使いに FPSと解像度 変更してノrubygem


## 使用方法 :: 使い方法 :: Usage

```ruby
require 'ymm4'

ymmp = YMM4::Project.load_file(".ymmp")
 # #<YMM4::Project 1920x1080 60fps 48000Hz len: 3:56
 #    from: ".ymmp">
ymmp.set_fps(144).rescale(2)
```
### USAGE:
```ruby
ymmp = YMM4::Project.load_file("test.YMM4")
#=> #<YMM4 1920x1080 30fps 48000Hz 3:56
#    from: "D:/test.ymmp">
ymmp.set_fps(144).rescale(2)
#=> #<YMM4::Project 3840x2160 144fps 3:56...>
```
### 导出工程 :: Output a ymmp
```ruby
  File.write("test.ymmp", ymmp.output)
```
### 更多细节 :: Detailly Edit
```ruby
  ymmp.body #=> <OpenStruct ...>
```
Every __Hash__ Element had been Converted to __OpenStruct__
#### 改变所有项目的字体大小 :: Change All Items' Font Size
```ruby
  ymmp.body.Timeline.Items.each do |item|
    item["fontSize"].Values[0].Value *= 2
  end

```

## 安装 :: Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ymm4

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ymm4

