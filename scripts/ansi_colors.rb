################################################################################
# ansi_colors.rb
#  Script to create an iTerm color palette using colors defined below.
################################################################################
require 'nokogiri'

# My terminal colors are based off of LinkedIn's palette, with some minor tweaks
# https://brand.linkedin.com/visual-identity/color-palettes
alt_linkedin = {
  black: [0, 0, 0],
  red: [255, 10, 0],
  green: [96, 201, 0],
  yellow: [255, 190, 0],
  blue: [0, 160, 255],
  magenta: [255, 0, 118],
  cyan: [0, 184, 193],
  purple: [125, 64, 178],
  orange: [255, 111, 0],
  light_grey: [182, 185, 188],
  dark_grey: [89, 92, 95],
  light_red: [255, 10, 0],
  light_green: [96, 201, 0],
  light_yellow: [255, 190, 0],
  light_blue: [0, 160, 255],
  light_magenta: [255, 0, 118],
  light_cyan: [0, 184, 193],
  light_purple: [125, 64, 178],
  light_orange: [255, 111, 0],
  white: [255, 255, 255]
}

################################################################################
# Color Conversion
################################################################################
def ansi_to_rgb(color)
  r = (color[0]*255).to_i
  g = (color[1]*255).to_i
  b = (color[2]*255).to_i
  [r, g, b]
end

def rgb_to_ansi(color)
  r = (color[0].to_f)/255
  g = (color[1].to_f)/255
  b = (color[2].to_f)/255
  [r, g, b]
end

def build_from_rgb(colors)
  colors.collect do |k, v|
    { name: k, rgb: v, ansi: rgb_to_ansi(v) }
  end
end

def build_from_ansi(colors)
  colors.collect do |k, v|
    { name: k, rgb: ansi_to_rgb(v), ansi: v }
  end
end

################################################################################
# Output Generation
################################################################################
def to_html(name, colors)
  File.open("#{name}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.html", 'w+') do |f|
    f.puts "
      <html>
        <head>
          <style>
            body {
              font-family:Arial;
              background: url(http://subtlepatterns.com/patterns/fabric_plaid.png);
            }
            h1 {
              text-align:center;
            }
            table {
              margin:auto;
              width: 600px;
            }
            th,td {
              text-align:center;
            }
          </style>
        </head>
        <body>
          <h1>Color Conversion Table</h1>
          <table style=\"width:600px;\">"
    f.puts "
            <tr>
              <th><strong>color</strong></th>
              <th><strong>ansi</strong></th>
              <th><strong>rgb</strong></th>
              <th><strong>display</strong></th>
            </tr>"
    colors.each do |color|
      f.puts "
            <tr>
              <td>#{color[:name]}</td>
              <td>#{color[:ansi].collect{|a|a.round(2)}.join(', ')}</td>
              <td>#{color[:rgb].join(', ')}</td>
              <td style=\"background-color:rgb(#{color[:rgb].join(',')});\"></td>
            </tr>"
    end
    f.puts "
          </table>
        </body>
      </html>"
  end
end

def to_term(name, colors)
  File.open("#{name}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.itermcolors", 'w') do |f|
    f.puts '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>'

    colors.each do |color|
      f.puts "  <key>#{color[:name].to_s.split('_').collect(&:capitalize).join(' ')}</key>
  <dict>
    <key>Blue Component</key>
    <real>#{color[:ansi][2]}</real>
    <key>Green Component</key>
    <real>#{color[:ansi][1]}</real>
    <key>Red Component</key>
    <real>#{color[:ansi][0]}</real>
  </dict>"
    end
    f.puts '</dict>
</plist>'
  end
end

################################################################################
# Import an existing iTerm palette
################################################################################
def from_term(file)
  result = {}
  xml_string = File.open(file, "r"){ |x| x.read.gsub(/\n|\t/,'') }
  xml_parent = Nokogiri::XML(xml_string).xpath('/plist/dict')

  # Grab all the color names in <key>
  names_list = xml_parent.xpath('./key').collect(&:text)

  # Grab all the color definitions <dict>
  color_dict = xml_parent.xpath('./dict')
  color_list = color_dict.inject([]) do |memo, dict|
    c = dict.xpath('real')
    memo << [
      c[2].text.to_f,
      c[1].text.to_f,
      c[0].text.to_f ]
  end

  # Create a hash of names to colors
  colors = names_list.zip(color_list).inject({}) do |memo, color|
    memo[color.first] = color.last
    memo
  end

  # Return w/ conversions
  build_from_ansi(colors.sort)
end

################################################################################
# Initialization
################################################################################

=begin
         Ansi 0 Color --> black
         Ansi 1 Color --> red
         Ansi 2 Color --> green
         Ansi 3 Color --> yellow
         Ansi 4 Color --> blue
         Ansi 5 Color --> magenta
         Ansi 6 Color --> cyan
         Ansi 7 Color --> white (light grey)
         Ansi 8 Color --> light black (dark grey)
         Ansi 9 Color --> light red
        Ansi 10 Color --> light green
        Ansi 11 Color --> light yellow
        Ansi 12 Color --> light blue
        Ansi 13 Color --> light magenta
        Ansi 14 Color --> light cyan
        Ansi 15 Color --> white

     Background Color --> grey
           Bold Color --> white
    Cursor Text Color --> light grey
     Foreground Color --> light grey
  Selected Text Color --> black
      Selection Color --> medium blue
=end

alt_linkedin_ansi = {
       ansi_0_color: alt_linkedin[:black],
       ansi_1_color: alt_linkedin[:red],
       ansi_2_color: alt_linkedin[:green],
       ansi_3_color: alt_linkedin[:yellow],
       ansi_4_color: alt_linkedin[:blue],
       ansi_5_color: alt_linkedin[:magenta],
       ansi_6_color: alt_linkedin[:cyan],
       ansi_7_color: alt_linkedin[:light_grey],
       ansi_8_color: alt_linkedin[:dark_grey],
       ansi_9_color: alt_linkedin[:red],
      ansi_10_color: alt_linkedin[:light_green],
      ansi_11_color: alt_linkedin[:light_yellow],
      ansi_12_color: alt_linkedin[:light_blue],
      ansi_13_color: alt_linkedin[:light_magenta],
      ansi_14_color: alt_linkedin[:light_cyan],
      ansi_15_color: alt_linkedin[:white],
   background_color: alt_linkedin[:black],
         bold_color: alt_linkedin[:white],
       cursor_color: alt_linkedin[:light_grey],
  cursor_text_color: alt_linkedin[:white],
   foreground_color: alt_linkedin[:light_grey],
selected_text_color: alt_linkedin[:black],
    selection_color: alt_linkedin[:white]
}

colors = build_from_rgb(alt_linkedin_ansi)
to_html('linkedin-iterm-colors', colors)
to_term('linkedin-iterm-colors', colors)
