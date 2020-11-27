defmodule TodoAppWeb.AuthController do
  use TodoAppWeb, :controller
  alias TodoApp.Usuario
  alias TodoApp.Repo
  plug Ueberauth

  def callback(conn, params) do

    %{"provider" => provider}=params
    %{assigns: %{ueberauth_auth: auth}}=conn

    usuario = %{name: auth.info.name, email: auth.info.email, token: auth.credentials.token, provider: provider}
    changeset = Usuario.changeset(%Usuario{},usuario)

    logar(conn, changeset)
  end

  defp logar(conn, changeset) do
    case insere_ou_busca(changeset) do
      {:ok, usuario} ->
        conn
        |> put_flash(:info, "Bem Vindo #{usuario.email}")
        |> put_session(:user_id, usuario.id)
        |> redirect(to: Routes.tarefa_path(conn, :index))
      {:error, motivo_erro} ->
        IO.inspect(motivo_erro)
        conn
        |> put_flash(:error, "Houve um problema na requisição")
        |> redirect(to: Routes.tarefa_path(conn, :index))
    end
  end

  defp insere_ou_busca(changeset) do
     %{changes: %{email:  email}} = changeset
    case Repo.get_by(Usuario, email: email) do
      nil -> Repo.insert(changeset)
      usuario -> {:ok, usuario}
    end
  end

  def logout(conn, params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.tarefa_path(conn, :index))
  end
end
