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
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Icons, SimpleForm::Components::Units)