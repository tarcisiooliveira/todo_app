defmodule TodoAppWeb.TarefaController do
  use TodoAppWeb, :controller

  import Ecto.Repo
  alias TodoApp.Tarefa
  alias TodoApp.Repo

  def new(conn, _params) do
    changeset_criado = Tarefa.changesetParaStructGravarBanco(%Tarefa{})
    render(conn, "new.html", changeset: changeset_criado)
  end

  def create(conn, params) do
    tipoEstrutura = %Tarefa{}
    %{"tarefa" => tarefa} = params
    changeset = Tarefa.changesetParaStructGravarBanco(tipoEstrutura, tarefa)


    case Repo.insert(changeset) do
      {:ok, struct} ->

        conn
        |> put_flash(:info, "Tarefa incluida com sucesso: #{struct.titulo}")
        |> redirect(to: Routes.tarefa_path(conn, :index), changeset: changeset)

      # |> render("index.html", tarefa)antiga versão
      {:error, _changeset} ->
        render(conn, "index.html", tarefas: TodoApp.Repo.all(Tarefa))
    end
  end

  def index(conn, _params) do
    IO.inspect(conn)
    render(conn, "index.html", tarefas: Repo.all(Tarefa))
  end

  def edit(conn, params) do
    %{"id" => tarefa_id} = params

    tarefa_retorno_banco = Repo.get!(Tarefa, tarefa_id)

    changeset = Tarefa.changesetParaStructGravarBanco(tarefa_retorno_banco)

    render(conn, "edit.html", changeset: changeset, tarefas: tarefa_retorno_banco)
  end

  def update(conn, params) do

    %{"tarefa"=>tarefa, "id"=> id} = params
    atributo_antigo=Repo.get(Tarefa, id)
    changeset = Tarefa.changesetParaStructGravarBanco(atributo_antigo,tarefa)

    case Repo.update(changeset) do
      {:ok, _struct} ->
        conn
        |> put_flash(:info, "Tarefa com id: #{id} alterada com sucesso")
        |> redirect(to: Routes.tarefa_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, tarefas: atributo_antigo

    end
  end

  def delete(conn, params) do

    %{"id"=> id} = params

    Repo.get(Tarefa, id)
    |> Repo.delete!

    conn
    |>put_flash(:info, "Usuario com id: #{id} deletado com sucesso")
    |> redirect(to: Routes.tarefa_path(conn, :index))
  end


end
