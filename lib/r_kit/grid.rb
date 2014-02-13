module RKit::Grid
  def self.init!
    require "r_kit/grid/action_view_extension"
  
    ActionView::Base.send :include, ActionViewExtension
  end
end
