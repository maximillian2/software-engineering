class Result < Qt::Dialog
  def initialize(parent = nil, array)
    super(parent)

    ## Make window modal
    self.setModal(true)
    ## Layout to hold page widgets
    @vbox = Qt::VBoxLayout.new

    @result_label = Qt::Label.new('Result')
    ## Move label to the center of layout
    @result_label.setAlignment(Qt::AlignHCenter)

    ## Table with only 1 row with 5 columns
    result_table = Qt::TableWidget.new(1, 5)
    ## Hide number counter in the right side of table
    result_table.verticalHeader.hide

    ## Hold correct answers here
    correct_answers = 0
    ## Get correct answers into variable
    array.each { |i| correct_answers += 1 if i }
    ## And set button text to show info about number of correct answers
    @exit_button = Qt::PushButton.new("You have #{correct_answers} out of 5!")

    ## Prepare widgets in layout
    @vbox.addWidget(@result_label)
    @vbox.addWidget(result_table)
    @vbox.addWidget(@exit_button)

    ## Add items into table and color them
    array.length.times do |i|
      item = Qt::TableWidgetItem.new('')
      ## Correct => green, otherwise => red
      item.setBackground(Qt::Brush.new(array[i] ? Qt::green : Qt::red))
      result_table.setItem(0, i, item)
    end

    ## Make table columns stretch to area to look good
    result_table.horizontalHeader.setResizeMode(Qt::HeaderView::Stretch)
    ## Close button connector
    Qt::Object.connect(@exit_button, SIGNAL('clicked()'), self, SLOT('accept()'))
    ## Set widgets in layout
    setLayout(@vbox)
    ## Manual resizing of window to fit the table
    resize(320, 75)
  end
end