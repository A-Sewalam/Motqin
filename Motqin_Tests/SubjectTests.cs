using Motqin.Data;
using Motqin.Enums;
using Motqin.Models;
using System.Net.Http.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Motqin_Tests;

public class SubjectTests : IntegrationTestBase
{
    public SubjectTests(ApiFactory<AppDbContext> factory) : base(factory) { }

    [Fact]
    public async Task GetById_SubjectExists_ReturnsOkAndCorrectData()
    {
        // 1. Arrange: Seed a Subject
        var subject = new Subject
        {
            Name = "Mathematics",
            Country = "Egypt",
            EducationalStage = EducationalStage.Secondary,
            GradeLevel = GradeLevel.Third
        };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        // 2. Act
        var response = await Client.GetAsync($"/api/subjects/{subject.SubjectID}");

        // 3. Assert
        response.EnsureSuccessStatusCode();
        var returnedSubject = await response.Content.ReadFromJsonAsync<Subject>();

        Assert.NotNull(returnedSubject);
        Assert.Equal(subject.Name, returnedSubject.Name);
        Assert.Equal(subject.SubjectID, returnedSubject.SubjectID);
    }
    [Fact]
    public async Task GetById_SubjectDoesNotExist_ReturnsNotFound()
    {
        // Act
        var response = await Client.GetAsync("/api/subjects/99999");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task GetSubjectsByUserGradeLevel_ReturnsOnlyRelevantSubjects()
    {
        // 1. Arrange: Seed Subjects for different grades
        var matchSubject = new Subject { Name = "Math Grade 3", GradeLevel = GradeLevel.Second, Country = "Egypt" , EducationalStage = EducationalStage.Secondary};
        var wrongSubject = new Subject { Name = "History Grade 5", GradeLevel = GradeLevel.First, Country = "Egypt", EducationalStage = EducationalStage.Secondary };
        DbContext.Subjects.AddRange(matchSubject, wrongSubject);

        // 2. Arrange: Seed a User with a specific GradeLevel
        var user = new User
        {
            UserName = "Hadi",
            Email = "hadi@test.com",
            GradeLevel = GradeLevel.Second, // Matches "Math Grade 3"
            Country = "Egypt",
            EducationalStage = EducationalStage.Secondary
        };
        DbContext.Users.Add(user);
        await DbContext.SaveChangesAsync();

        // 3. Act
        var response = await Client.GetAsync($"/api/subjects/get-subjects-by-user-grade-level?userId={user.Id}");

        // 4. Assert
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadFromJsonAsync<List<Subject>>();

        Assert.NotNull(result);
        Assert.Single(result); // Only 1 subject should match
        Assert.Equal("Math Grade 3", result[0].Name);
        Assert.DoesNotContain(result, s => s.Name == "History Grade 5");
    }

    [Fact]
    public async Task GetSubjectsByUserGradeLevel_UserNotFound_ReturnsNotFound()
    {
        // Act
        var response = await Client.GetAsync("/api/subjects/get-subjects-by-user-grade-level?userId=9999");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Create_ValidSubject_ReturnsCreatedAndPersistsData()
    {
        // Arrange
        var newSubjectDto = new
        {
            Name = "Maths",
            Country = "Egypt",
            EducationalStage = 1, // Primary
            GradeLevel = 3        // Third
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/subjects", newSubjectDto);

        // Assert
        // 1. Check Status Code
        Assert.Equal(System.Net.HttpStatusCode.Created, response.StatusCode);

        // 2. Check Response Body
        var returnedSubject = await response.Content.ReadFromJsonAsync<Subject>();
        Assert.NotNull(returnedSubject);
        Assert.Equal(newSubjectDto.Name, returnedSubject.Name);
        Assert.True(returnedSubject.SubjectID > 0);

        // 3. Check Location Header
        Assert.NotNull(response.Headers.Location);
        Assert.Contains($"/api/subjects/{returnedSubject.SubjectID}",response.Headers.Location.ToString(),StringComparison.OrdinalIgnoreCase);

        // 4. Verify in Database
        var dbSubject = await DbContext.Subjects.FindAsync(returnedSubject.SubjectID);
        Assert.NotNull(dbSubject);
        Assert.Equal(newSubjectDto.Name, dbSubject.Name);
    }

    [Theory]
    [InlineData("invalid-name")]
    [InlineData("invalid-country")]
    [InlineData("invalid-estage")]
    [InlineData("invalid-glevel")]
    public async Task Create_InValidSubject_ReturnsBadRequest(string invalid)
    {
        //Arrange
        var newSubjectDto = new
        {
            Name = invalid == "invalid-name" ? "" : "Maths",
            Country = invalid == "invalid-country" ? "" : "Egypt",
            EducationalStage = invalid == "invalid-estage" ? 7 : 1, // Primary
            GradeLevel = invalid == "invalid-glevel" ? 7 : 3        // Third
        };
        //Act
        var response = await Client.PostAsJsonAsync("/api/Subjects", newSubjectDto);
        //Assert
        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);

    }

    [Fact]
    public async Task Update_ValidSubject_ReturnsNoContent_AndUpdatesDb()
    {
        // 1. Arrange: Seed a subject to update
        var originalSubject = new Subject
        {
            Name = "Old Math",
            Country = "Egypt",
            EducationalStage = EducationalStage.Primary,
            GradeLevel = GradeLevel.First
        };
        DbContext.Subjects.Add(originalSubject);
        await DbContext.SaveChangesAsync();

        // Clear tracker to ensure we aren't testing local memory
        DbContext.ChangeTracker.Clear();

        var updateDto = new
        {
            Name = "Advanced Math",
            Country = "Egypt",
            EducationalStage = (int)EducationalStage.Secondary,
            GradeLevel = (int)GradeLevel.Third
        };

        // 2. Act
        var response = await Client.PutAsJsonAsync($"/api/subjects/{originalSubject.SubjectID}", updateDto);

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify changes in Database
        var dbSubject = await DbContext.Subjects.FindAsync(originalSubject.SubjectID);
        Assert.NotNull(dbSubject);
        Assert.Equal("Advanced Math", dbSubject.Name);
        Assert.Equal(GradeLevel.Third, dbSubject.GradeLevel);
    }

    [Fact]
    public async Task Update_NonExistentSubject_ReturnsNotFound()
    {
        // Arrange
        var updateDto = new { Name = "Ghost", Country = "Egypt", EducationalStage = 1, GradeLevel = 1 };

        // Act
        var response = await Client.PutAsJsonAsync("/api/subjects/99999", updateDto);

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Delete_SubjectExists_ReturnsNoContent_AndCleansUpDatabase()
    {
        // 1. Arrange: Seed a Subject and a dependent Lesson
        var subject = new Subject { Name = "History", Country = "Egypt", GradeLevel = GradeLevel.First , EducationalStage = EducationalStage.Prepratory};
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "Ancient Egypt", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        // Clear tracker to ensure we fetch fresh data from DB for assertions
        DbContext.ChangeTracker.Clear();

        // 2. Act
        var response = await Client.DeleteAsync($"/api/subjects/{subject.SubjectID}");

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify Subject is gone
        var dbSubject = await DbContext.Subjects.FindAsync(subject.SubjectID);
        Assert.Null(dbSubject);

        // Verify Lesson is also gone (Testing Cascade Delete)
        var dbLesson = await DbContext.Lessons.FindAsync(lesson.LessonID);
        Assert.Null(dbLesson);
    }
}
