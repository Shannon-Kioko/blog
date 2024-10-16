defmodule Bloggy.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bloggy.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      first_name: "John",
      last_name: "Doe",
      email: unique_user_email(),
      password: valid_user_password(),
      phone: "1234567890",
      role: :user,
      confirmed_at: ~N[2023-09-12 00:00:00]
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Bloggy.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{})
      |> Bloggy.Accounts.create_profile()

    profile
  end
end
