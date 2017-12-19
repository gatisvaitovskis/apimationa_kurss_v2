class Project

  attr_accessor :project_id
  attr_accessor :environments

  def initialize(project_id)
    @project_id = project_id
    @environments = []
  end
end