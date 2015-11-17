gif = ARGV[0]

`mkdir tmp/`
`convert -coalesce #{gif} tmp/frames-%03d.png`

frames = Dir.glob('tmp/frames-*.png')
darkest = 120
first = (frames.size * 2 / 3)
last = frames.size - 1
overlay_start = ((last - first) * 0.5) + first
step = darkest / first

width = `identify -format "%w" tmp/frames-000.png`.to_i
wasted_width = width/3
resized_wasted = `convert img/wasted.png -resize #{wasted_width}x tmp/wasted_sized.png`

(first..last).each do |i|
  img = 'tmp/frames-%03d.png' % i
  `convert #{img} -fill '#990000' -colorize #{step*(i-first+1)}% #{img}`
  `composite -gravity center tmp/wasted_sized.png #{img} #{img}` if i >= overlay_start
end

`convert tmp/frames-*.png output/#{File.basename(gif)}`
`rm -rf tmp`
