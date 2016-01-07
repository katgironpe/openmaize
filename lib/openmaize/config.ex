defmodule Openmaize.Config do
  @moduledoc """
  This module provides an abstraction layer for configuration.

  The following are valid configuration items.

  | name               | type    | default  |
  | :----------------- | :------ | -------: |
  | user_model         | module  | N/A      |
  | repo               | module  | N/A      |
  | unique_id          | string  | "name"   |
  | crypto_mod         | atom    | :bcrypt  |
  | token_alg          | atom    | :sha512  |
  | keyrotate_days     | int     | 28       |
  | redirect_pages     | map     | %{"admin" => "/admin", "login" => "/login"} |

  The values for user_model and repo should be module names.
  If, for example, your app is called Coolapp and your user
  model is called User, then `user_model` should be
  Coolapp.User and `repo` should be Coolapp.Repo.

  ## Examples

  The simplest way to change the default values would be to add
  the following to the `config.exs` file in your project.

      config :openmaize,
        user_model: Coolapp.User,
        repo: Coolapp.Repo,
        unique_id: "email",
        crypto_mod: :pbkdf2,
        token_alg: :sha256,
        keyrotate_days: 7,
        redirect_pages: %{"admin" => "/admin", "login" => "/admin/login"}

  """

  @doc """
  The user model name.
  """
  def user_model do
    Application.get_env(:openmaize, :user_model)
  end

  @doc """
  The repo name.
  """
  def repo do
    Application.get_env(:openmaize, :repo)
  end

  @doc """
  The unique identifier for the user model.

  This is the unique identifier in your user model. The default is "name".
  """
  def unique_id do
    Application.get_env(:openmaize, :unique_id, "name")
  end

  @doc """
  The password hashing and checking algorithm. You can choose between
  bcrypt and pbkdf2_sha512. Bcrypt is the default.

  For more information about these two algorithms, see the documentation
  for Comeonin.
  """
  def get_crypto_mod do
    case crypto_mod do
      :pbkdf2 -> Comeonin.Pbkdf2
      _ -> Comeonin.Bcrypt
    end
  end
  defp crypto_mod do
    Application.get_env(:openmaize, :crypto_mod, :bcrypt)
  end

  @doc """
  The algorithm used to sign the token.

  The default value is :sha512, and :sha256 is also supported.
  """
  def get_token_alg do
    case token_alg do
      :sha256 -> {"HS256", :sha256}
      _ -> {"HS512", :sha512}
    end
  end
  defp token_alg do
    Application.get_env(:openmaize, :token_alg, :sha512)
  end

  @doc """
  The number of days after which the JWT signing keys will be rotated.
  """
  def keyrotate_days do
    Application.get_env(:openmaize, :keyrotate_days, 28)
  end

  @doc """
  The pages users should be redirected to after logging in or if there
  is an error.

  This is a map where the key is the role of the user and the value is
  the page to be redirected to.

  There is also a "login" key, which refers to the login page that
  unauthorized users shoud be redirected to.
  """
  def redirect_pages do
    Map.merge(%{"login" => "/login"},
    Application.get_env(:openmaize, :redirect_pages, %{"admin" => "/admin"}))
  end

end
