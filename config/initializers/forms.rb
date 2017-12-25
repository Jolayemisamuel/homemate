# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-primary'
  config.boolean_label_class = nil

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-form-label'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'col-form-label'

    b.use :input
    b.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-form-label'
    b.use :input
    b.use :error, wrap_with: { tag: 'small', class: 'form-text text-danger text-muted' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group row', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group row', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group row', error_class: 'is-invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'offset-sm-3 col-sm-9' do |wr|
      wr.wrapper tag: 'label', class: 'custom-control custom-checkbox' do |ba|
        ba.use :input, class: 'custom-control-input'
        ba.use :radio_label
      end

      wr.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback d-block' }
      wr.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group row', error_class: 'is-invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-sm-3 col-control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :multi_select, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label
    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :input, class: 'custom-select'
      ba.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.wrappers :horizontal_multiselect, tag: 'div', class: 'form-group row', error_class: 'is-invalid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'
    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input, class: 'custom-select'
      ba.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.wrappers :input_group_form, tag: 'div', class: 'form-group', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper tag: 'div', class: 'input-group' do |ba|
      ba.use :icon, wrap_with: { tag: 'span', class: 'input-group-addon' }
      ba.use :input, class: 'form-control'
    end

    b.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback d-block' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :horizontal_input_group, tag: 'div', class: 'form-group row', error_class: 'is-invalid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-3 col-form-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |g|
        g.optional :icon, wrap_with: { tag: 'span', class: 'input-group-addon' }
        g.use :input, class: 'form-control'
        g.optional :unit, wrap_with: { tag: 'span', class: 'input-group-addon' }
      end

      ba.use :error, wrap_with: { tag: 'small', class: 'invalid-feedback d-block' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end

  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :vertical_file_input,
    boolean: :vertical_boolean,
    datetime: :multi_select,
    date: :multi_select,
    time: :multi_select
  }
end
