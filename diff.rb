require 'chunky_png'

def diff
  puts "Diff starting..."

  images = [
    ChunkyPNG::Image.from_file('data/screenshot.png'),
    ChunkyPNG::Image.from_file('data/screenshot_old.png'),
  ]

  diff = []

  images.first.height.times do |y|
    images.first.row(y).each_with_index do |pixel, x|
      diff << [x,y] unless pixel == images.last[x,y]
    end
  end

  puts "pixels (total):     #{images.first.pixels.length}"
  puts "pixels changed:     #{diff.length}"
  puts "pixels changed (%): #{(diff.length.to_f / images.first.pixels.length) * 100}%"

  x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

  images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
  images.last.save('data/diff.png')

  puts "Diff ended."
end

diff
