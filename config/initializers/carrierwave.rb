def optimize
  manipulate! do |img|
      return img unless img.mime_type.match /image\/jpeg/
      img.strip
      img.combine_options do |c|
          c.quality "80"
          c.depth "8"
          c.interlace "plane"
          puts "------------------"*18
      end
      img
  end
end