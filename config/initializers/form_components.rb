module SimpleForm
  module Components
    module Icons
      def icon(wrapper_options = nil)
        icon_class unless options[:icon].nil?
      end

      def icon_class
        template.content_tag(:i, '', class: options[:icon])
      end
    end

    module Units
      def unit(wrapper_options = nil)
        options[:unit] unless options[:unit].nil?
      end
    end

    module RadioLabels
      def radio_label(wrapper_options = nil)
        indicator + span_label unless options[:radio_label].nil?
      end

      def indicator
        template.content_tag(:span, '', class: 'custom-control-indicator')
      end

      def span_label
        template.content_tag(:span, options[:radio_label], class: 'custom-control-description')
      end
    end
  end
end

SimpleForm::Inputs::Base.send(
    :include,
    SimpleForm::Components::Icons,
    SimpleForm::Components::Units,
    SimpleForm::Components::RadioLabels
)