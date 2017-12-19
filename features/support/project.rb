class Project

  attr_accessor :project_id
  attr_accessor :environments
  attr_accessor :project_name

  def initialize(project)
    @project_id = project['id']
    @project_name = project['name']
    @environments = []
  end
end