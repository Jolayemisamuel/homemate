PDFKit.configure do |config|
  config.default_options = {
      :margin_top => '0',
      :margin_bottom => '0',
      :margin_left => '0',
      :margin_right => '0',
      :page_size => 'A4',
      :enable_forms => true,
      :print_media_type => true
  }
end