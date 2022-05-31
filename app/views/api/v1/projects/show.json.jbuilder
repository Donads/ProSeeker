json.data do
  json.project do
    json.call(
    @project,
    :title,
    :description
    )
    json.status @project.status
  end
end
