class DragButton < Qt::PushButton
  def initialize(parent = nil)
    super
    setFixedSize(50, 30)
  end

  ## When pressing mouse key, create mimedata that contains button's text
  def mousePressEvent(event)
    mimeData = Qt::MimeData.new
    mimeData.text = self.text

    drag = Qt::Drag.new(self)
    drag.mimeData = mimeData

    dropAction = drag.start(Qt::CopyAction)

    close if dropAction == Qt::CopyAction
  end

  ## Make add buttons to layout a little more prettier
  def to(layout); layout.addWidget(self); end
end