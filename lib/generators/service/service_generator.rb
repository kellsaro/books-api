class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :module, type: :string

  def create_service_file
    @module_name = options[:module]

    @spaces = @module_name.present? ? '  ' : ''
    service_dir_path = 'app/services'
    generator_dir_path = service_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
    generator_path = generator_dir_path + "/#{file_name}_service.rb"

    Dir.mkdir(service_dir_path) unless File.exist?(service_dir_path)
    Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)

    template 'service_template.erb', generator_path
  end
end
