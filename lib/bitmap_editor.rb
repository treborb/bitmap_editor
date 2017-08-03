require_relative 'bitmap'
require_relative 'parser'
require_relative 'file_reader'
require_relative 'error_handler'
require_relative 'cli'

class BitmapEditor

  include FileReader

  def run(file)
    read(file)
  end

  private

  attr_reader :image

  def execute(command, params)
    begin
      CLI.interpreter(command)
      params.empty? ? send(command) : send(command, params)
    rescue
      ErrorHandler.error('Unrecognised command :(')
    end
  end

  def create(params)
    cols, rows = params
    @image = Bitmap.new(cols + 1, rows + 1)
  end

  def colour_pixel(params)
    x, y, c = params
    image[x,y] = c
  end

  def colour_column(params)
    x, y1, y2, c = params
    image.fill_column(x, y1, y2, c)
  end

  def colour_row(params)
    x1, x2, y, c = params
    image.fill_row(x1, x2, y, c)
  end

  def show
    fail unless image_exists?
    CLI.output(image.show)
  rescue
    ErrorHandler.error('There is no image')
  end

  def clear
    fail unless image_exists?
    image.clear
    CLI.output('Image cleared')
  rescue
    ErrorHandler.error('There is no image')
  end

  def image_exists?
    !!image
  end

end
