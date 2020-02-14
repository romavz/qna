module ControlsHelper
  def add_controls_for(content, path)
    render('shared/controls', path: path) if current_user&.author?(content)
  end
end
