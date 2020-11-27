defmodule TodoApp.Usuario do
  use Ecto.Schema
  import Ecto.Changeset

  schema("usuarios")do
    field :name, :string
    field :email, :string
    field :token, :string
    field :provider, :string
    timestamps()
  end

  def changeset(conn, params \\%{}) do
    IO.inspect(params)
    conn
    |> cast(params,[:name, :email, :token, :provider])
    |> validate_required([:name, :email, :token, :provider])
  end
end
