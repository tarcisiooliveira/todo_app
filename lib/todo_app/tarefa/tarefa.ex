defmodule TodoApp.Tarefa do
  use Ecto.Schema
  import Ecto.Changeset

  schema("tarefas") do
    field :titulo, :string
    field :pronta, :string
  end

  @doc """
  iex> tarefa = %TodoApp.Tarefa{}
    %TodoApp.Tarefa{
      __meta__: #Ecto.Schema.Metadata<:built, "tarefas">,
      id: nil,
      pronta: nil,
      titulo: nil
    }
  iex> params = %{tarefa: "titulo do tarefa", pronta: true}
    %{pronta: true, tarefa: "titulo do tarefa"}
  iex> TodoApp.Tarefa.changeset(tarefa, params)
    #Ecto.Changeset<
      action: nil,
      changes: %{pronta: true},
      errors: [titulo: {"can't be blank", [validation: :required]}],
      data: #TodoApp.Tarefa<>,
      valid?: false
    >
  """
  def changesetParaStructGravarBanco(struct, params \\ %{}) do
    struct
    # prepara os dados para o banco
    |> cast(params, [:titulo, :pronta])
    # valida os dados para o banco
    |> validate_required([:titulo, :pronta])
  end
end
