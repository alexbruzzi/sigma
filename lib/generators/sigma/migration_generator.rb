module MigrationGenerator
  def generate_migrations
    generate("migration", "add_skill_to_#{@model_name.pluralize} skill:float")
    generate("migration", "add_doubt_to_#{@model_name.pluralize} doubt:float")
    generate("migration", "add_wins_to_#{@model_name.pluralize} wins:integer")
    generate("migration", "add_losses_to_#{@model_name.pluralize} losses:integer")
    generate("migration", "add_draws_to_#{@model_name.pluralize} draws:integer")
    generate("migration", "add_expectations_to_#{@model_name.pluralize} expectations:string")
  end

  def set_default_values
    migrations = Dir.entries("db/migrate")
    migrations.each do |m|
      name = m.split(/^[0-9]+_/)[1]
      if name == "add_skill_to_#{@model_name.pluralize}.rb"
        inject_into_file  "db/migrate/#{m}",
                          ", :default => #{@scale/2}",
                          :after => ":float"
      elsif name == "add_doubt_to_#{@model_name.pluralize}.rb"
        inject_into_file  "db/migrate/#{m}",
                          ", :default => #{@scale/6}",
                          :after => ":float"
      elsif name == "add_expectations_to_#{@model_name.pluralize}.rb"
        inject_into_file  "db/migrate/#{m}",
                          ", :default => {'win_expectation'=>[0,0,0],'lost_expectation'=>[0,0,0],'draw_expectation'=>[0,0,0]}",
                          :after => ":string"
      elsif name == "add_wins_to_#{@model_name.pluralize}.rb" || name == "add_losses_to_#{@model_name.pluralize}.rb" || name == "add_draws_to_#{@model_name.pluralize}.rb"
        inject_into_file  "db/migrate/#{m}",
                          ", :default => 0",
                          :after => ":integer"
      end
    end
  end

  def migrate
    puts <<-EOS

=======================================
> Running rake db:migrate
=======================================

    EOS
    rake("db:migrate")
  end
end