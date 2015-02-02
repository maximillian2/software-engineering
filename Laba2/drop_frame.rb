class DropFrame < Qt::Frame
  def initialize(parent = nil)
    super

    ## Initial cosmetic issues
    setFrameShape(Qt::Frame::Panel)
    setFrameShadow(Qt::Frame::Sunken)
    setAcceptDrops(true)
    setFixedHeight(50)

    ## Layout to hold buttons and group them to the left side
    @layout = Qt::HBoxLayout.new
    @layout.setAlignment(Qt::AlignLeft)
    setLayout(@layout)
  end

  ## Whether we dragging text information
  def dragEnterEvent(event)
    event.mimeData.hasText ? event.acceptProposedAction : event.ignore
  end

  ## Create label with dropped button's text
  def dropEvent(event)
    label = Qt::Label.new
    label.setText(event.mimeData.text)
    @layout.addWidget(label)
    puts event.mimeData.text

    # Move button from one frame to another
    event.setDropAction(Qt::CopyAction)
    event.accept
  end

  ## Get all widgets on layout as an array
  def elements
    array = []
    @layout.count.times { |i| array << @layout.itemAt(i).widget}
    array
  end

  def remove_from_layout(widget); @layout.removeWidget(widget); widget.close; end
end