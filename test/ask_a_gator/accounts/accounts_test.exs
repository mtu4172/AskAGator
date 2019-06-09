defmodule AskAGator.AccountsTest do
  @moduledoc """
    Tests the Accounts Context and the Users schema
  """
  use AskAGator.DataCase

  alias AskAGator.Accounts

  describe "users" do
    alias AskAGator.Accounts.User

    @valid_attrs %{email: "some@email.com", name: "some name", password: "some password", password_confirmation: "some password"}
    @update_attrs %{email: "some@email.net", name: "some updated name", password: "some password", password_confirmation: "some password"}
    @invalid_attrs %{email: nil, name: nil, password: nil, password_confirmation: nil, token: nil}
    @non_matching_password_attrs %{
      email: "some@email.com",
      name: "some name",
      password: "some password",
      password_confirmation: "not some password"
    }
    @invalid_email_attrs %{
      email: "some invalid email.com",
      name: "some name",
      password: "some password",
      password_confirmation: "some password"
    }
    @invalid_password_length_attrs %{
      email: "some@email.com",
      name: "some name",
      password: "some",
      password_confirmation: "some"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "changeset/2 is valid with @valid_attrs" do
      user = %User{}
      assert User.changeset(user, @valid_attrs).valid?
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert List.first(Accounts.list_users()).email == user.email
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.password_confirmation == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some@email.net"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.email == Accounts.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "changeset/2 verifies password = password_confirmation" do
      user = %User{}
      assert not User.changeset(user, @non_matching_password_attrs).valid?
    end

    test "changeset/2 validates email format" do
      assert not User.changeset(%User{}, @invalid_email_attrs).valid?
    end

    test "changeset/2 validates password length" do
      assert not User.changeset(%User{}, @invalid_password_length_attrs).valid?
    end

    test "changeset/2 validates email uniqueness" do
      _user = user_fixture()
      {:error, %{errors: errors}} = Accounts.create_user(@valid_attrs)
      assert errors[:email]
    end

    test "changeset/2 validates token uniqueness" do
      _user1 = user_fixture(%{token: "test"})
      user2 = user_fixture(%{email: "test2@test.com"})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user2, %{token: "test"})
    end
  end
end
