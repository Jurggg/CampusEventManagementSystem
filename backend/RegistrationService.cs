
using Microsoft.Data.SqlClient;

public interface IRegistrationDatabase
{
    string GetRegistration(string email);
}

public class RegistrationService
{
    private readonly IRegistrationDatabase database;

    public RegistrationService(IRegistrationDatabase database)
    {
        this.database = database;
    }

    public string GetUserRegistration(string inputEmail)
    {
        if (string.IsNullOrEmpty(inputEmail))
        {
            return null;
        }

        return database.GetRegistration(inputEmail);
    }
}

public class RegistrationDatabase : IRegistrationDatabase
{
    private readonly string connStr =
        "Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=myPassword;";

    public string GetRegistration(string email)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            string query =
                "SELECT * FROM Registrations WHERE Email = @Email";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);

                object result = cmd.ExecuteScalar();

                return result?.ToString();
            }
        }
    }
}
