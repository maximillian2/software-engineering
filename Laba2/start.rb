require 'Qt'
require_relative 'main_ui'

# class Array
#   def shrink(count)
#     while self.size > count
#       self.pop
#     end
#     self
#   end
# end

class Start < Qt::MainWindow
	def initialize
		super
		@ui = Ui_MainWindow.new
		@ui.setupUi(self)

    @ui.letter_frame.findChildren(Qt::PushButton).each { |i| i.setText(('А'...'Я').to_a[rand(31)]) }
	end

	def reset_all
		@ui.pushButton.setText('Start!')
		@ui.pushButton.setEnabled(true)
		@selected_letters.clear
  end
end

if $0 == __FILE__
  app = Qt::Application.new(ARGV)
  myapp = Start.new
  myapp.show
  app.exec
end
