defmodule Hider.Factories.UserFactory do
  alias Hider.Accounts.User

  defmacro __using__(_) do
    quote do
      def user_factory do
        first_name = Faker.Person.PtBr.first_name()
        middle_name = Faker.Person.PtBr.last_name()
        last_name = Faker.Person.PtBr.last_name()

        username = "#{first_name}.#{middle_name}.#{last_name}"
        email = "#{first_name}.#{middle_name}.#{last_name}@email.com"

        password = "admin123"
        salt = Bcrypt.Base.gen_salt()
        password_hash = Bcrypt.Base.hash_password(password, salt)

        %User{
          cpf: Hider.Factories.Helper.generate_cpf(),
          email: email,
          first_name: first_name,
          last_name: last_name,
          middle_name: middle_name,
          password_hash: password_hash,
          password: password,
          rg: Hider.Factories.Helper.generate_rg(),
          username: username
        }
      end
    end
  end
end
