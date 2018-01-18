module SimpleForm
  module Components
    module Icons
      def icon(wrapper_options = nil)
        icon_class unless options[:icon].nil?
      end

      def icon_class
        template.content_tag(
            :span,
            template.content_tag(:i, '', class: options[:icon]).html_safe,
            class: 'input-group-text'
        )
      end
    end

    module Units
      def unit(wrapper_options = nil)
        template.content_tag(:span, options[:unit], class: 'input-group-text') unless options[:unit].nil?
      end
    end

    module FileLabels
      def file_label(wrapper_options = nil)
        template.content_tag(:label, options[:file_label], class: 'custom-file-label') unless options[:file_label].nil?
      end
    end

    module RadioLabels
      def radio_label(wrapper_options = nil)
        span_label unless options[:radio_label].nil? || options[:radio_for].nil?
      end

      def span_label
        template.content_tag(:label, options[:radio_label], class: 'custom-control-label', for: options[:radio_for])
      end
    end
  end
end

SimpleForm::Inputs::Base.send(
    :include,
    SimpleForm::Components::Icons,
    SimpleForm::Components::Units,
    SimpleForm::Components::FileLabels,
    SimpleForm::Components::RadioLabels
)