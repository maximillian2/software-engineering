require 'Qt'
require 'unicode' # => read non-latin letters
require_relative 'drag_button'
require_relative 'drop_frame'

class Main < Qt::Widget
  slots 'check_word()', 'reload_letters()'

  ## Wrapper to look prettier
  def add(button); button; end

  def initialize(parent = nil)
    super
    ## First label
    @welcome_label = Qt::Label.new
    @welcome_label.setTextFormat(Qt::RichText)            # => activate rich text mode
    @welcome_label.setText('<b>Available letters: </b>')  # => to make text bold
    @welcome_label.setAlignment(Qt::AlignCenter)          # => and center it

    ## Layout to hold inherited drag buttons
    @button_layout = Qt::HBoxLayout.new
    10.times { add(DragButton.new(('А'...'Я').to_a[rand(31)])).to(@button_layout) }

    ## Frame to hold layout that holds buttons
    @button_frame = Qt::Frame.new
    @button_frame.setFrameShape(Qt::Frame::Panel)   # => some decoration options
    @button_frame.setFrameShadow(Qt::Frame::Sunken) # => to look prettier
    @button_frame.setLayout(@button_layout)

    ## Second label
    @drop_label = Qt::Label.new
    @drop_label.setTextFormat(Qt::RichText)         # => activate rich text mode
    @drop_label.setText('<b>Drop the bass: </b>')   # => to make text bold
    @drop_label.setAlignment(Qt::AlignCenter)       # => and center it

    ## Inherited frame to hold dropped buttons
    @drop_frame = DropFrame.new

    ## Button to call word check
    @check_word_button = Qt::PushButton.new('Check the bass!')
    ## Button to reload dragbuttons' contents
    @reload_button = Qt::PushButton.new('Reload')

    ## Connect buttons signals to corresponding slots
    Qt::Object.connect(@check_word_button, SIGNAL('clicked()'), self, SLOT('check_word()'))
    Qt::Object.connect(@reload_button, SIGNAL('clicked()'), self, SLOT('reload_letters()'))

    ## Layout to hold horizontally 2 buttons and frame
    @drop_check_layout = Qt::HBoxLayout.new
    @drop_check_layout.addWidget(@drop_frame)
    @drop_check_layout.addWidget(@check_word_button)
    @drop_check_layout.addWidget(@reload_button)

    ## Score counter
    @lcd = Qt::LCDNumber.new
    @lcd.segmentStyle = Qt::LCDNumber::Flat   # => more prettier with this
    @lcd.display(0)                           # => initial value

    ## Main window layout
    @vertical_layout = Qt::VBoxLayout.new
    @vertical_layout.addWidget(@welcome_label)
    @vertical_layout.addWidget(@button_frame)
    @vertical_layout.addWidget(@drop_label)
    @vertical_layout.addLayout(@drop_check_layout)
    @vertical_layout.addWidget(@lcd)
    self.setLayout(@vertical_layout)
  end

  ## Check words with dictionary and maintains the score
  def check_word
    @result_array = @drop_frame.elements
    @word = Unicode.downcase(@result_array.map(&:text).join.force_encoding('UTF-8'))

    ## Dictionary contains non-empty words
    if File.read('dictionary.txt').include?(@word) && !@word.empty?
      ## Add to score number of which word consists
      @lcd.display(@lcd.value + @word.size)
    else
      ## Otherwise remove one
      @lcd.display(@lcd.value - 1)
    end

    invisible_buttons = []
    @button_layout.count.times { |i| invisible_buttons << @button_layout.itemAt(i).widget }
    invisible_buttons.delete_if { |i| i.isVisible }

    invisible_buttons.each do |button|
      @button_layout.removeWidget(button)
    end

    ## Add buttons so there is always constant number of buttons (e.g. 10)
    ## Syntax sugar: add(button).to(layout)
    (10-@button_layout.count).times { add(DragButton.new(('А'...'Я').to_a[rand(31)])).to(@button_layout) }

    ## Clear frame with dropped buttons
    @result_array.map{ |i| @drop_frame.remove_from_layout(i) }
    @result_array.clear
  end

  ## Reload all letters in button layout
  def reload_letters
    @button_layout.count.times do |i|
      @button_layout.itemAt(i).widget.setText(('А'...'Я').to_a[rand(31)])
    end
    ## Decrease score by 1 as a hint
    @lcd.display(@lcd.value - 1)
  end
end

if $0 == __FILE__
  app = Qt::Application.new(ARGV)
  myapp = Main.new
  myapp.show
  app.exec
end