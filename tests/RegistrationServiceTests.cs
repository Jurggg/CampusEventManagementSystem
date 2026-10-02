using NUnit.Framework;
using Moq;

[TestFixture]
public class RegistrationServiceTest
{
    [Test]
    public void GetUserRegistration_ValidEmail_ReturnsRegistration()
    {
        string email = "student@univ.edu.ph";
        string expected = "Student Registration";

        var mockDatabase = new Mock<IRegistrationDatabase>();

        mockDatabase
            .Setup(db => db.GetRegistration(email))
            .Returns(expected);

        var service = new RegistrationService(mockDatabase.Object);

        string result = service.GetUserRegistration(email);

        Assert.That(result, Is.EqualTo(expected));
    }

    [Test]
    public void GetUserRegistration_InvalidEmail_ReturnsNull()
    {
        string email = "invalid@email.com";

        var mockDatabase = new Mock<IRegistrationDatabase>();

        mockDatabase
            .Setup(db => db.GetRegistration(email))
            .Returns((string)null);

        var service = new RegistrationService(mockDatabase.Object);

        string result = service.GetUserRegistration(email);

        Assert.That(result, Is.Null);
    }

    [Test]
    public void GetUserRegistration_MissingEmail_ReturnsNull()
    {
        string email = "";

        var mockDatabase = new Mock<IRegistrationDatabase>();

        var service = new RegistrationService(mockDatabase.Object);

        string result = service.GetUserRegistration(email);

        Assert.That(result, Is.Null);
    }

    [Test]
    public void GetUserRegistration_UsesProvidedEmail()
    {
        string email = "student@univ.edu.ph";

        var mockDatabase = new Mock<IRegistrationDatabase>();

        mockDatabase
            .Setup(db => db.GetRegistration(email))
            .Returns("Registration Found");

        var service = new RegistrationService(mockDatabase.Object);

        service.GetUserRegistration(email);

        mockDatabase.Verify(
            db => db.GetRegistration(email),
            Times.Once
        );
    }
}