module ModelUpdater
  def add_methods
    resource = File.read find_in_source_paths("resource_model.rb")
    inject_into_file  "app/models/#{@model_name}.rb",
                      ":skill, :doubt, :wins, :losses, :draws, :expectations, ",
                      :after => "attr_accessible "
    inject_into_file  "app/models/#{@model_name}.rb",
                      "\n#{resource}\n",
                      :after => /attr_accessible [a-z:_, ]+$/
  end

  def creating_templates
    template "sigma.rb", "config/initializers/sigma.rb"
  end
end