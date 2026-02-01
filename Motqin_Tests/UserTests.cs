using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Dtos.User;
using Motqin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Threading.Tasks;
using Motqin.Enums;

namespace Motqin_Tests;

public class UserTests : IntegrationTestBase
{
    public UserTests(ApiFactory<AppDbContext> factory) : base(factory) { }

    [Fact]
    public async Task GetAll_ReturnsOkWithCorrectData()
    {
        // Act
        var response = await Client.GetAsync("/api/users"); // Adjust path if needed

        // Assert
        response.EnsureSuccessStatusCode();

        var returnedUsers = await response.Content.ReadFromJsonAsync<List<UserReadDto>>();

        Assert.NotNull(returnedUsers);
        Assert.Equal(2, returnedUsers.Count);

        // Verify specific data 
        var Ahmed = returnedUsers.FirstOrDefault(u => u.Name == "Ahmed Hassan");
        Assert.NotNull(Ahmed);
        Assert.Equal("ahmed@student.com", Ahmed.Email);
        Assert.Equal("Egypt", Ahmed.Country);
    }

    [Fact]
    public async Task GetById_UserExists_ReturnsOkAndCorrectUser()
    {
        // Arrange
        var user = new User
        {
            Name = "Dodo Hesham",
            Email = "dodo@example.com",
            PasswordHash = "hashedpassword",
            Role = "Student",
            Country = "Egypt",
            EducationalStage = EducationalStage.Secondary,
            GradeLevel = GradeLevel.Second
        };
        DbContext.Users.Add(user);
        await DbContext.SaveChangesAsync();
        // Act
        var response = await Client.GetAsync($"/api/users/{user.UserId}");

        // Assert
        response.EnsureSuccessStatusCode();
        var returnedUser = await response.Content.ReadFromJsonAsync<UserReadDto>();

        Assert.NotNull(returnedUser);
        Assert.Equal(user.UserId, returnedUser.UserId);
        Assert.Equal(user.Name, returnedUser.Name);
    }

    [Fact]
    public async Task GetById_UserDoesNotExist_ReturnsNotFound()
    {
        // Arrange
        int nonExistentId = 999999;

        // Act
        var response = await Client.GetAsync($"/api/users/{nonExistentId}");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Create_ValidUser_ReturnsCreatedAndPersistsData()
    {
        // Arrange
        var newUser = new
        {
            Name = "Hadi Hesham",
            Email = "hadi@test.com",
            Password = "strongPassword",
            Role = "Student",
            Country = "Egypt",
            GradeLevel = 3,
            EducationalStage = 3
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/users", newUser);

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.Created, response.StatusCode);

        var returnedDto = await response.Content.ReadFromJsonAsync<UserReadDto>();
        Assert.NotNull(returnedDto);
        Assert.True(returnedDto.UserId > 0);
        Assert.Equal(newUser.Name, returnedDto.Name);

        // 3. Verify the Location Header (points to GetById)
        Assert.NotNull(response.Headers.Location);
        Assert.Contains("/api/users/" + returnedDto.UserId,response.Headers.Location.ToString(),StringComparison.OrdinalIgnoreCase);
        // 4. Verify Database Persistence
        var dbUser = await DbContext.Users.FirstOrDefaultAsync(u => u.Email == newUser.Email);
        Assert.NotNull(dbUser);
        Assert.Equal(newUser.Name, dbUser.Name);

        // Crucial: Check that the password was actually hashed and not saved as plain text!
        Assert.NotEqual(newUser.Password, dbUser.PasswordHash);
    }
    [Theory]
    [InlineData("invalid-email")] 
    [InlineData("invalid-password")]        
    [InlineData("invaliv-name")]             
    public async Task Create_InvalidData_ReturnsBadRequest(string invalidValue)
    {
        // Arrange 
        var badUser = new
        {
            Name = invalidValue == "invaliv-name" ? "" : "Hadi",
            Email = invalidValue == "invalid-email" ? invalidValue : "hadi@test.com",
            Password = invalidValue == "invalid-password" ? "123" : "strongPassword"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/users", badUser);

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task Update_ValidUser_ReturnsNoContent_AndUpdatesDatabase()
    {
        // Arrange
        var originalUser = new User
        {
            Name = "Amgad",
            Email = "amgad@test.com",
            Role = "Student",
            GradeLevel = GradeLevel.Third,
            Country = "Egypt",
            EducationalStage = EducationalStage.Secondary
        };
        DbContext.Users.Add(originalUser);
        await DbContext.SaveChangesAsync();

        // Detach the entity so the API has to fetch its own copy
        DbContext.Entry(originalUser).State = EntityState.Detached;

        var updateDto = new { Name = "Amged", Role = "Admin", GradeLevel = 3 };

        // Act
        var response = await Client.PutAsJsonAsync($"/api/users/{originalUser.UserId}", updateDto);

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify database was actually updated
        var updatedDbUser = await DbContext.Users.FindAsync(originalUser.UserId);
        Assert.NotNull(updatedDbUser);
        Assert.Equal("Amged", updatedDbUser.Name);
        Assert.Equal("Admin", updatedDbUser.Role);
        Assert.Equal(GradeLevel.Third, updatedDbUser.GradeLevel);

        // Verify fields NOT in DTO remained the same
        Assert.Equal("amgad@test.com", updatedDbUser.Email);
    }

    [Fact]
    public async Task Delete_UserExists_ReturnsNoContent_AndRemovesFromDb()
    {
        // 1. Arrange: Seed a user
        var userToDelete = new User
        {
            Name = "Delete Me",
            Email = "delete@test.com",
            PasswordHash = "hashed",
            Role = "Student",
            Country = "Egypt"
        };
        DbContext.Users.Add(userToDelete);
        await DbContext.SaveChangesAsync();

        // Detach to ensure we aren't looking at a cached version in the next step
        DbContext.Entry(userToDelete).State = EntityState.Detached;

        // 2. Act: Call the Delete endpoint
        var response = await Client.DeleteAsync($"/api/users/{userToDelete.UserId}");

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify the database is empty for this ID
        var deletedUser = await DbContext.Users.FindAsync(userToDelete.UserId);
        Assert.Null(deletedUser);
    }

    [Fact]
    public async Task Delete_UserDoesNotExist_ReturnsNotFound()
    {
        // Arrange
        int nonExistentId = 8888;

        // Act
        var response = await Client.DeleteAsync($"/api/users/{nonExistentId}");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }
}
