require 'Qt'
require 'unicode'

require_relative 'drag_button'
require_relative 'drop_frame'

class Main < Qt::Widget
  slots 'check_word()', 'reload_letters()'

  def add(button); button; end

  def initialize(parent = nil)
    super

    @welcome_label = Qt::Label.new
    @welcome_label.setTextFormat(Qt::RichText)            # => activate rich text mode
    @welcome_label.setText('<b>Available letters: </b>')  # => to make text bold
    @welcome_label.setAlignment(Qt::AlignCenter)          # => and center it

    @button_layout = Qt::HBoxLayout.new
    10.times { add(DragButton.new(('А'...'Я').to_a[rand(31)])).to(@button_layout) }

    @button_frame = Qt::Frame.new
    @button_frame.setFrameShape(Qt::Frame::Panel)
    @button_frame.setFrameShadow(Qt::Frame::Sunken)
    @button_frame.setLayout(@button_layout)

    p 'Buttons: ' + @button_frame.findChildren(DragButton).size.to_s
    @drop_label = Qt::Label.new
    @drop_label.setTextFormat(Qt::RichText)
    @drop_label.setText('<b>Drop the bass: </b>')
    @drop_label.setAlignment(Qt::AlignCenter)

    @drop_frame = DropFrame.new

    @check_word_button = Qt::PushButton.new('Check the bass!')
    Qt::Object.connect(@check_word_button, SIGNAL('clicked()'), self, SLOT('check_word()'))

    @reload_button = Qt::PushButton.new('Reload')
    Qt::Object.connect(@reload_button, SIGNAL('clicked()'), self, SLOT('reload_letters()'))

    @drop_check_layout = Qt::HBoxLayout.new
    @drop_check_layout.addWidget(@drop_frame)
    @drop_check_layout.addWidget(@check_word_button)
    @drop_check_layout.addWidget(@reload_button)

    @lcd = Qt::LCDNumber.new
    @lcd.segmentStyle = Qt::LCDNumber::Flat
    @lcd.display(0)

    @vertical_layout = Qt::VBoxLayout.new
    @vertical_layout.addWidget(@welcome_label)
    @vertical_layout.addWidget(@button_frame)
    @vertical_layout.addWidget(@drop_label)
    @vertical_layout.addLayout(@drop_check_layout)
    @vertical_layout.addWidget(@lcd)
    self.setLayout(@vertical_layout)
  end

  def check_word
    @result_array = @drop_frame.elements
    p 'Found ' + @result_array.size.to_s + ' labels in drop_frame'
    @word = Unicode.downcase(@result_array.map(&:text).join.force_encoding('UTF-8'))

    if File.read('dictionary.txt').include?(@word) && !@word.empty?
      @lcd.display(@lcd.value + @word.size)
    else
      @lcd.display(@lcd.value - 1)
    end

    # invisible_buttons = @button_frame.findChildren(DragButton).delete_if { |i| i.isVisible }
    invisible_buttons = []
    @button_layout.count.times { |i| invisible_buttons << @button_layout.itemAt(i).widget }
    invisible_buttons.delete_if { |i| i.isVisible }
    p 'Found ' + invisible_buttons.size.to_s + ' dragged buttons'

    invisible_buttons.each do |button|
      @button_layout.removeWidget(button)
      # invisible_buttons.delete(button)
      p 'Removing buttons from layout'
      # button.close
    end

    p 'Layout contents: ' + @button_layout.count.to_s
    p 'Gonna add ' + @result_array.size.to_s + ' letters'
    (10-@button_layout.count).times { add(DragButton.new(('А'...'Я').to_a[rand(31)])).to(@button_layout) }
    # invisible_buttons.clear

    @result_array.map{ |i| @drop_frame.remove_from_layout(i) }
    @result_array.clear
  end

  def reload_letters
    @button_layout.count.times do |i|
      @button_layout.itemAt(i).widget.setText(('А'...'Я').to_a[rand(31)])
    end
    @lcd.display(@lcd.value - 1)
  end
end

if $0 == __FILE__
  app = Qt::Application.new(ARGV)
  myapp = Main.new
  myapp.show
  app.exec
end