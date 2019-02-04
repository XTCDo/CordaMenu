require 'watir'
require 'nokogiri'

# Use watir to get a browser so AJAX can do its thing
browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600']}})

# Go to corda latte website
browser.goto("https://cordalatte.klikeneet.be/")
# Wait for ajax to load
sleep 0.5

# Store the page so it can be parsed with nokogiri
file = File.new('cordamenu.html', "w")
file.puts(browser.html)
file.close

# No longer need watir browser
browser.close

# Open page with nokogiri and make sure we only
# have relevant information
page = Nokogiri::HTML(open("cordamenu.html"))
page = page.css('tbody#products_list td')
page.css('small').remove
page.css('category-td').remove

# Get the menu items out of the remaining html
menu_items = page.select{ |element| element.to_s.start_with?("<td style")}
# Turn menu items into text
menu_items = menu_items.map{ |element| element.text}

# prices are inside buttons so get them out of there
prices = page.css('button').map{|element| element.text}

# Need size of menu to iterate through both menu_items and prices
menu_length = menu_items.length

# Need length of longest menu item for padding
longest_menu_item_length = menu_items.sort_by{|item| item.length}[menu_length - 1].length

# Print all menu items with price
for i in 0..menu_length-1
    # Calculate padding size 
    pad_length = longest_menu_item_length - menu_items[i].length
    
    # Pad with spaces
    padding = " " * (pad_length + 1)
    
    # Print the string
    puts menu_items[i] + padding + prices[i][1..-1]
end