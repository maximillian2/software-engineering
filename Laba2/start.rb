require 'Qt'
require_relative 'main_ui'

class Start < Qt::MainWindow
	slots 'select_letters()', 'reset_all()'
	def initialize
		super
		@ui = Ui_MainWindow.new
		@ui.setupUi(self)

		@ui.tableWidget.verticalHeader.hide
		@ui.tableWidget.horizontalHeader.hide
		# @ui.tableWidget.horizontalHeaderStretchLastSection
		@selected_letters = Array.new

		# @ui.pushButton.setText("This table has #{count} cells")
		Qt::Object.connect(@ui.pushButton, SIGNAL('clicked()'), self, SLOT('select_letters()'))
		Qt::Object.connect(@ui.reset_button, SIGNAL('clicked()'), self, SLOT('reset_all()'))
	end

	def select_letters
		@selected_letters = @ui.tableWidget.selectedItems
		## make here 2 vars to hold rows & columns

		## Static numbers to increase performance
		7.times do |i| 		#=> rows
			4.times do |j|	#=> columns
				current_item = @ui.tableWidget.item(i, j)
				unless current_item.nil?
					if @selected_letters.include?(current_item)
						current_item.setBackground(Qt::Brush.new(Qt::yellow))
					else
						current_item.setBackground(Qt::Brush.new(Qt::white))
					end
				end
			end
		end

		@ui.tableWidget.reset
		@ui.pushButton.setText("Selected #{@selected_letters.count} letters.")
		@selected_letters.clear
		@ui.pushButton.setEnabled(false)
	end

	def reset_all
		@ui.pushButton.setText('Let the battle begins!')
		@ui.pushButton.setEnabled(true)
		@selected_letters.clear

		7.times do |i|
			4.times do |j|
				@ui.tableWidget.item(i, j).setBackground(Qt::Brush.new(Qt::white)) unless @ui.tableWidget.item(i, j).nil?
			end
		end
	end
end

if $0 == __FILE__
  app = Qt::Application.new(ARGV)
  myapp = Start.new
  myapp.show
  app.exec
end
