class DragButton < Qt::PushButton
  def initialize(parent = nil)
    super
    setFixedSize(50, 30)
    # setAttribute(Qt::WA_DeleteOnClose)
  end

  def mousePressEvent(event)
    mimeData = Qt::MimeData.new
    mimeData.text = self.text

    drag = Qt::Drag.new(self)
    drag.mimeData = mimeData

    dropAction = drag.start(Qt::CopyAction)
    if dropAction == Qt::CopyAction
      close
      # update
    end
  end

  def to(layout); layout.addWidget(self); end
end