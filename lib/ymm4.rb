# frozen_string_literal: true

require_relative "YMM4/version"

module YMM4
  class Error < StandardError; end
  # Your code goes here...
end

require 'json'
require 'ostruct'

# ### USAGE:
#
#   ymmp = YMM4::Project.load_file("test.YMM4")
#   #=> #<YMM4 1920x1080 30fps 48000Hz 3:56
#   #    from: "D:/test.ymmp">
#   ymmp.set_fps(144).rescale(2)
#   #=> #<YMM4::Project 3840x2160 144fps 3:56...>
# ### Output a ymmp
#
#   File.write("test.ymmp", ymmp.output)
#
# ### Detailly Edit
#
#   ymmp.body #=> <OpenStruct ...>
#
# #### Change All Items' Font Size
#
#   ymmp.body.Timeline.Items.each do |item|
#     item.FontSize.Values[0].Value *= 2
#   end
#
module YMM4
end
class YMM4::Project
  def initialize hash
    @body = self.class.h2os(hash)
  end


  # Reset the FPS of Project.
  # Applied for Items' `Length`, __Start Time__`Frame`.
  def set_fps new_fps, make_chara: false
    ori_fps = @body.Timeline.VideoInfo.FPS
    @body.Timeline.VideoInfo.FPS = new_fps
    @body.Timeline.Length = (@body.Timeline.Length * new_fps / ori_fps.to_f).ceil
    @body.Timeline.Items.each do |item|
      item.Length = (item.Length * new_fps / ori_fps.to_f).floor # 块长度（帧）
      item.Frame = (item.Frame * new_fps / ori_fps.to_f).floor  # 块在视频中出现的帧序，如 0
    end
    self
  end

  def set_wxh width, height, scale_mode: :min
    scale_mode = scale_mode.to_s

    ori_w = @body.Timeline.VideoInfo.Width
    ori_h = @body.Timeline.VideoInfo.Width
    @body.Timeline.VideoInfo.Width = width.to_i
    @body.Timeline.VideoInfo.Height = height.to_i

    scale_rate = case scale_mode
    when "min"
      [height/ori_w.to_f, width/ori_h.to_f].min
    when "max"
      [height/ori_w.to_f, width/ori_h.to_f].max
    else 1
    end
    @body.Timeline.Items.each do |item|
      item.X.Values.each { _1.Value = (_1.Value * ori_w / width).floor }  if item.X
      item.Y.Values.each { _1.Value = (_1.Value * ori_h / height).floor } if item.Y
      item.Zoom.Values.each { _1.Value *= scale_rate }                    if item.Zoom
    end
    self
  end

  # rescale YMMP resolution by rate.
  # apply for Every Items' `X`, `Y`, `Zoom`.
  # if `make_chara: false`, then Characters Attributes won't be change.
  def rescale scale_rate, make_chara: true
    ymmp = self
    ymmp.body.Timeline.VideoInfo.Width *= scale_rate
    ymmp.body.Timeline.VideoInfo.Height *= scale_rate
    ymmp.body.Timeline.Items.each do |item|
      item.X.Values.each { _1.Value = (_1.Value * scale_rate).floor } if item.X
      item.Y.Values.each { _1.Value = (_1.Value * scale_rate).floor } if item.Y
      item.Zoom.Values.each { _1.Value *= scale_rate }                if item.Zoom
    end
    ymmp.body.Characters.each do |item|
      item.X.Values.each { _1.Value = (_1.Value * scale_rate).floor } if item.X
      item.Y.Values.each { _1.Value = (_1.Value * scale_rate).floor } if item.Y
      item.Zoom.Values.each { _1.Value *= scale_rate }                if item.Zoom
      # item.FontSize.Values.each { _1.Value = (_1.Value * scale_rate).floor } if item.Zoom
    end if make_chara
    ymmp
  end

  attr_reader :body

  def inspect
    vinfo = @body.Timeline.VideoInfo
    lens = @body.Timeline.Length.to_f / vinfo.FPS
    len = ("%d:%02d:%02d" % [lens / 3600, lens % 3600 / 60, lens % 60])
      .gsub(/^0:/, "").gsub(/^0/, "")
      .gsub(/^0:/, "").gsub(/^0:/, "")
      .gsub(/^\d+$/){ _1 + "s"}
    "#<#{self.class} %dx%d %dfps %dHz len: %s
    from: %s>" % [vinfo.Width, vinfo.Height, vinfo.FPS, vinfo.Hz, len, @body.FilePath.inspect]
  end

  def to_json; JSON(self.class.os2h @body) end
  def output; JSON.pretty_generate(self.class.os2h @body) end
  def to_h; self.class.os2h @body end

end

class << YMM4::Project
  def load_file path
    hash = ::JSON.parse(File.read(path).gsub(/[\ufeff]/, ""))
    self.new(hash)
  end

  def h2os h
    case h
    when Hash
      OpenStruct.new(h.to_a.map{ [_1, h2os(_2)] }.to_h)
    when Array
      h.map{ h2os(_1) }
    else h
    end
  end

  def os2h os
    case os
    when OpenStruct
      os.to_h.map{ [_1, os2h(_2)] }.to_h
    when Hash
      os.to_a.map{ [_1, os2h(_2)] }.to_h
    when Array
      os.to_a.map{ os2h(_1) }
    else os
    end
  end
end
