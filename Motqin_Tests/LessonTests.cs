using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Dtos.Lesson;
using Motqin.Enums;
using Motqin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Threading.Tasks;

namespace Motqin_Tests;
public class LessonTests : IntegrationTestBase
{
    public LessonTests(ApiFactory<AppDbContext> factory) : base(factory) { }

    [Fact]
    public async Task GetBySubjectId_ReturnsOnlyLessonsForThatSubject()
    {
        // 1. Arrange: Seed a Subject
        var mathSubject = new Subject { Name = "Mathematics" , Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third};
        DbContext.Subjects.Add(mathSubject);
        await DbContext.SaveChangesAsync(); // Generates mathSubject.SubjectID

        // 2. Arrange: Seed Lessons for Math and one for Science
        var scienceSubject = new Subject { Name = "Science" , Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(scienceSubject);
        await DbContext.SaveChangesAsync();

        var lessons = new List<Lesson>
    {
        new Lesson { Title = "Algebra 101", SubjectID = mathSubject.SubjectID },
        new Lesson { Title = "Geometry Basics", SubjectID = mathSubject.SubjectID },
        new Lesson { Title = "Photosynthesis", SubjectID = scienceSubject.SubjectID } // Should NOT be returned
    };
        DbContext.Lessons.AddRange(lessons);
        await DbContext.SaveChangesAsync();

        // 3. Act: Request lessons specifically for Math
        var response = await Client.GetAsync($"/api/lessons?subjectId={mathSubject.SubjectID}");
        // Note: Adjust the URL above if your route is different, e.g., "/api/subjects/{id}/lessons"

        // 4. Assert
        response.EnsureSuccessStatusCode();
        var returnedLessons = await response.Content.ReadFromJsonAsync<List<LessonReadDto>>();

        Assert.NotNull(returnedLessons);
        Assert.Equal(2, returnedLessons.Count); // Should only get the 2 Math lessons
        Assert.All(returnedLessons, l => Assert.Equal(mathSubject.SubjectID, l.SubjectID));
        Assert.Contains(returnedLessons, l => l.Title == "Algebra 101");
        Assert.DoesNotContain(returnedLessons, l => l.Title == "Photosynthesis");
    }

    [Fact]
    public async Task GetById_LessonExists_ReturnsOkAndCorrectData()
    {
        // 1. Arrange: Seed the Subject dependency first
        var subject = new Subject { Name = "Physics" , Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        // 2. Seed the Lesson
        var testLesson = new Lesson
        {
            Title = "Quantum Mechanics",
            SubjectID = subject.SubjectID
        };
        DbContext.Lessons.Add(testLesson);
        await DbContext.SaveChangesAsync();

        // 3. Act
        var response = await Client.GetAsync($"/api/lessons/{testLesson.LessonID}");

        // 4. Assert
        response.EnsureSuccessStatusCode();
        var returnedDto = await response.Content.ReadFromJsonAsync<LessonReadDto>();

        Assert.NotNull(returnedDto);
        Assert.Equal(testLesson.LessonID, returnedDto.LessonId);
        Assert.Equal(testLesson.Title , returnedDto.Title);
        Assert.Equal(subject.SubjectID, returnedDto.SubjectID);
    }

    [Fact]
    public async Task GetById_LessonDoesNotExist_ReturnsNotFound()
    {
        // Act
        var response = await Client.GetAsync("/api/lessons/99999");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Create_ValidLesson_ReturnsCreatedAndPersistsData()
    {
        // 1. Arrange: We must have a Subject first
        var subject = new Subject {Name = "Chemistry", Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var newLessondto = new
        {
            Title = "Periodic Table Basics",
            SubjectID = subject.SubjectID
        };

        // 2. Act
        var response = await Client.PostAsJsonAsync("/api/lessons", newLessondto);

        // 3. Assert
        // Verify Status Code
        Assert.Equal(System.Net.HttpStatusCode.Created, response.StatusCode);

        // Verify Response Body
        var returnedDto = await response.Content.ReadFromJsonAsync<LessonReadDto>();
        Assert.NotNull(returnedDto);
        Assert.Equal(newLessondto.Title, returnedDto.Title);
        Assert.Equal(subject.SubjectID, returnedDto.SubjectID);
        Assert.True(returnedDto.LessonId > 0);

        // Verify Location Header
        Assert.NotNull(response.Headers.Location);
        Assert.Contains($"/api/lessons/{returnedDto.LessonId}",response.Headers.Location.ToString(),StringComparison.OrdinalIgnoreCase);

        // 4. Verify Database Persistence
        var dbLesson = await DbContext.Lessons.FirstOrDefaultAsync(l => l.LessonID == returnedDto.LessonId);

        Assert.NotNull(dbLesson);
        Assert.Equal(subject.SubjectID, dbLesson.SubjectID);
    }

    [Theory]
    [InlineData("invalid-title")]
    [InlineData("invalid-id")]
    public async Task Create_InvalidData_ReturnsBadRequest(string inValid)
    {
        // Arrange: Valid Subject, but invalid Lesson data
        var subject = new Subject {Name = "Biology", Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var invalidLesson = new { 
            Title = inValid == "invalid-title" ? "" : "Carbohydrates", 
            SubjectID = inValid == "invalid-id" ? 8888 : subject.SubjectID };

        // Act
        var response = await Client.PostAsJsonAsync("/api/lessons", invalidLesson);

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task Update_ValidData_UpdatesDatabaseAndReturnsNoContent()
    {
        // 1. Arrange: Seed two subjects and one lesson
        var subject1 = new Subject { Name = "Math" , Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        var subject2 = new Subject { Name = "Science", Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.AddRange(subject1, subject2);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "Old Title", SubjectID = subject1.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        // Detach to avoid EF tracking issues in the test
        DbContext.Entry(lesson).State = EntityState.Detached;

        var updateDto = new { Title = "New Title", SubjectID = subject2.SubjectID };

        // 2. Act
        var response = await Client.PutAsJsonAsync($"/api/lessons/{lesson.LessonID}", updateDto);

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify the changes in the DB
        var updatedLesson = await DbContext.Lessons.FindAsync(lesson.LessonID);
        Assert.Equal("New Title", updatedLesson.Title);
        Assert.Equal(subject2.SubjectID, updatedLesson.SubjectID);
    }

    [Theory]
    [InlineData("invalid-title")]
    [InlineData("invalid-subjectid")]
    public async Task Update_InvalidData_ReturnsBadRequest(string invalid)
    {
        // Arrange: Seed a lesson
        var subject = new Subject { Name = "History", Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "WWII", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        var badUpdate = new { Title = invalid == "invalid-title"? "" : "Updated", SubjectID = invalid == "invalid-subjectid" ? 9999 : lesson.SubjectID }; // Invalid ID

        // Act
        var response = await Client.PutAsJsonAsync($"/api/lessons/{lesson.LessonID}", badUpdate);

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task Delete_LessonExists_ReturnsNoContent_AndSubjectRemains()
    {
        // 1. Arrange: Seed Subject and Lesson
        var subject = new Subject { Name = "Art History", Country = "Egypt", EducationalStage = EducationalStage.Secondary, GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "The Renaissance", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        // 2. Act
        var response = await Client.DeleteAsync($"/api/lessons/{lesson.LessonID}");

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify Lesson is deleted
        var exists = await DbContext.Lessons.AnyAsync(l => l.LessonID == lesson.LessonID);
        Assert.False(exists);
        // Verify Subject still exists (Critical check!)
        var parentSubject = await DbContext.Subjects.FindAsync(subject.SubjectID);
        Assert.NotNull(parentSubject);
    }

    [Fact]
    public async Task Delete_LessonDoesNotExist_ReturnsNotFound()
    {
        // Act
        var response = await Client.DeleteAsync("/api/lessons/99999");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }
}
