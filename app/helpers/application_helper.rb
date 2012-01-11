#require 'yaml'

module ApplicationHelper
  
  def js_array_string(fullArray, excludeItem)
  
    inner = fullArray.collect { |item| "\'" + item + "\'" unless item  == excludeItem}.delete_if { |item| item.nil? }.join(", ")
	return "[" + inner + "]"
  end
  
  # get the quote of the week
  def qotw
    q_content = Configuration.find_by_key('quote-content')
	q_source = Configuration.find_by_key('quote-source')
    { :content => q_content.nil? ? '' : q_content.value, :source => q_source.nil? ? '' : q_source.value }
  end
  
  def logo
    image_tag("logo.png", :alt => "Run 500 Miles", :class => "round")
  end
  
  def progress_bar(progress,options={})  
   width = options[:width] || 500  
   height = options[:height] || 20  
   bg_color=options[:bg_color] || "#DDD"  
   bar_color=options[:bar_color] || "#6A5ACD" 
   bar_max=options[:bar_max] || 100   
   text = options[:text]  
   if text  
     height = 20 unless height>=20  
     text_color = options[:text_color] || "white"       
     text_content = content_tag(:span,text,:style=>"margin-right: 3px; color: #{text_color};")  
   end       
   style1 = "width: #{width}px; background: #{bg_color}; border: 1px solid black; height: #{height}px;"  
   style2 = "text-align: right; float: left; background: #{bar_color}; width: #{progress*width/bar_max}px; height: #{height}px"  
   content_tag(:div, content_tag(:div,text_content,:style=>style2),:style=>style1)  
 end  
  
  # Return a title on a per-page basis
  def title
    base_title = "Run 500 Miles"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
end
