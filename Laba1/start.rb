require 'Qt'
require_relative 'main_ui'
require_relative 'result'

class Start < Qt::MainWindow
	slots 'toucan_clicked()'

	def initialize
		super
		@ui = Ui_MainWindow.new
		@ui.setupUi(self)

		## Array to check every answer
		@pass = [] #=> bool

		## Click button event connector
		Qt::Object.connect(@ui.pushButton, SIGNAL('clicked()'), self, SLOT('toucan_clicked()'))
	end

	def toucan_clicked
		## Need to clean in order to get correct result table
		@pass.clear
		## Check first groupbox, just second button
		@pass << @ui.tabWidget.widget(0).findChildren(Qt::RadioButton)[1].isChecked
		## Find checkbox elements on current page and save them to array
		@arr = @ui.tabWidget.widget(0).findChildren(Qt::CheckBox)
		## Check second groupbox with 2 correct answer numbers
		@pass << @arr[1].isChecked && @arr[2].isChecked #=> true
		## Check lineedit emptiness with magic answer word
		@pass << (@ui.lineEdit.text.downcase == 'null') #=> true
		## Check combobox with magic 'correct' number
		@pass << (@ui.comboBox.currentIndex == 2)				#=> true
		## Check listWidget with magic 'correct' number
		@pass << (@ui.listWidget.currentRow == 3)				#=> true
		## Create new window, make it modal
		@result = Result.new(self, @pass)
		## And show it up
		@result.exec
	end
end

if $0 == __FILE__
  app = Qt::Application.new(ARGV)
  myapp = Start.new
  myapp.show
  app.exec
end
